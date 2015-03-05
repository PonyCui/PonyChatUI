//
//  PCUChatViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUChatViewController.h"
#import "PCUToolViewController.h"
#import "PCUApplication.h"
#import "PCUWireframe.h"
#import "PCUChatPresenter.h"
#import "PCUChatInteractor.h"
#import "PCUNodeInteractor.h"
#import "PCUNodePresenter.h"

@interface PCUChatViewController ()<UIScrollViewDelegate> {
    CGFloat _contentHeight;
    CGSize _contentSize;
}

@property (nonatomic, strong) NSArray *nodeViewControllers;

@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (nonatomic, weak) NSLayoutConstraint *toolViewBottomSpaceConstraint;

@property (nonatomic, weak) NSLayoutConstraint *toolViewHeightConstraint;

@end

@implementation PCUChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureToolView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadData {
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PCUNodeViewController class]] &&
            [obj.view superview] == nil) {
            [self.contentView addSubview:obj.view];
//            [self.chatScrollView addSubview:obj.view];
            [(PCUNodeViewController *)obj configureLayouts];
        }
    }];
    [self configureNodeLayouts];
    CGPoint contentOffset = self.chatScrollView.contentOffset;
    [self updateContentHeight];
    [self updateContentSize];
    if ([self shouldAutomaticallyScrollToBottomWithContentOffset:contentOffset]) {
        [self scrollToBottom:YES];
    }
}

#pragma mark - ToolViewController

- (void)configureToolView {
    PCUWireframe *wireFrame = PCU[[PCUWireframe class]];
    [wireFrame presentToolViewToChatViewController:self];
}

#pragma mark - ContentOffset

- (void)scrollToBottom:(BOOL)animated {
    if (self.chatScrollView.isTracking) {
        return;
    }
    [self.chatScrollView scrollRectToVisible:CGRectMake(0, _contentHeight-1, 1, 1) animated:animated];
}

- (BOOL)shouldAutomaticallyScrollToBottomWithContentOffset:(CGPoint)contentOffset {
    if (_contentSize.height - contentOffset.y > CGRectGetHeight(self.chatScrollView.bounds) * 2) {
        return NO;//用户向上滑动两屏以上，禁用自动滚动功能
    }
    else {
        return YES;
    }
}

#pragma mark - ContentSize

- (void)updateContentHeight {
    __block CGFloat contentHeight = 0.0;
    [[self childViewControllers] enumerateObjectsUsingBlock:^(PCUNodeViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PCUNodeViewController class]]) {
            contentHeight += obj.heightConstraint.constant;
        }
    }];
    _contentHeight = contentHeight;
}

- (void)updateContentSize {
    if (_contentHeight <= CGRectGetHeight(self.chatScrollView.bounds)) {
        _contentSize = CGSizeMake(CGRectGetWidth(self.chatScrollView.bounds),
                                  CGRectGetHeight(self.chatScrollView.bounds) + 1);
    }
    else {
        _contentSize = CGSizeMake(CGRectGetWidth(self.chatScrollView.bounds), _contentHeight);
    }
    [self.chatScrollView setContentSize:_contentSize];
}

- (void)nodeViewHeightDidChange {
    CGPoint contentOffset = self.chatScrollView.contentOffset;
    [self updateContentHeight];
    [self updateContentSize];
    if ([self shouldAutomaticallyScrollToBottomWithContentOffset:contentOffset]) {
        [self scrollToBottom:YES];
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self.chatScrollView setContentSize:CGSizeMake(CGRectGetHeight(self.view.bounds),
                                                       CGRectGetWidth(self.view.bounds))];
    }
    else {
        [self.chatScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds),
                                                       CGRectGetHeight(self.view.bounds))];
    }
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self updateContentSize];
    [self scrollToBottom:NO];
}

#pragma mark - Layouts

- (void)setBottomLayoutHeight:(CGFloat)layoutHeight {
    self.toolViewBottomSpaceConstraint.constant = layoutHeight;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        [self scrollToBottom:NO];
    } completion:nil];
}

- (void)setToolViewLayoutHeight:(CGFloat)layoutHeight {
    self.toolViewHeightConstraint.constant = layoutHeight;
}

- (void)configureViewLayouts {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.chatScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"toolView": self.toolViewController.view,
                            @"chatView": self.chatScrollView,
                            @"wrapView": self.view};
    {
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[wrapView]-0-|"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views];
        [[self.view superview] addConstraints:constraints];
        
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[wrapView]-0-|"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views];
        [[self.view superview] addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatView]-0-[toolView(48)]-0-|"
                                                                        options:kNilOptions
                                                                        metrics:nil
                                                                          views:views];
        [self.view addConstraints:constraints];
        self.toolViewBottomSpaceConstraint = constraints[2];
        self.toolViewHeightConstraint = constraints[1];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[toolView]-0-|"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views];
        [self.view addConstraints:constraints];
    }
}

- (void)configureNodeLayouts {
    NSArray *nodeEventHandlers = [self.eventHandler orderedEventHandler];
    __block PCUNodeViewController *previousViewController;
    [nodeEventHandlers enumerateObjectsUsingBlock:^(PCUNodePresenter *obj, NSUInteger idx, BOOL *stop) {
        PCUNodeViewController *nodeViewController = obj.userInterface;
        if (idx == 0) {
            if (nodeViewController.topConstraint.firstItem != nodeViewController.view) {
                [self.chatScrollView removeConstraint:nodeViewController.topConstraint];
                NSLayoutConstraint *constaints = [NSLayoutConstraint constraintWithItem:nodeViewController.view
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.contentView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0.0];
                nodeViewController.topConstraint = constaints;
                [self.contentView addConstraint:nodeViewController.topConstraint];
            }
        }
        else {
            if (nodeViewController.topConstraint.firstItem != previousViewController.view) {
                [self.contentView removeConstraint:nodeViewController.topConstraint];
                nodeViewController.topConstraint = [NSLayoutConstraint constraintWithItem:previousViewController.view
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nodeViewController.view
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.0
                                                                                 constant:0.0];
                [self.contentView addConstraint:nodeViewController.topConstraint];
            }
        }
        if (idx == [nodeEventHandlers count] - 1) {
            //Add Bottom Contraint
            [self.contentView removeConstraint:nodeViewController.bottomConstraint];
            nodeViewController.bottomConstraint = [NSLayoutConstraint constraintWithItem:nodeViewController.view
                                                                               attribute:NSLayoutAttributeBottom
                                                                               relatedBy:NSLayoutRelationEqual
                                                                                  toItem:self.contentView
                                                                               attribute:NSLayoutAttributeBottom
                                                                              multiplier:1.0
                                                                                constant:0.0];
            [self.contentView addConstraint:nodeViewController.bottomConstraint];
        }
        else {
            [self.contentView removeConstraint:nodeViewController.bottomConstraint];
        }
        previousViewController = nodeViewController;
    }];
    [self.view layoutIfNeeded];
}

#pragma mark - handle events

- (IBAction)handleScrollViewTapped:(UITapGestureRecognizer *)sender {
    [PCUApplication endEditing];
}

@end
