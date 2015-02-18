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
#import "PCUPanelViewController.h"

@implementation PCUWireframe

- (void)presentChatViewToViewController:(UIViewController *)viewController withChatItem:(PCUChat *)chatItem {
    PCUChatViewController *chatViewController = [self chatViewController];
    chatViewController.eventHandler.chatInteractor.messageManager.chatItem = chatItem;
    [viewController addChildViewController:chatViewController];
    [viewController.view addSubview:chatViewController.view];
    [chatViewController configureViewLayouts];
}

- (void)presentToolViewToChatViewController:(PCUChatViewController *)chatViewController {
    PCUToolViewController *toolViewController = [self toolViewController];
    [chatViewController addChildViewController:toolViewController];
    chatViewController.toolViewController = toolViewController;
    toolViewController.eventHandler.chatInteractor = chatViewController.eventHandler.chatInteractor;
    [chatViewController.view addSubview:toolViewController.view];
}

- (PCUPanelViewController *)presentPanelViewToChatViewController:(PCUChatViewController *)chatViewController {
    PCUPanelViewController *panelViewController = [self panelViewController];
    [chatViewController addChildViewController:panelViewController];
    [chatViewController.view addSubview:panelViewController.view];
    [panelViewController configureViewLayouts];
    return panelViewController;
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

- (PCUPanelViewController *)panelViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUPanelViewController *panelViewController = [storyBoard
                                                   instantiateViewControllerWithIdentifier:@"PCUPanelViewController"];
    return panelViewController;
}

@end
