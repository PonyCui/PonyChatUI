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
#import "PCUChatInteractor.h"
#import "PCUMessageManager.h"
#import "PCUToolViewController.h"
#import "PCUToolPresenter.h"
#import "PCUPanelViewController.h"
#import "PCUPanelPresenter.h"
#import "PCUTalkingViewController.h"
#import "PCUTalkingHUDViewController.h"
#import "PCUTalkingCancelHUDViewController.h"
#import "PCUGalleryPageViewController.h"

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

- (void)presentTalkingHUDToViewController:(PCUTalkingViewController *)viewController {
    if (viewController.talkingHUDViewController == nil) {
        viewController.talkingHUDViewController = [self talkingHUDViewController];
    }
    [viewController.cancelHUDViewController.view removeFromSuperview];
    id trunkViewController = viewController;
    do {
        if ([[trunkViewController parentViewController] isKindOfClass:[UINavigationController class]] ||
            [trunkViewController parentViewController] == nil) {
            break;
        }
        trunkViewController = [trunkViewController parentViewController];
    } while (true);
    [[trunkViewController view] addSubview:viewController.talkingHUDViewController.view];
    [viewController.talkingHUDViewController configureViewLayouts];
}

- (void)presentCancelHUDToViewController:(PCUTalkingViewController *)viewController {
    if (viewController.cancelHUDViewController == nil) {
        viewController.cancelHUDViewController = [self talkingCancelHUDViewController];
    }
    [viewController.talkingHUDViewController.view removeFromSuperview];
    id trunkViewController = viewController;
    do {
        if ([[trunkViewController parentViewController] isKindOfClass:[UINavigationController class]] ||
            [trunkViewController parentViewController] == nil) {
            break;
        }
        trunkViewController = [trunkViewController parentViewController];
    } while (true);
    [[trunkViewController view] addSubview:viewController.cancelHUDViewController.view];
    [viewController.cancelHUDViewController configureViewLayouts];
}

- (void)presentGalleryViewControllerWithDataSource:(id)dataSource
                              parentViewController:(UIViewController *)parentViewController
                                              view:(UIView *)view {
    PCUGalleryPageViewController *pageViewController = [self galleryPageViewController];
    pageViewController.galleryDataSource = dataSource;
    pageViewController.enterView = view;
    [parentViewController presentViewController:pageViewController animated:YES completion:nil];
}

#pragma mark - Getter

- (PCUChatViewController *)chatViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUChatViewController *chatViewController = [storyBoard
                                                 instantiateViewControllerWithIdentifier:@"PCUChatViewController"];
    chatViewController.eventHandler = [[PCUChatPresenter alloc] init];
    chatViewController.eventHandler.userInterface = chatViewController;
    chatViewController.eventHandler.chatInteractor = [[PCUChatInteractor alloc] init];
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
    panelViewController.eventHandler = [[PCUPanelPresenter alloc] init];
    panelViewController.eventHandler.userInterface = panelViewController;
    return panelViewController;
}

- (PCUTalkingHUDViewController *)talkingHUDViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUTalkingHUDViewController *talkingHUDViewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"PCUTalkingHUDViewController"];
    return talkingHUDViewController;
}

- (PCUTalkingCancelHUDViewController *)talkingCancelHUDViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUTalkingCancelHUDViewController *talkingCancelHUDViewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"PCUTalkingCancelHUDViewController"];
    return talkingCancelHUDViewController;
}

- (PCUGalleryPageViewController *)galleryPageViewController {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUGalleryPageViewController *pageViewController =
    [storyBoard instantiateViewControllerWithIdentifier:@"PCUGalleryPageViewController"];
    return pageViewController;
}

@end
