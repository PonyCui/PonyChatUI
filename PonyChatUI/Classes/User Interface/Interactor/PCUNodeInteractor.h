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

@class PCUMessage;

@interface PCUNodeInteractor : NSObject

/**
 *  如果这条消息是自己发送出去的，返回YES
 */
@property (nonatomic, assign) BOOL isOwner;

/**
 *  发送状态
 */
@property (nonatomic, assign) PCUNodeSendMessageStatus sendStatus;

@property (nonatomic, copy) NSString *messageIdentifier;

@property (nonatomic, assign) NSUInteger orderIndex;

+ (PCUNodeInteractor *)nodeInteractorWithMessage:(PCUMessage *)message;

- (instancetype)initWithMessage:(PCUMessage *)message;

@end
