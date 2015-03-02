//
//  PCUChatInterator.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageManager.h"

@class PCUMessageManager, PCUMessage;

@interface PCUChatInteractor : NSObject<PCUMessageManagerDelegate>

/**
 *  @brief 对话窗口标题
 */
@property (nonatomic, copy) NSString *titleString;

/**
 *  @brief NSSet -> PCUNodeInterator
 */
@property (nonatomic, copy) NSSet *nodeInteractors;

@property (nonatomic, copy) NSSet *minusInteractors;

@property (nonatomic, copy) NSSet *plusInteractors;

/**
 *  @brief Message Manager
 */
@property (nonatomic, strong) PCUMessageManager *messageManager;

#pragma mark - Send Message

- (void)sendTextMessageWithString:(NSString *)argString;

- (void)sendVoiceMessageWithPath:(NSString *)argPath;

@end
