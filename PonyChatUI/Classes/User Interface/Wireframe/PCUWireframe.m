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
#import "PCUToolPresenter.h"

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
    toolViewController.eventHandler.chatInteractor = chatViewController.eventHandler.chatInteractor;
    [chatViewController.view addSubview:toolViewController.view];
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
    toolViewController.eventHandler = [[PCUToolPresenter alloc] init];
    toolViewController.eventHandler.userInterface = toolViewController;
    return toolViewController;
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

@end
