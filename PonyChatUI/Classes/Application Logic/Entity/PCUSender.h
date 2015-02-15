//
//  PCUSender.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCUSender : NSObject

/**
 *  发送者唯一标识
 */
@property (nonatomic, copy) NSString *identifier;

/**
 *  发送者昵称
 */
@property (nonatomic, copy) NSString *title;

/**
 *  发送者头像缩略图地址
 */
@property (nonatomic, copy) NSString *thumbURLString;

@end
