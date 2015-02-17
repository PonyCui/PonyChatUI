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

@interface PCUNodeInteractor ()

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
        self.messageIdentifier = message.identifier;
        self.isOwner = [message.sender.identifier isEqualToString:[[PCUApplication sender] identifier]];
        self.orderIndex = message.orderIndex;
    }
    return self;
}

- (NSUInteger)hash {
    return [self.messageIdentifier hash];
}

- (BOOL)isEqual:(PCUNodeInteractor *)object {
    if ([object isKindOfClass:[PCUNodeInteractor class]] &&
        [object.messageIdentifier isEqualToString:self.messageIdentifier]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
