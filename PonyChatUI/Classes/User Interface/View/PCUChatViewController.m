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

@interface PCUChatViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray *nodeViewControllers;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
            [(PCUNodeViewController *)obj configureLayouts];
        }
    }];
    [self configureNodeLayouts];
    if ([self shouldAutomaticallyScroll]) {
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
    if (self.scrollView.isTracking) {
        return;
    }
    [self.scrollView scrollRectToVisible:CGRectMake(0, CGRectGetHeight(self.contentView.bounds)-1, 1, 1) animated:animated];
}

- (BOOL)shouldAutomaticallyScroll {
    if (self.scrollView.contentSize.height - self.scrollView.contentOffset.y >
        CGRectGetHeight(self.scrollView.bounds) * 1.5) {
        return NO;//用户向上滑动1.5屏以上，禁用自动滚动功能
    }
    else {
        return YES;
    }
}

#pragma mark - ContentSize

- (void)nodeViewHeightDidChange {
    if ([self shouldAutomaticallyScroll]) {
        [self scrollToBottom:YES];
    }
}

#pragma mark - Layouts

- (void)setBottomLayoutHeight:(CGFloat)layoutHeight {
    self.toolViewBottomSpaceConstraint.constant = layoutHeight;
    [UIView
     animateKeyframesWithDuration:0.25
     delay:0.0
     options:UIViewKeyframeAnimationOptionBeginFromCurrentState | UIViewKeyframeAnimationOptionLayoutSubviews
     animations:^{
         [self.view layoutIfNeeded];
         [self scrollToBottom:NO];
     }
     completion:^(BOOL finished) {
         
     }];
}

- (void)setToolViewLayoutHeight:(CGFloat)layoutHeight {
    self.toolViewHeightConstraint.constant = layoutHeight;
}

- (void)configureViewLayouts {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"toolView": self.toolViewController.view,
                            @"chatView": self.scrollView,
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
                [self.scrollView removeConstraint:nodeViewController.topConstraint];
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
