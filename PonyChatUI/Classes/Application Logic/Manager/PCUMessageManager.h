//
//  PCUMessageManager.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUChat, PCUMessage;

@protocol PCUMessageManagerDelegate <NSObject>

@required
- (void)messageManagerDidReceivedMessage:(PCUMessage *)message;
- (void)messageManagerDidReceivedMessages:(NSArray *)messages;
- (void)messageManagerSendMessageStarted:(PCUMessage *)message;
- (void)messageManagerDidSentMessage:(PCUMessage *)message;
- (void)messageManagerSendMessageFailed:(PCUMessage *)message error:(NSError *)error;

@end

@interface PCUMessageManager : NSObject

@property (nonatomic, weak) id<PCUMessageManagerDelegate> delegate;

@property (nonatomic, strong) PCUChat *chatItem;

- (void)connect;

- (void)disconnect;

- (void)sendMessage:(PCUMessage *)message;

@end
