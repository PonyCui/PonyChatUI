//
//  PCUSender.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUSender.h"

@implementation PCUSender

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[PCUSender class]] &&
        [[(PCUSender *)object identifier] isEqualToString:self.identifier]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
