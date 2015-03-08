//
//  PCUVoiceNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeInteractor.h"

typedef NS_ENUM(NSInteger, PCUVoiceNodeVoiceStatus) {
    PCUVoiceNodeVoiceStatusPreparing = 0,
    PCUVoiceNodeVoiceStatusPrePared,
    PCUVoiceNodeVoiceStatusPrepareFailed
};

@class PCUMessage;
@interface PCUVoiceNodeInteractor : PCUNodeInteractor

/**
 *  声音加载状态
 */
@property (nonatomic, assign) PCUVoiceNodeVoiceStatus voiceStatus;

/**
 *  声音文件正在播放
 */
@property (nonatomic, readonly) BOOL isPlaying;

/**
 *  声音文件可播放长度
 */
@property (nonatomic, assign) NSInteger voiceDuring;

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

/**
 *  触发音频文件加载请求
 */
- (void)sendAsyncVoiceFileRequest;

@end
