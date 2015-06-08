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

@implementation PCUWireframe

- (UIView *)addChatViewToView:(UIView *)view {
    PCUChatViewController *chatViewController = [self chatViewController];
    id parentViewController;
    do {
        parentViewController = [view nextResponder];
    } while (![parentViewController isKindOfClass:[UIViewController class]] && parentViewController != nil);
    [parentViewController addChildViewController:chatViewController];
    [view addSubview:chatViewController.view];
    [self configureChatViewLayouts:chatViewController.view];
    return chatViewController.view;
}

- (PCUToolViewController *)addToolViewToView:(UIView *)view {
    PCUToolViewController *toolViewController = [self toolViewController];
    [view addSubview:toolViewController.view];
    [self configureToolViewLayouts:toolViewController.view];
    return toolViewController;
}

- (void)addTextNodeToView:(UIScrollView *)view
     toChatViewController:(PCUChatViewController<PCUTextNodeViewControllerDelegate> *)chatViewController {
    PCUTextNodeViewController *textNodeViewController = [self textNodeViewController];
    textNodeViewController.delegate = chatViewController;
    [view addSubview:textNodeViewController.view];
    [self configureTextNodeViewLayouts:textNodeViewController.view];
    [chatViewController addNodeViewController:textNodeViewController];
}

#pragma mark - Getter

- (PCUChatViewController *)chatViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUChatViewController *chatViewController = [storyBoard
                                                 instantiateViewControllerWithIdentifier:@"PCUChatViewController"];
    chatViewController.chatPresenter = [[PCUChatPresenter alloc] init];
    chatViewController.chatPresenter.userInterface = chatViewController;
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

- (void)configureToolViewLayouts:(UIView *)toolView {
    toolView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"toolView": toolView};
    NSArray *wConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[toolView]-0-|"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:views];
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[toolView(48)]"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:views];
    [[toolView superview] addConstraints:wConstraints];
    [[toolView superview] addConstraints:hConstraints];
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
