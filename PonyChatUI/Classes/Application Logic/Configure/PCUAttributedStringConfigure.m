//
//  PCUAttributedStringConfigure.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/12.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUAttributedStringConfigure.h"

@implementation PCUAttributedStringConfigure

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fontSize = PCUAttributedStringFontSizeNormal;
        self.fontWeight = PCUAttributedStringFontWeightNormal;
    }
    return self;
}

@end
