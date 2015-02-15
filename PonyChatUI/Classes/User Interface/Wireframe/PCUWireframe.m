//
//  PCUWireframe.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUWireframe.h"
#import "PCUChatViewController.h"
#import "PCUChatPresenter.h"
#import "PCUToolViewController.h"
#import "PCUTextNodeViewController.h"
#import "PCUChatInterator.h"
#import "PCUMessageManager.h"

@implementation PCUWireframe

- (void)presentChatViewToViewController:(UIViewController *)viewController withChatItem:(PCUChat *)chatItem {
    PCUChatViewController *chatViewController = [self chatViewController];
    chatViewController.eventHandler.chatInteractor.messageManager.chatItem = chatItem;
    [viewController addChildViewController:chatViewController];
    [viewController.view addSubview:chatViewController.view];
    [self configureChatViewLayouts:chatViewController.view];
}

- (void)presentToolViewToChatViewController:(PCUChatViewController *)chatViewController {
    PCUToolViewController *toolViewController = [self toolViewController];
    chatViewController.toolViewController = toolViewController;
    [chatViewController.view addSubview:toolViewController.view];
}

- (void)addTextNodeToView:(UIScrollView *)view
     toChatViewController:(PCUChatViewController<PCUNodeViewControllerDelegate> *)chatViewController {
    PCUTextNodeViewController *textNodeViewController = [self textNodeViewController];
    textNodeViewController.delegate = chatViewController;
    [view addSubview:textNodeViewController.view];
    [self configureTextNodeViewLayouts:textNodeViewController.view];
    [chatViewController addNodeViewController:textNodeViewController];
}

- (void)insertTextNodeToView:(UIScrollView *)view
                     atIndex:(NSUInteger)index
        toChatViewController:(PCUChatViewController<PCUNodeViewControllerDelegate> *)chatViewController {
    PCUTextNodeViewController *textNodeViewController = [self textNodeViewController];
    textNodeViewController.delegate = chatViewController;
    [view addSubview:textNodeViewController.view];
    [self configureTextNodeViewLayouts:textNodeViewController.view];
    [chatViewController insertNodeViewController:textNodeViewController atIndex:index];
}

- (void)removeNodeViewController:(PCUTextNodeViewController *)nodeViewController
          fromChatViewController:(PCUChatViewController *)chatViewController {
    [chatViewController removeNodeViewController:nodeViewController];
}

- (void)removeNodeViewControllerAtIndex:(NSUInteger)index
                 fromChatViewController:(PCUChatViewController *)chatViewController {
    [chatViewController removeNodeViewControllerAtIndex:index];
}

#pragma mark - Getter

- (PCUChatViewController *)chatViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUChatViewController *chatViewController = [storyBoard
                                                 instantiateViewControllerWithIdentifier:@"PCUChatViewController"];
    chatViewController.eventHandler = [[PCUChatPresenter alloc] init];
    chatViewController.eventHandler.userInterface = chatViewController;
    chatViewController.eventHandler.chatInteractor = [[PCUChatInterator alloc] init];
    return chatViewController;
}

- (PCUToolViewController *)toolViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUToolViewController *toolViewController = [storyBoard
                                                 instantiateViewControllerWithIdentifier:@"PCUToolViewController"];
    return toolViewController;
}

- (PCUTextNodeViewController *)textNodeViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUTextNodeViewController *textNodeViewController = [storyBoard
                                                         instantiateViewControllerWithIdentifier:
                                                         @"PCUTextNodeViewControllerReceiver"];
    return textNodeViewController;
}

#pragma mark - Configure Wireframe View Autolayout

- (void)configureChatViewLayouts:(UIView *)chatView {
    chatView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"chatView": chatView};
    NSArray *wConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[chatView]-0-|"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:views];
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[chatView]-0-|"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:views];
    [[chatView superview] addConstraints:wConstraints];
    [[chatView superview] addConstraints:hConstraints];
}

- (void)configureTextNodeViewLayouts:(UIView *)textNodeView {
    textNodeView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"textNodeView": textNodeView, @"topView": [textNodeView superview]};
    NSArray *wConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[textNodeView(==topView)]"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:views];
    [[textNodeView superview] addConstraints:wConstraints];
}

@end
