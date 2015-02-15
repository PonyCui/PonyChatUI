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

@interface PCUNodeInteractor ()

@end

@implementation PCUNodeInteractor

+ (PCUNodeInteractor *)nodeInteractorWithMessage:(PCUMessage *)message {
    if (message.type == PCUMessageTypeTextMessage) {
        return [[PCUTextNodeInteractor alloc] initWithMessage:message];
    }
    return nil;
}

- (instancetype)initWithMessage:(PCUMessage *)message
{
    self = [super init];
    if (self) {
        self.orderIndex = message.orderIndex;
    }
    return self;
}

- (NSUInteger)hash {
    return self.orderIndex;
}

- (BOOL)isEqual:(PCUNodeInteractor *)object {
    if ([object isKindOfClass:[PCUNodeInteractor class]] && object.orderIndex == self.orderIndex) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
