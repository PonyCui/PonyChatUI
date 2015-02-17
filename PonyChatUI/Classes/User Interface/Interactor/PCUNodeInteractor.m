//
//  PCUNodeInterator.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeInteractor.h"
#import "PCUMessage.h"
#import "PCUTextNodeInteractor.h"
#import "PCUSystemNodeInteractor.h"
#import "PCUSender.h"
#import "PCUApplication.h"
#import "PCUMessageManager.h"

@interface PCUNodeInteractor ()

@property (nonatomic, strong) PCUMessage *message;

@end

@implementation PCUNodeInteractor

+ (PCUNodeInteractor *)nodeInteractorWithMessage:(PCUMessage *)message {
    if (message.type == PCUMessageTypeTextMessage) {
        return [[PCUTextNodeInteractor alloc] initWithMessage:message];
    }
    else if (message.type == PCUMessageTypeSystem) {
        return [[PCUSystemNodeInteractor alloc] initWithMessage:message];
    }
    return nil;
}

- (instancetype)initWithMessage:(PCUMessage *)message
{
    self = [super init];
    if (self) {
        self.message = message;
    }
    return self;
}

- (BOOL)isOwner {
    return [self.message.sender.identifier isEqualToString:[[PCUApplication sender] identifier]];
}

- (NSUInteger)orderIndex {
    return self.message.orderIndex;
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
