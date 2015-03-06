//
//  PCUVoiceNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeInteractor.h"

@class PCUMessage;
@interface PCUVoiceNodeInteractor : PCUNodeInteractor

/**
 *  是否已经准备好声音文件以供播放
 */
@property (nonatomic, assign) BOOL isPrepared;

/**
 *  声音文件正在播放
 */
@property (nonatomic, readonly) BOOL isPlaying;

/**
 *  声音文件可播放长度
 */
@property (nonatomic, assign) NSInteger voiceDuring;

/**
 *  @brief 发送者头像缩略图
 */
@property (nonatomic, copy) UIImage  *senderThumbImage;

- (instancetype)initWithMessage:(PCUMessage *)message;

/**
 *  播放声音
 */
- (void)play;

/**
 *  切换听筒、扬声器
 */
- (void)switchSpeaker;

/**
 *  暂停播放
 */
- (void)pause;

@end
