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
#import "PCUTextNodeViewController.h"

@interface PCUChatViewController ()<PCUTextNodeViewControllerDelegate>

@property (nonatomic, strong) NSArray *nodeViewControllers;

@property (nonatomic, strong) PCUToolViewController *toolViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;

@end

@implementation PCUChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCUWireframe *wireframe = PCU[@protocol(PCUWireframe)];
    self.toolViewController = [wireframe addToolViewToView:self.view];
    [self configureViewLayouts];
    [wireframe addTextNodeToView:self.chatScrollView toChatViewController:self];
    [wireframe addTextNodeToView:self.chatScrollView toChatViewController:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSUInteger i=0;
        do {
            [wireframe addTextNodeToView:self.chatScrollView toChatViewController:self];
            i++;
        } while (i<30);//压测一下，目前效率不是太好
    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NodeViewControllers

- (void)addNodeViewController:(PCUTextNodeViewController *)nodeViewController {
    NSMutableArray *nodeViewControllers = [self.nodeViewControllers mutableCopy];
    [nodeViewControllers addObject:nodeViewController];
    self.nodeViewControllers = [nodeViewControllers copy];
    [self configureNodeLayouts];
    [self calculateContentSize];
}

- (void)insertNodeViewController:(PCUTextNodeViewController *)nodeViewController
                         atIndex:(NSUInteger)index {
    
}

- (void)removeNodeViewController:(PCUTextNodeViewController *)nodeViewController {
    
}

- (void)removeNodeViewControllerAtIndex:(NSUInteger)index {
    
}

#pragma mark - ContentSize & ContentOffset

- (void)textNodeViewHeightDidChange {
    [self calculateContentSize];
}

- (void)calculateContentSize {
    __block CGFloat currentHeight = 0.0;
    [self.nodeViewControllers enumerateObjectsUsingBlock:^(PCUTextNodeViewController *obj, NSUInteger idx, BOOL *stop) {
        currentHeight += obj.heightConstraint.constant;
    }];
    if (currentHeight < CGRectGetHeight(self.chatScrollView.bounds)) {
        currentHeight = CGRectGetHeight(self.chatScrollView.bounds) + 1.0;
    }
    [self.chatScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.chatScrollView.bounds), currentHeight)];
}

- (void)scrollToBottom {
    [self.chatScrollView setContentOffset:CGPointMake(0, self.chatScrollView.contentSize.height) animated:YES];
}

#pragma mark - Layouts

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self calculateContentSize];
}

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
    [self.view layoutIfNeeded];
    constraint.constant = layoutHeight;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)configureViewLayouts {
    self.chatScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"toolView": self.toolViewController.view,
                            @"chatScrollView": self.chatScrollView};
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatScrollView]-0-[toolView]-0-|"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:views];
    [self.view addConstraints:hConstraints];
}

- (void)configureNodeLayouts {
    __block PCUTextNodeViewController *previousViewController;
    [self.nodeViewControllers enumerateObjectsUsingBlock:^(PCUTextNodeViewController *obj, NSUInteger idx, BOOL *stop) {
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
            [self.chatScrollView layoutIfNeeded];
        }
        if (obj.heightConstraint == nil) {
            NSLayoutConstraint *constaints = [NSLayoutConstraint constraintWithItem:obj.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0.0];
            obj.heightConstraint = constaints;
            [self.chatScrollView addConstraint:obj.heightConstraint];
        }
        previousViewController = obj;
    }];
}

- (NSArray *)nodeViewControllers {
    if (_nodeViewControllers == nil) {
        _nodeViewControllers = @[];
    }
    return _nodeViewControllers;
}

@end
