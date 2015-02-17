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
#import "PCUAttributedStringManager.h"
#import "PCUMessageManager.h"
#import "PCUAvatarManager.h"

@implementation PCUCore

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.attributedStringManagerClass = [PCUAttributedStringManager class];
        self.messageManagerClass = [PCUMessageManager class];
    }
    return self;
}

- (void)configure {
    [self bindClass:[PCUWireframe class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[PCUWireframe class] toProtocol:@protocol(PCUWireframe)];
    [self bindClass:[PCUAttributedStringManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[PCUAvatarManager class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[PCUMessageManager class] inScope:JSObjectionScopeNormal];
    [self bindCustomAttributedStringManager];
    [self bindCustomMessageManager];
}

- (void)bindCustomAttributedStringManager {
    if (self.attributedStringManagerClass != [PCUAttributedStringManager class]) {
        [self bindClass:self.attributedStringManagerClass toClass:[PCUAttributedStringManager class]];
    }
}

- (void)bindCustomMessageManager {
    if (self.messageManagerClass != [PCUMessageManager class]) {
        [self bindClass:self.messageManagerClass toClass:[PCUMessageManager class]];
    }
}

@end
