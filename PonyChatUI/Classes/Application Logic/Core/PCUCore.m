//
//  PCUCore.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUCore.h"
#import "PCUProtocols.h"
#import "PCUWireframe.h"

@implementation PCUCore

- (void)configure {
    [self bindClass:[PCUWireframe class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[PCUWireframe class] toProtocol:@protocol(PCUWireframe)];
}

@end
