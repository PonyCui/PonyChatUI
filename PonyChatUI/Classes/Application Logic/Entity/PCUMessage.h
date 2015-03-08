//
//  PCUMessage.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUDefines.h"

typedef NS_ENUM(NSUInteger, PCUMessageType) {
    /**
     *  系统消息
     */
    PCUMessageTypeSystem = 0,
    /**
     *  文本消息
     */
    PCUMessageTypeTextMessage = 1,
    /**
     *  语音消息
     */
    PCUMessageTypeVoiceMessage = 2,
    /**
     *  图片消息
     */
    PCUMessageTypeImageMessage = 3,
    /**
     *  链接
     */
    PCUMessageTypeLinkMessage = 4,
    /**
     *  公众号文章推送
     */
    PCUMessageTypeArticleMessage = 5
};

@class PCUSender;

@interface PCUMessage : NSObject

/**
 *  消息的唯一标识
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  消息的序列号
 *  @brief 此值与接收到该条消息的时间相关
 */
@property (nonatomic, assign) NSUInteger orderIndex;

/**
 *  消息已读
 *  @brief @YES 已读
 */
@property (nonatomic, assign) BOOL isRead;

/**
 *  消息类型
 */
@property (nonatomic, assign) PCUMessageType type;

/**
 *  消息的发送者
 */
@property (nonatomic, strong) PCUSender *sender;

/**
 *  消息标题
 *  可能是长文本
 */
@property (nonatomic, copy) NSString *title;

/**
 *  消息的其它参数
 *  写成Dictionary是为了扩展方便
 */
@property (nonatomic, copy) NSDictionary *params;

@end
