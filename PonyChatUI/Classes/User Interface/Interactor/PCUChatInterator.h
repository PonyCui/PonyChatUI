//
//  PCUChatInterator.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUMessageManager.h"

@class PCUMessageManager;

@interface PCUChatInterator : NSObject<PCUMessageManagerDelegate>

/**
 *  @brief 对话窗口标题
 */
@property (nonatomic, copy) NSString *titleString;

/**
 *  @brief Array -> PCUNodeInterator
 */
@property (nonatomic, copy) NSArray *nodeInteractors;

/**
 *  @brief Message Manager
 */
@property (nonatomic, strong) PCUMessageManager *messageManager;

@end
