//
//  PCUNodeInterator.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeInteractor.h"
#import "PCUApplication.h"
#import "PCUMessage.h"
#import "PCUSender.h"
#import "PCUTextNodeInteractor.h"
#import "PCUSystemNodeInteractor.h"
#import "PCUVoiceNodeInteractor.h"
#import "PCUImageNodeInteractor.h"
#import "PCUMessageManager.h"
#import "PCUAvatarManager.h"

@interface PCUNodeInteractor ()

@property (nonatomic, strong) PCUMessage *message;

@property (nonatomic, copy) NSString *senderThumbURLString;

@end

@implementation PCUNodeInteractor

+ (PCUNodeInteractor *)nodeInteractorWithMessage:(PCUMessage *)message {
    if (message.type == PCUMessageTypeTextMessage) {
        return [[PCUTextNodeInteractor alloc] initWithMessage:message];
    }
    else if (message.type == PCUMessageTypeSystem) {
        return [[PCUSystemNodeInteractor alloc] initWithMessage:message];
    }
    else if (message.type == PCUMessageTypeVoiceMessage) {
        return [[PCUVoiceNodeInteractor alloc] initWithMessage:message];
    }
    else if (message.type == PCUMessageTypeImageMessage) {
        return [[PCUImageNodeInteractor alloc] initWithMessage:message];
    }
    else {
        message.params = @{kPCUMessageParamsErrorDescriptionKey:
                               [NSString stringWithFormat:@"%@发送了一条消息，升级客户端可查看。",
                                message.sender.title]};
        return [[PCUSystemNodeInteractor alloc] initWithMessage:message];//提示用户，收到未知类型信息
    }
    return nil;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithMessage:(PCUMessage *)message
{
    self = [super init];
    if (self) {
        self.message = message;
        [self sendAvatarRequest];
    }
    return self;
}

- (void)sendAvatarRequest {
    if (self.message.sender.thumbURLString != nil) {
        self.senderThumbURLString = self.message.sender.thumbURLString;
        self.senderThumbImage = [PCU[[PCUAvatarManager class]]
                                 sendSyncRequestWithURLString:self.senderThumbURLString];
        if (self.senderThumbImage == nil) {
            [PCU[[PCUAvatarManager class]] sendAsyncRequestWithURLString:self.senderThumbURLString];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(handleAvatarManagerResponseUIImage:)
                                                         name:kPCUAvatarManagerDidResponseUIImageNotification
                                                       object:nil];
        }
    }
}

- (void)handleAvatarManagerResponseUIImage:(NSNotification *)sender {
    if ([[sender userInfo][@"URLString"] isEqualToString:self.senderThumbURLString] &&
        [sender.object isKindOfClass:[UIImage class]]) {
        self.senderThumbImage = sender.object;
    }
}

- (BOOL)isOwner {
    return [self.message.sender.identifier isEqualToString:[[PCUApplication sender] identifier]];
}

- (NSUInteger)orderIndex {
    return self.message.orderIndex;
}

- (BOOL)isRead {
    return self.message.isRead;
}

- (void)setIsRead:(BOOL)isRead {
    self.message.isRead = isRead;
}

- (NSString *)senderName {
    return self.message.sender.title;
}

- (NSUInteger)hash {
    return [self.message.identifier hash];
}

- (BOOL)isEqual:(PCUNodeInteractor *)object {
    if ([object isKindOfClass:[PCUNodeInteractor class]] &&
        [object.message.identifier isEqualToString:self.message.identifier]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isNodeForMessage:(PCUMessage *)message {
    if ([self.message isEqual:message]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)retrySendMessage {
    if ([self isOwner]) {
        [self.messageManager sendMessage:self.message];
    }
}

@end
