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

@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;

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
            [self.chatScrollView addSubview:obj.view];
            [(PCUNodeViewController *)obj configureLayouts];
        }
    }];
    [self configureNodeLayouts];
    [self calculateContentSizeWithCompletionBlock:nil];
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
    CGPoint bottomPoint = CGPointMake(0, self.chatScrollView.contentSize.height -
                                      CGRectGetHeight(self.chatScrollView.bounds));
    [self.chatScrollView setContentOffset:bottomPoint animated:animated];
}

#pragma mark - ContentSize

- (void)nodeViewHeightDidChange {
    [self calculateContentSizeWithCompletionBlock:nil];
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
    [self calculateContentSizeWithCompletionBlock:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self scrollToBottom:YES];
        });
    }];
}

- (void)calculateContentSizeWithCompletionBlock:(void (^)())completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        BOOL isScrollToBottom = self.chatScrollView.contentOffset.y >= self.chatScrollView.contentSize.height -
        CGRectGetHeight(self.chatScrollView.bounds) * 1.15;
        CGFloat currentHeight = [self contentHeight];
        if (currentHeight < CGRectGetHeight(self.chatScrollView.bounds)) {
            currentHeight = CGRectGetHeight(self.chatScrollView.bounds) + 1.0;
        }
        if (currentHeight != self.chatScrollView.contentSize.height) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.chatScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.chatScrollView.bounds), currentHeight)];
                if (isScrollToBottom && completionBlock == nil) {
                    [self scrollToBottom:YES];
                }
                if (completionBlock) {
                    completionBlock();
                }
            });
        }
    });
}

- (CGFloat)contentHeight {
    __block CGFloat contentHeight = 0.0;
    [[self childViewControllers] enumerateObjectsUsingBlock:^(PCUNodeViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PCUNodeViewController class]]) {
            contentHeight += obj.heightConstraint.constant;
        }
    }];
    return contentHeight;
}

#pragma mark - Layouts

- (void)setBottomLayoutHeight:(CGFloat)layoutHeight {
    self.toolViewBottomSpaceConstraint.constant = layoutHeight;
    CGFloat contentHeight = [self contentHeight];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        if (layoutHeight != 0.0 &&
            contentHeight > CGRectGetHeight(self.chatScrollView.bounds) &&
            contentHeight < CGRectGetHeight(self.chatScrollView.bounds) + layoutHeight) {
            [self.chatScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.chatScrollView.bounds),
                                                           contentHeight)];
        }
        if (contentHeight >= CGRectGetHeight(self.chatScrollView.bounds)) {
            [self scrollToBottom:NO];
        }
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
                                                                                 toItem:self.chatScrollView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0.0];
                nodeViewController.topConstraint = constaints;
                [self.chatScrollView addConstraint:nodeViewController.topConstraint];
            }
        }
        else {
            if (nodeViewController.topConstraint.firstItem != previousViewController.view) {
                [self.chatScrollView removeConstraint:nodeViewController.topConstraint];
                nodeViewController.topConstraint = [NSLayoutConstraint constraintWithItem:previousViewController.view
                                                                                attribute:NSLayoutAttributeBottom
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:nodeViewController.view
                                                                                attribute:NSLayoutAttributeTop
                                                                               multiplier:1.0
                                                                                 constant:0.0];
                [self.chatScrollView addConstraint:nodeViewController.topConstraint];
            }
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
