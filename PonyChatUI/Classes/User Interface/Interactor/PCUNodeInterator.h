//
//  PCUNodeInterator.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PCUMessage;

@interface PCUNodeInterator : NSObject

@property (nonatomic, assign) NSUInteger orderIndex;

+ (PCUNodeInterator *)nodeInteractorWithMessage:(PCUMessage *)message;

- (instancetype)initWithMessage:(PCUMessage *)message;

@end
