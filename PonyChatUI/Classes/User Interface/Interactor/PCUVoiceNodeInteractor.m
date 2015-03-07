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
#import <AFNetworking/AFNetworking.h>

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
            NSString *localCachePath = [NSTemporaryDirectory() stringByAppendingFormat:@".remoteVoice.%@", self.message.identifier];
            if ([[NSFileManager defaultManager] fileExistsAtPath:localCachePath]) {
                [self responseWithVoiceFileLocalPath:localCachePath];
            }
            else {
                self.isFailed = NO;
                self.isPreparing = YES;
                NSURL *remoteURL = [NSURL URLWithString:self.message.params[kPCUMessageParamsVoicePathKey]];
                NSURLRequest *request = [NSURLRequest requestWithURL:remoteURL
                                                         cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                     timeoutInterval:60.0];
                AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
                [operation
                 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                     self.isPreparing = NO;
                     if ([responseObject isKindOfClass:[NSData class]]) {
                         NSError *error;
                         [responseObject writeToFile:localCachePath options:kNilOptions error:&error];
                         if (error == nil) {
                             [self responseWithVoiceFileLocalPath:localCachePath];
                         }
                     }
                }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     self.isPreparing = NO;
                     self.isFailed = YES;
                }];
                [[[AFHTTPSessionManager manager] operationQueue] addOperation:operation];
            }
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

#pragma mark - Play Control

/**
 *  @YES 使用听筒
 *  @NO  使用扬声器、耳机
 */
- (BOOL)shouldUseBuiltInSpeaker {
    if (![PCUApplication canUseBuiltInSpeaker]) {
        return NO;
    }
    else {
        return [[UIDevice currentDevice] proximityState];
    }
}

- (void)play {
    [self sendEndPlayingNotification];
    if (self.isPrepared) {
        self.isRead = YES;
        [self configureEndPlayingNotification];
        [self configureSensorNotification];
        [self switchSpeaker];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        self.isPlaying = YES;
        [self.audioPlayer play];
    }
}

- (void)switchSpeaker {
    if ([self shouldUseBuiltInSpeaker]) {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                                         withOptions:kNilOptions
                                               error:nil];
    }
    else {
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:kNilOptions
                                               error:nil];
    }
}

- (void)pause {
    self.isPlaying = NO;
    [self.audioPlayer stop];
    [self removeEndPlayingNotification];
    [self removeSensorNotification];
}

#pragma mark - SensorNotification

- (void)configureSensorNotification {
    if ([PCUApplication canUseBuiltInSpeaker]) {
        [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(switchSpeaker)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
    }
}

- (void)removeSensorNotification {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceProximityStateDidChangeNotification
                                                  object:nil];
}

#pragma mark - EndPlayingNotification

- (void)sendEndPlayingNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPCUEndPlayingNotification object:nil];
}

- (void)configureEndPlayingNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(pause)
                                                 name:kPCUEndPlayingNotification
                                               object:nil];
}

- (void)removeEndPlayingNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPCUEndPlayingNotification object:nil];
}

#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.isPlaying = NO;
    [[AVAudioSession sharedInstance] setActive:NO
                                   withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                                         error:nil];
}

@end
