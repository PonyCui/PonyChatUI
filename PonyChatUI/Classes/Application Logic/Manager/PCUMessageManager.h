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

@end

@interface PCUMessageManager : NSObject

@property (nonatomic, weak) id<PCUMessageManagerDelegate> delegate;

@property (nonatomic, strong) PCUChat *chatItem;

- (void)connect;

- (void)disconnect;

@end
