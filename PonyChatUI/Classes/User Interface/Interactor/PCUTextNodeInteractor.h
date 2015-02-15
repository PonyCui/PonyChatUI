//
//  PCUTextNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUNodeInterator.h"

@class PCUMessage;
@interface PCUTextNodeInteractor : PCUNodeInterator

/**
 *  @brief 消息正文
 */
@property (nonatomic, copy) NSString *titleString;

/**
 *  @brief 发送者昵称
 */
@property (nonatomic, copy) NSString *senderName;

/**
 *  @brief 发送者头像缩略图
 */
@property (nonatomic, copy) UIImage  *senderThumbImage;

- (instancetype)initWithMessage:(PCUMessage *)message;

@end
