//
//  PCUAvatarManager.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kPCUAvatarManagerDidResponseUIImageNotification @"kPCUAvatarManagerDidResponseUIImageNotification"

@interface PCUAvatarManager : NSObject

/**
 *  异步加载头像
 *  会通过NSNotificationCenter返回结果
 *
 *  @param URLString
 */
- (void)sendAsyncRequestWithURLString:(NSString *)URLString;

/**
 *  同步加载头像
 *
 *  @param URLString
 *
 *  @return 本地不存在高速缓存，则返回nil
 */
- (UIImage *)sendSyncRequestWithURLString:(NSString *)URLString;

@end
