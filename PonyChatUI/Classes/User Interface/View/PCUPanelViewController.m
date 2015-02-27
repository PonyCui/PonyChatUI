//
//  PCUPanelViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-17.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelViewController.h"
#import "PCUChatViewController.h"
#import "PCUToolViewController.h"
#import "PCUPanelPresenter.h"
#import "PCUPanelInteractor.h"
#import "PCUPanelCollectionViewCell.h"
#import "PCUPanelItemPresenter.h"
#import "PCUApplication.h"

#define kPCUKeyboardIdentifier @"kPCUKeyboardIdentifier"

@interface PCUPanelViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) NSLayoutConstraint *viewHeightConstraint;

@property (nonatomic, weak) NSLayoutConstraint *bottomSpaceConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *collectionViewLayout;

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation PCUPanelViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.scrollsToTop = NO;
    _isPresenting = NO;
    [self.eventHandler updateView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureLayoutInset];
    [self reloadCollectionView];
}

- (void)reloadCollectionView {
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - toggle

- (void)setIsPresenting:(BOOL)isPresenting {
    _isPresenting = isPresenting;
    isPresenting ?
    [self performSelector:@selector(presentPanel) withObject:nil afterDelay:0.001] :
    [self performSelector:@selector(dismissPanel) withObject:nil afterDelay:0.001];
}

- (void)presentPanel {
    self.bottomSpaceConstraint.constant = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)dismissPanel {
    self.bottomSpaceConstraint.constant = -self.viewHeightConstraint.constant;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Layouts

- (void)configureViewLayouts {
    if (self.viewHeightConstraint == nil && self.bottomSpaceConstraint == nil) {
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *views = @{
                                @"wrapView": self.view
                                };
        {
            NSArray *constraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"|-0-[wrapView]-0-|"
                                    options:kNilOptions
                                    metrics:nil
                                    views:views];
            [[self.view superview] addConstraints:constraints];
        }
        {
            NSArray *constraints = [NSLayoutConstraint
                                    constraintsWithVisualFormat:@"V:[wrapView(216)]-(-216)-|"
                                    options:kNilOptions
                                    metrics:nil
                                    views:views];
            self.viewHeightConstraint = [constraints firstObject];
            self.bottomSpaceConstraint = [constraints lastObject];
            [[self.view superview] addConstraints:constraints];
        }
    }
    if (CGRectGetWidth(self.view.bounds) >= 480.0) {
        self.viewHeightConstraint.constant = 126.0;
    }
    else {
        self.viewHeightConstraint.constant = 216.0;
    }
    if (self.isPresenting) {
        self.bottomSpaceConstraint.constant = 0.0;
    }
    else {
        self.bottomSpaceConstraint.constant = -self.viewHeightConstraint.constant;
    }
    [self.view layoutIfNeeded];
}

#pragma mark - UICollectionViewDataSource

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self configureViewLayouts];
    [self configureLayoutInset];
    [self reloadCollectionView];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (NSInteger)ceil((CGFloat)self.eventHandler.panelInteractor.items.count /
                           (CGFloat)[self numberOfCellsPerPage]);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //计算当前宽度最大可容纳Cell数目
    return [self numberOfCellsPerPage];
}

- (NSInteger)numberOfCellsPerPage {
    return [self numberOfCells] * [self numberOfLines];
}

- (NSInteger)numberOfCells {
    return (NSInteger)floor(CGRectGetWidth(self.view.bounds) / (60.0 + 30.0));
}

- (NSInteger)numberOfLines {
    return (NSInteger)floor(CGRectGetHeight(self.view.bounds) / 90.0);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updatePageControl];
    PCUPanelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell"
                                                                                 forIndexPath:indexPath];
    NSUInteger cellIndex = [self cellIndexForIndexPath:indexPath];
    cell.hidden = cellIndex >= self.eventHandler.panelInteractor.items.count;
    if (cellIndex < self.eventHandler.panelInteractor.items.count) {
        id itemInteractor = self.eventHandler.panelInteractor.items[cellIndex];
        cell.eventHandler.itemInteractor = itemInteractor;
    }
    else {
        cell.eventHandler.itemInteractor = nil;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    PCUPanelCollectionViewCell *cell = (PCUPanelCollectionViewCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
    [cell.eventHandler sendAction];
}

- (NSInteger)cellIndexForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger cellIndex = [self numberOfCellsPerPage] * indexPath.section + indexPath.row;
    if ([self numberOfLines] > 1) {
        NSInteger pageInitIndex = [self numberOfCellsPerPage] * indexPath.section;
        NSInteger currentIndex = cellIndex % [self numberOfCellsPerPage];
        NSInteger fixIndex;
        if (currentIndex % [self numberOfLines] == 0) {
            fixIndex = currentIndex / [self numberOfLines];
        }
        else {
            fixIndex = currentIndex + [self numberOfCells] - (currentIndex + 1) / [self numberOfLines];
        }
        cellIndex = pageInitIndex + fixIndex;
    }
    return cellIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updatePageControl];
}

#pragma mark - CollectionViewLayout

- (void)configureLayoutInset {
    NSInteger numberOfCells = [self numberOfCells];
    CGFloat gapWidth = (CGRectGetWidth(self.view.bounds) - 60.0 * numberOfCells) / (numberOfCells + 1);
    self.collectionViewLayout.sectionInset = UIEdgeInsetsMake(14, gapWidth, 0, gapWidth);
    self.collectionViewLayout.minimumLineSpacing = gapWidth;
}

#pragma mark - UIPageControl

- (void)updatePageControl {
    NSInteger numberOfPages = [self numberOfSectionsInCollectionView:self.collectionView];
    NSInteger currentPage = (NSInteger)(self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.bounds));
    [self.pageControl setNumberOfPages:numberOfPages];
    [self.pageControl setCurrentPage:currentPage];
    self.pageControl.hidden = numberOfPages <= 1;
}

@end
