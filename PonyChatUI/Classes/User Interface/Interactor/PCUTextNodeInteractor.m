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

@end

@implementation PCUTextNodeInteractor

- (instancetype)initWithMessage:(PCUMessage *)message
{
    self = [super initWithMessage:message];
    if (self) {
        self.titleString = message.title;
    }
    return self;
}

@end
