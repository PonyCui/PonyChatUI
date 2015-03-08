//
//  PCUWireframe.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUApplication.h"

@class PCUChatViewController, PCUChat, PCUPanelViewController, PCUTalkingViewController;

@interface PCUWireframe : NSObject

- (void)presentChatViewToViewController:(UIViewController *)viewController
                           withChatItem:(PCUChat *)chatItem;

- (void)presentToolViewToChatViewController:(PCUChatViewController *)chatViewController;

- (PCUPanelViewController *)presentPanelViewToChatViewController:(PCUChatViewController *)chatViewController;

- (void)presentTalkingHUDToViewController:(PCUTalkingViewController *)viewController;

- (void)presentCancelHUDToViewController:(PCUTalkingViewController *)viewController;

- (void)presentGalleryViewControllerWithDataSource:(id)dataSource
                              parentViewController:(UIViewController *)parentViewController
                                              view:(UIView *)view;

@end
