//
//  PCUVoiceNodeInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUVoiceNodeInteractor.h"
#import "PCUApplication.h"
#import "PCUAvatarManager.h"
#import "PCUMessage.h"
#import "PCUSender.h"

@interface PCUVoiceNodeInteractor ()

@property (nonatomic, copy) NSString *senderThumbURLString;

@end

@implementation PCUVoiceNodeInteractor

- (instancetype)initWithMessage:(PCUMessage *)message {
    self = [super initWithMessage:message];
    if (self) {
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
    if ([[sender userInfo][@"URLString"] isEqualToString:self.senderThumbURLString] &&
        [sender.object isKindOfClass:[UIImage class]]) {
        self.senderThumbImage = sender.object;
    }
}

- (void)play {
    
}

- (void)pause {
    
}

@end
