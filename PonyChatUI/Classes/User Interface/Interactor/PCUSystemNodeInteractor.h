//
//  PCUSystemNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/16.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUNodeInteractor.h"

@class PCUMessage;

@interface PCUSystemNodeInteractor : PCUNodeInteractor

/**
 *  正文内容
 */
@property (nonatomic, copy) NSString *titleString;

- (instancetype)initWithMessage:(PCUMessage *)message;

@end
