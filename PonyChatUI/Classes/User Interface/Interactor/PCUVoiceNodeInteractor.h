//
//  PCUVoiceNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeInteractor.h"

typedef NS_ENUM(NSInteger, PCUVoiceNodeVoiceStatus) {
    PCUVoiceNodeVoiceStatusPreparing,
    PCUVoiceNodeVoiceStatusPrePared,
    PCUVoiceNodeVoiceStatusPrepareFailed
};

@class PCUMessage;
@interface PCUVoiceNodeInteractor : PCUNodeInteractor

@property (nonatomic, assign) PCUVoiceNodeVoiceStatus voiceStatus;

/**
 *  是否已经准备好声音文件以供播放
 */
@property (nonatomic, assign) BOOL isPrepared;

/**
 *  声音文件正在加载
 */
@property (nonatomic, assign) BOOL isPreparing;

/**
 *  声音文件加载失败
 */
@property (nonatomic, assign) BOOL isFailed;

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

/**
 *  触发音频文件加载请求
 */
- (void)sendAsyncVoiceFileRequest;

@end
