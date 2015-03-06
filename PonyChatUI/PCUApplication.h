//
//  PCUApplication.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Objection/Objection.h>
#import "PCUProtocols.h"
#import "PCUDefines.h"

@class PCUSender;

@interface PCUApplication : NSObject

+ (JSObjectionInjector *)injector;

+ (PCUSender *)sender;

+ (void)setSender:(PCUSender *)sender;

+ (void)setAttributedStringManagerClass:(Class)managerClass;

+ (void)setMessageManagerClass:(Class)managerClass;

+ (void)endEditing;

+ (void)endPlaying;

+ (BOOL)shouldAutorotate;

+ (BOOL)canUseBuiltInSpeaker;

+ (void)setCanUseBuiltInSpeaker:(BOOL)use;

@end
