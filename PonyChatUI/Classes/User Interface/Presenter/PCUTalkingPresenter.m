//
//  PCUTalkingPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUTalkingPresenter.h"
#import "PCUTalkingViewController.h"
#import "PCUTalkingHUDViewController.h"
#import "PCUChatInteractor.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface PCUTalkingPresenter ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) NSTimer *audioMeterTimer;

@property (nonatomic, strong) NSString *audioFilePath;

@end

@implementation PCUTalkingPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)updateMeterView {
    [self.audioRecorder updateMeters];
    CGFloat power = [self.audioRecorder averagePowerForChannel:0];
    NSInteger value = 1;
    value = (32 - abs(power)) / 4;
    value = MIN(8, MAX(value, 1));
    [self.userInterface.talkingHUDViewController setVoiceValue:value];
}

- (void)startRecording {
    if ([AVAudioSession sharedInstance].isOtherAudioPlaying) {
        [self.userInterface.talkingHUDViewController setWaiting:YES];
        [self performSelector:@selector(performRecording) withObject:nil afterDelay:0.001];
    }
    else {
        [self performRecording];
    }
}

- (void)performRecording {
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord
                       withOptions:kNilOptions
                             error:&error];
    if (error == nil) {
        [[AVAudioSession sharedInstance] setActive:YES error:&error];
        [self.userInterface.talkingHUDViewController setWaiting:NO];
        if (error == nil) {
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:self.audioFilePath];
            self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL
                                                             settings:[self recordSetting]
                                                                error:&error];
            self.audioRecorder.meteringEnabled = YES;
            self.audioRecorder.delegate = self;
            if (error == nil) {
                [self.audioRecorder record];
                self.audioMeterTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                        target:self
                                                                      selector:@selector(updateMeterView)
                                                                      userInfo:nil
                                                                       repeats:YES];
            }
        }
    }
}

- (void)cancelRecord {
    [self endRecordingWithCancel:YES];
}

- (void)endRecording {
    [self endRecordingWithCancel:NO];
}

- (void)endRecordingWithCancel:(BOOL)isCancel {
    [self.audioMeterTimer invalidate];
    [self.audioRecorder stop];
    if (!isCancel) {
        [self sendMessageWithFilePath:self.audioFilePath];
    }
    else {
        [[NSFileManager defaultManager] removeItemAtPath:self.audioFilePath error:nil];
    }
    self.audioFilePath = nil;
}

- (void)sendMessageWithFilePath:(NSString *)filePath {
    [self.chatInteractor sendVoiceMessageWithPath:filePath];
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [[AVAudioSession sharedInstance] setActive:NO
                     withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation
                           error:nil];
}

#pragma mark - configuration

- (NSDictionary *)recordSetting {
    return @{
             AVFormatIDKey : @(kAudioFormatMPEG4AAC),
             AVSampleRateKey : @(44100.0),
             AVNumberOfChannelsKey : @(2)
             };
}

- (NSString *)audioFilePath {
    if (_audioFilePath == nil) {
        _audioFilePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@".%u%u", arc4random(), arc4random()]];
    }
    return _audioFilePath;
}

@end
