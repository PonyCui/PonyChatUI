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
            message.title = @"[多玩](http://www.duowan.com/)游戏 多交朋友";
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
        message.title = @"国际惯例，每年的农历春节，多玩网站的小编们都会自编自导自演自拍，丢掉节操，自毁形象，为各位玩家老爷们诚意奉上年度贺岁“大电影”。2015年当然也不例外！不过今年跟往年不同的是，为了能够强调“斥巨资”这个概念，多玩小编们不再沿用往年分小组拍摄的分散剧组经费的陋习，今年，我们将所有拍摄资金——共计258块3毛6元，全部投资于一部片子，所有道具都从原来的5毛钱上升到6毛！为的就是让大片能够更华丽更有内涵更高大上。[查看文章](http://newgame.duowan.com/1502/288005588481.html)";
        message.params = @{};
        [self.delegate messageManagerDidReceivedMessage:message];
    }
}

- (void)closeConnection {
    [self.timer invalidate];
    self.timer = nil;
}

@end
