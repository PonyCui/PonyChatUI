//
//  PCUWireframe.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUApplication.h"

@class PCUToolViewController, PCUTextNodeViewController, PCUChatViewController, PCUChat;

@interface PCUWireframe : NSObject

- (void)presentChatViewToViewController:(UIViewController *)viewController
                           withChatItem:(PCUChat *)chatItem;

- (void)presentToolViewToChatViewController:(PCUChatViewController *)chatViewController;

@end
