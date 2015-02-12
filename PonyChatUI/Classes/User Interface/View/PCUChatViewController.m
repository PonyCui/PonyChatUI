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

@interface PCUChatViewController ()

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
}

- (void)insertNodeViewController:(PCUTextNodeViewController *)nodeViewController
                         atIndex:(NSUInteger)index {
    
}

- (void)removeNodeViewController:(PCUTextNodeViewController *)nodeViewController {
    
}

- (void)removeNodeViewControllerAtIndex:(NSUInteger)index {
    
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
            NSLayoutConstraint *constaints = [NSLayoutConstraint constraintWithItem:obj.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70];
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
