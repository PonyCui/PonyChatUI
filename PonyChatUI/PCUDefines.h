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
 *  音频消息，音频地址
 */
#define kPCUMessageParamsVoicePathKey @"voicePath"

/**
 *  PCUMessageParamsDefines
 *  图片消息，缩略图地址
 */
#define kPCUMessageParamsThumbImagePathKey @"thumbPath"

/**
 *  PCUMessageParamsDefines
 *  图片消息，原图地址
 */
#define kPCUMessageParamsOriginalImagePathKey @"imagePath"

/**
 *  PCUMessageParamsDefines
 *  链接消息，链接图标
 */
#define kPCUMessageParamsLinkIconPathKey @"iconPath"

/**
 *  PCUMessageParamsDefines
 *  链接消息，链接描述
 */
#define kPCUMessageParamsLinkDescriptionKey @"linkDescription"


#define kPCUMessageParamsLinkURLKey @"linkUrl"

/**
 *  PCUMessageParamsDefines
 *  应用错误，错误描述
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
