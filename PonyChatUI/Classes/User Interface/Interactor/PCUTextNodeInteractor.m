//
//  PCUTextNodeInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUTextNodeInteractor.h"
#import "PCUMessage.h"
#import "PCUSender.h"
#import "PCUAvatarManager.h"
#import "PCUApplication.h"

@interface PCUTextNodeInteractor ()

@property (nonatomic, copy) NSString *senderThumbURLString;

@end

@implementation PCUTextNodeInteractor

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithMessage:(PCUMessage *)message
{
    self = [super initWithMessage:message];
    if (self) {
        self.titleString = message.title;
        self.senderName = message.sender.title;
        self.senderThumbURLString = message.sender.thumbURLString;
        self.senderThumbImage = [PCU[[PCUAvatarManager class]]
                                 sendSyncRequestWithURLString:self.senderThumbURLString];
        if (self.senderThumbImage == nil) {
            [PCU[[PCUAvatarManager class]] sendAsyncRequestWithURLString:self.senderThumbURLString];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAvatarManagerResponseUIImage:)
                                                     name:kPCUAvatarManagerDidResponseUIImageNotification
                                                   object:nil];
    }
    return self;
}

- (void)handleAvatarManagerResponseUIImage:(NSNotification *)sender {
    if ([sender.object isKindOfClass:[UIImage class]]) {
        self.senderThumbImage = sender.object;
    }
}

@end
