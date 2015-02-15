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
#import "PCUNodeViewController.h"

@interface PCUChatViewController ()<PCUNodeViewControllerDelegate>

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

#pragma mark - ToolViewController

- (void)configureToolView {
    PCUWireframe *wireFrame = PCU[[PCUWireframe class]];
    [wireFrame presentToolViewToChatViewController:self];
}

#pragma mark - NodeViewControllers

- (void)addNodeViewController:(PCUNodeViewController *)nodeViewController {
    NSMutableArray *nodeViewControllers = [self.nodeViewControllers mutableCopy];
    if (nodeViewControllers == nil) {
        nodeViewControllers = [NSMutableArray array];
    }
    [nodeViewControllers addObject:nodeViewController];
    self.nodeViewControllers = [nodeViewControllers copy];
    [self configureNodeLayouts];
    [self calculateContentSize];
}

- (void)insertNodeViewController:(PCUNodeViewController *)nodeViewController
                         atIndex:(NSUInteger)index {
    if (index <= [self.nodeViewControllers count]) {
        NSMutableArray *nodeViewControllers = [self.nodeViewControllers mutableCopy];
        if (nodeViewControllers == nil) {
            nodeViewControllers = [NSMutableArray array];
        }
        if (index < [nodeViewControllers count]) {
            //Should Remove Next NodeViewController TopConstraint
            PCUNodeViewController *nextNodeViewController = [nodeViewControllers objectAtIndex:index];
            [self.chatScrollView removeConstraint:nextNodeViewController.topConstraint];
            nextNodeViewController.topConstraint = nil;
        }
        [nodeViewControllers insertObject:nodeViewController atIndex:index];
        self.nodeViewControllers = [nodeViewControllers copy];
        [self configureNodeLayouts];
        [self calculateContentSize];
    }
}

- (void)removeNodeViewController:(PCUNodeViewController *)nodeViewController {
    NSUInteger nodeIndex = [self.nodeViewControllers indexOfObject:nodeViewController];
    if (nodeIndex != NSNotFound) {
        [self removeNodeViewControllerAtIndex:nodeIndex];
    }
}

- (void)removeNodeViewControllerAtIndex:(NSUInteger)index {
    if (index < [self.nodeViewControllers count]) {
        NSMutableArray *nodeViewControllers = [self.nodeViewControllers mutableCopy];
        if (index+1 < [nodeViewControllers count]) {
            //Should Remove Next NodeViewController TopConstraint
            PCUNodeViewController *nextNodeViewController = [nodeViewControllers objectAtIndex:index+1];
            [self.chatScrollView removeConstraint:nextNodeViewController.topConstraint];
            nextNodeViewController.topConstraint = nil;
        }
        PCUNodeViewController *thisNodeViewController = [nodeViewControllers objectAtIndex:index];
        [self.chatScrollView removeConstraint:thisNodeViewController.topConstraint];
        [thisNodeViewController.view removeFromSuperview];
        [nodeViewControllers removeObjectAtIndex:index];
        self.nodeViewControllers = nodeViewControllers;
        [self configureNodeLayouts];
        [self calculateContentSize];
    }
}

#pragma mark - ContentOffset

- (void)scrollToLastNodeViewController {
    PCUNodeViewController *nodeViewController = [self.nodeViewControllers lastObject];
    [self scrollToSpecificNodeViewController:nodeViewController];
}

- (void)scrollToSpecificNodeViewController:(PCUNodeViewController *)nodeViewController {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.010 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //always delay
        if ([self.nodeViewControllers containsObject:nodeViewController]) {
            CGFloat yOffset = CGRectGetMinY(nodeViewController.view.frame);
            if (yOffset + CGRectGetHeight(self.chatScrollView.bounds) > self.chatScrollView.contentSize.height) {
                yOffset = self.chatScrollView.contentSize.height - CGRectGetHeight(self.chatScrollView.bounds);
            }
            [self.chatScrollView setContentOffset:CGPointMake(0, yOffset) animated:YES];
        }
    });
}

- (CGPoint)offsetForSpecificNodeViewController:(PCUNodeViewController *)nodeViewController {
    if ([self.nodeViewControllers containsObject:nodeViewController]) {
        CGFloat yOffset = CGRectGetMinY(nodeViewController.view.frame);
        if (yOffset + CGRectGetHeight(self.chatScrollView.bounds) > self.chatScrollView.contentSize.height) {
            yOffset = self.chatScrollView.contentSize.height - CGRectGetHeight(self.chatScrollView.bounds);
        }
        return CGPointMake(0, yOffset);
    }
    else {
        return CGPointZero;
    }
}

#pragma mark - ContentSize

- (void)nodeViewHeightDidChange {
    [self calculateContentSize];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self calculateContentSize];
}

- (void)calculateContentSize {
    __block CGFloat currentHeight = 0.0;
    [self.nodeViewControllers enumerateObjectsUsingBlock:^(PCUNodeViewController *obj, NSUInteger idx, BOOL *stop) {
        currentHeight += obj.heightConstraint.constant;
    }];
    if (currentHeight < CGRectGetHeight(self.chatScrollView.bounds)) {
        currentHeight = CGRectGetHeight(self.chatScrollView.bounds) + 1.0;
    }
    if (currentHeight != self.chatScrollView.contentSize.height) {
        [self.chatScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.chatScrollView.bounds), currentHeight)];
    }
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
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
        [self.chatScrollView
         setContentOffset:[self offsetForSpecificNodeViewController:[self.nodeViewControllers lastObject]]
         animated:NO];
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
    __block PCUNodeViewController *previousViewController;
    [self.nodeViewControllers enumerateObjectsUsingBlock:^(PCUNodeViewController *obj, NSUInteger idx, BOOL *stop) {
        if (obj.topConstraint == nil) {
            if (previousViewController == nil) {
                NSLayoutConstraint *constaints = [NSLayoutConstraint constraintWithItem:obj.view
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:self.chatScrollView
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0.0];
                obj.topConstraint = constaints;
            }
            else {
                NSLayoutConstraint *constaints = [NSLayoutConstraint constraintWithItem:previousViewController.view
                                                                              attribute:NSLayoutAttributeBottom
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:obj.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1.0
                                                                               constant:0.0];
                obj.topConstraint = constaints;
            }
            [self.chatScrollView addConstraint:obj.topConstraint];
        }
        if (obj.heightConstraint == nil) {
            NSLayoutConstraint *constaints = [NSLayoutConstraint constraintWithItem:obj.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
            obj.heightConstraint = constaints;
            [self.chatScrollView addConstraint:obj.heightConstraint];
        }
        previousViewController = obj;
    }];
}

#pragma mark - handle events

- (IBAction)handleScrollViewTapped:(UITapGestureRecognizer *)sender {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
