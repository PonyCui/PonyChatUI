//
//  PCUMessageManager.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUMessageManager.h"
#import "PCUMessage.h"
#import "PCUChat.h"
#import "PCUSender.h"

@interface PCUMessageManager ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PCUMessageManager

- (void)dealloc
{
    [self closeConnection];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self openConnection];
    }
    return self;
}

/**
 *  Open a socket connection here, or query CoreData with GCD, or anything else.
 */
- (void)openConnection {
    //If you use NSTimer or GCD, Be careful, should call closeConnection by yourself,
    //dealloc will do nothing.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                  target:self
                                                selector:@selector(didReceivedData)
                                                userInfo:nil
                                                 repeats:YES];
}

/**
 *  Received Data, Here is Demo Data.
 */
- (void)didReceivedData {
    //System Demo
    {
        if (arc4random() % 3 < 1) {
            PCUMessage *message = [[PCUMessage alloc] init];
            message.identifier = [NSString stringWithFormat:@"%u", arc4random()];
            message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000 + 2;
            message.type = PCUMessageTypeSystem;
            message.title = @"[多玩游戏](http://www.duowan.com/) 多交朋友";
            [self.delegate messageManagerDidReceivedMessage:message];
        }
    }
    //Text Demo
    {
        PCUMessage *message = [[PCUMessage alloc] init];
        message.identifier = [NSString stringWithFormat:@"%u", arc4random()];
        message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000 + 1;//必须保证orderIndex是唯一的
        message.type = PCUMessageTypeTextMessage;
        message.sender = [[PCUSender alloc] init];
        message.sender.identifier = [NSString stringWithFormat:@"%d", arc4random()%2+1];
        message.sender.title = @"Pony";
        message.sender.thumbURLString = @"http://tp3.sinaimg.cn/1642351362/180/5708018784/0";
        message.title = @"测试一下啦";
        message.params = @{};
        [self.delegate messageManagerDidReceivedMessage:message];
    }
}

- (void)closeConnection {
    [self.timer invalidate];
    self.timer = nil;
}

@end
