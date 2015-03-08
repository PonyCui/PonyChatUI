//
//  PCUDefines.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PCU [PCUApplication injector]

/**
 *  Notification All TextField / TextView / PanelView / EmotionView, 
 *  Should Hide Keyboard And ResignFirstResponder.
 */
#define kPCUEndEditingNotification @"kPCUEndEditingNotification"

/**
 *  Notification All Audio Player, Player Should Stop Playing Audio and Video
 */
#define kPCUEndPlayingNotification @"kPCUEndPlayingNotification"

/**
 *  Notification ViewController, ViewController Should Prevent Screen Ratate
 */
#define kPCUPreventScreenRotationNotification @"kPCUPreventScreenRotationNotification"

/**
 *  Notification ViewController, ViewController Should Allow Screen Ratate
 */
#define kPCUAllowScreenRotationNotification @"kPCUAllowScreenRotationNotification"

/**
 *  PCUMessageParamsDefines
 */
#define kPCUMessageParamsVoicePathKey @"voicePath"

/**
 *  PCUMessageParamsDefines
 */
#define kPCUMessageParamsThumbImagePathKey @"thumbPath"

/**
 *  PCUMessageParamsDefines
 */
#define kPCUMessageParamsOriginalImagePathKey @"imagePath"

/**
 *  PCUMessageParamsDefines
 */
#define kPCUMessageParamsErrorDescriptionKey @"errorDescription"

/**
 *  Notification An Avatar has been cached
 */
#define kPCUAvatarManagerDidResponseUIImageNotification @"kPCUAvatarManagerDidResponseUIImageNotification"

/**
 *  Defines Avatar Manager TMCache Prefix Key
 */
#define kPCUAvatarManagerTMCachePrefix @"kPCUAvatarManagerTMCachePrefix"

@interface PCUDefines : NSObject

@end
