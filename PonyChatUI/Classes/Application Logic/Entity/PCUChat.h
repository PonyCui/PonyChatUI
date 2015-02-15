//
//  PCUChat.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCUChat : NSObject

/**
 *  对话组的标识符
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  对话组的标题
 */
@property (nonatomic, copy) NSString *title;

@end
