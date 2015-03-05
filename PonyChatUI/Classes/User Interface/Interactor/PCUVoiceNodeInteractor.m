//
//  PCUVoiceNodeInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUVoiceNodeInteractor.h"
#import "PCUApplication.h"
#import "PCUAvatarManager.h"
#import "PCUMessage.h"
#import "PCUSender.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface PCUVoiceNodeInteractor ()<AVAudioPlayerDelegate>

@property (nonatomic, readwrite) BOOL isPlaying;

@property (nonatomic, copy) NSString *senderThumbURLString;

@property (nonatomic, strong) PCUMessage *message;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation PCUVoiceNodeInteractor

- (instancetype)initWithMessage:(PCUMessage *)message {
    self = [super initWithMessage:message];
    if (self) {
        self.message = message;
        self.voiceDuring = -1;
        self.senderThumbURLString = message.sender.thumbURLString;
        self.senderThumbImage = [PCU[[PCUAvatarManager class]]
                                 sendSyncRequestWithURLString:self.senderThumbURLString];
        if (self.senderThumbImage == nil) {
            [PCU[[PCUAvatarManager class]] sendAsyncRequestWithURLString:self.senderThumbURLString];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAvatarManagerResponseUIImage:)
                                                     name:kPCUAvatarManagerDidResponseUIImageNotification
                                                   object:nil];
        [self sendAsyncVoiceFileRequest];
    }
    return self;
}

- (void)handleAvatarManagerResponseUIImage:(NSNotification *)sender {
    if ([[sender userInfo][@"URLString"] isEqualToString:self.senderThumbURLString] &&
        [sender.object isKindOfClass:[UIImage class]]) {
        self.senderThumbImage = sender.object;
    }
}

- (void)sendAsyncVoiceFileRequest {
    if (self.message.params[kPCUMessageParamsVoicePathKey] != nil) {
        if ([self.message.params[kPCUMessageParamsVoicePathKey] hasPrefix:@"http"]) {
            
        }
        else {
            [self responseWithVoiceFileLocalPath:self.message.params[kPCUMessageParamsVoicePathKey]];
        }
    }
}

- (void)responseWithVoiceFileLocalPath:(NSString *)localPath {
    NSError *error = nil;
    NSURL *URL = [[NSURL alloc] initFileURLWithPath:localPath];
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:URL
                                                       fileTypeHint:AVFileTypeMPEG4
                                                              error:&error];
    if (error == nil) {
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.delegate = self;
        self.isPrepared = YES;
        self.voiceDuring = (NSInteger)ceil(self.audioPlayer.duration);
    }
}

- (void)play {
    if (self.isPrepared) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:kNilOptions
                                               error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        self.isPlaying = YES;
        [self.audioPlayer play];
    }
}

- (void)pause {
    [self.audioPlayer stop];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.isPlaying = NO;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}

@end
