//
//  PCUApplication.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUApplication.h"
#import "PCUCore.h"
#import "PCUSender.h"

static PCUCore *coreModule;
static PCUSender *ownerSender;

@implementation PCUApplication

+ (JSObjectionInjector *)injector {
    static JSObjectionInjector *injector;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreModule = [[PCUCore alloc] init];
        injector = [JSObjection createInjectorWithModules:
                    coreModule,
                    nil];
    });
    return injector;
}

+ (PCUSender *)sender {
    return ownerSender;
}

+ (void)setSender:(PCUSender *)sender {
    ownerSender = sender;
}

+ (void)setAttributedStringManagerClass:(Class)managerClass {
    [coreModule bindCustomAttributedStringManager:managerClass];
}

@end
