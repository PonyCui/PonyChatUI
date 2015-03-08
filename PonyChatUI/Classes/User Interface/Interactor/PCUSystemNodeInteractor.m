//
//  PCUSystemNodeInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/16.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUSystemNodeInteractor.h"
#import "PCUMessage.h"

@implementation PCUSystemNodeInteractor

- (instancetype)initWithMessage:(PCUMessage *)message {
    self = [super initWithMessage:message];
    if (self) {
        if (message.type != PCUMessageTypeSystem &&
            message.params[kPCUMessageParamsErrorDescriptionKey] != nil) {
            //It's Error Message
            self.titleString = message.params[kPCUMessageParamsErrorDescriptionKey];
        }
        else {
            self.titleString = message.title;
        }
    }
    return self;
}

@end
