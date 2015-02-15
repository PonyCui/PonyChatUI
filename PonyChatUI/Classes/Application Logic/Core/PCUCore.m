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
#import "PCUAttributedStringConfigure.h"
#import "PCUNodeViewController.h"
#import "PCUNodePresenter.h"
#import "PCUNodeInterator.h"
#import "PCUMessageManager.h"

@implementation PCUCore

- (void)configure {
    [self bindClass:[PCUWireframe class] inScope:JSObjectionScopeSingleton];
    [self bindClass:[PCUWireframe class] toProtocol:@protocol(PCUWireframe)];
    [self bindClass:[PCUAttributedStringManager class] inScope:JSObjectionScopeSingleton];
    [self bindBlock:^id(JSObjectionInjector *context) {
        PCUAttributedStringConfigure *configure = [[PCUAttributedStringConfigure alloc] init];
        return [[PCUAttributedStringManager alloc] initWithConfigure:configure];
    } toClass:[PCUAttributedStringManager class]];
    [self bindBlock:^id(JSObjectionInjector *context) {
        return nil;
    } toClass:[PCUNodeViewController class]];
    [self bindBlock:^id(JSObjectionInjector *context) {
        return nil;
    } toClass:[PCUNodePresenter class]];
    [self bindBlock:^id(JSObjectionInjector *context) {
        return nil;
    } toClass:[PCUNodeInterator class]];
    [self bindBlock:^id(JSObjectionInjector *context) {
        return [[PCUMessageManager alloc] init];
    } toClass:[PCUMessageManager class]];
}

- (void)bindCustomAttributedStringManager:(Class)managerClass {
    [self bindClass:[PCUAttributedStringManager class] toClass:managerClass];
}

@end
