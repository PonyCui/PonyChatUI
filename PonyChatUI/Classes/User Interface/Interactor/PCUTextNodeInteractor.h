//
//  PCUTextNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PCUNodeInteractor.h"

@class PCUMessage;
@interface PCUTextNodeInteractor : PCUNodeInteractor

/**
 *  @brief 消息正文
 */
@property (nonatomic, copy) NSString *titleString;

@end
