//
//  PCUNodeInterator.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PCUNodeSendMessageStatus) {
    PCUNodeSendMessageStatusNilOption = 0,
    PCUNodeSendMessageStatusSending,
    PCUNodeSendMessageStatusSent,
    PCUNodeSendMessageStatusTimeout,
    PCUNodeSendMessageStatusError
};

@class PCUMessage, PCUMessageManager;

@interface PCUNodeInteractor : NSObject

/**
 *  如果这条消息是自己发送出去的，返回YES
 */
@property (nonatomic, assign) BOOL isOwner;

/**
 *  @brief 发送状态
 */
@property (nonatomic, assign) PCUNodeSendMessageStatus sendStatus;

/**
 *  @brief 消息顺序
 */
@property (nonatomic, assign) NSUInteger orderIndex;

/**
 *  @brief 消息已读
 */
@property (nonatomic, assign) BOOL isRead;

/**
 *  @brief 发送者昵称
 */
@property (nonatomic, copy) NSString *senderName;

/**
 *  @brief 发送者头像缩略图
 */
@property (nonatomic, copy) UIImage  *senderThumbImage;

/**
 *  @brief 消息管理器
 */
@property (nonatomic, strong) PCUMessageManager *messageManager;

+ (PCUNodeInteractor *)nodeInteractorWithMessage:(PCUMessage *)message;

- (instancetype)initWithMessage:(PCUMessage *)message;

- (BOOL)isNodeForMessage:(PCUMessage *)message;

- (void)retrySendMessage;

@end
