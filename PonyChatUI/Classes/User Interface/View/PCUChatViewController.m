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
#import "PCUChatInterator.h"
#import "PCUNodeInteractor.h"
#import "PCUNodePresenter.h"

@interface PCUChatViewController ()

@property (nonatomic, strong) NSArray *nodeViewControllers;

@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;

@end

@implementation PCUChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureToolView];
    [self configureViewLayouts];
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
    [self calculateContentSize];
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
    [self calculateContentSize];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self calculateContentSize];
    [self scrollToBottom:YES];
}

- (void)calculateContentSize {
    BOOL isScrollToBottom = self.chatScrollView.contentOffset.y >= self.chatScrollView.contentSize.height -
    CGRectGetHeight(self.chatScrollView.bounds) * 1.15;
    CGFloat currentHeight = [self contentHeight];
    if (currentHeight < CGRectGetHeight(self.chatScrollView.bounds)) {
        currentHeight = CGRectGetHeight(self.chatScrollView.bounds) + 1.0;
    }
    if (currentHeight != self.chatScrollView.contentSize.height) {
        [self.chatScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.chatScrollView.bounds), currentHeight)];
        if (isScrollToBottom) {
            [self scrollToBottom:YES];
        }
    }
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
    __block NSLayoutConstraint *constraint;
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.secondItem == self.toolViewController.view &&
            obj.firstItem == self.view &&
            obj.firstAttribute == NSLayoutAttributeBottom &&
            obj.secondAttribute == NSLayoutAttributeBottom) {
            constraint = obj;
        }
    }];
    constraint.constant = layoutHeight;
    CGFloat contentHeight = [self contentHeight];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        [self calculateContentSize];
        if (contentHeight >= CGRectGetHeight(self.chatScrollView.bounds)) {
            [self scrollToBottom:NO];
        }
    }];
}

- (void)configureViewLayouts {
    self.chatScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    self.toolViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"toolView": self.toolViewController.view,
                            @"chatView": self.chatScrollView};
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatView]-0-[toolView(48)]-0-|"
                                                                        options:kNilOptions
                                                                        metrics:nil
                                                                          views:views];
        [self.view addConstraints:constraints];
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
}

#pragma mark - handle events

- (IBAction)handleScrollViewTapped:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
