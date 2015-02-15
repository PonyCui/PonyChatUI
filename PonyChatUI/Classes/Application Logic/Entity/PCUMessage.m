//
//  PCUMessage.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUMessage.h"

@implementation PCUMessage

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[PCUMessage class]] &&
        [[(PCUMessage *)object identifier] isEqualToString:self.identifier]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSUInteger)hash {
    return [self.identifier hash];
}

@end
