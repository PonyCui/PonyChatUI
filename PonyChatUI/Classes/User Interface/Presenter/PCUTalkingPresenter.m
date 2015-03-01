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
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface PCUTalkingPresenter ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioSession *audioSession;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) NSTimer *audioMeterTimer;

@property (nonatomic, strong) NSString *audioFilePath;

@end

@implementation PCUTalkingPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.audioSession = [AVAudioSession sharedInstance];
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
    if (self.audioSession.isOtherAudioPlaying) {
        [self.userInterface.talkingHUDViewController setWaiting:YES];
        [self performSelector:@selector(performRecording) withObject:nil afterDelay:0.001];
    }
    else {
        [self performRecording];
    }
}

- (void)performRecording {
    NSError *error;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                       withOptions:AVAudioSessionCategoryOptionDuckOthers
                             error:&error];
    if (error == nil) {
        [self.audioSession setActive:YES error:&error];
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
    [self endRecording];
}

- (void)endRecording {
    [self.audioMeterTimer invalidate];
    [self.audioRecorder stop];
    self.audioFilePath = nil;
}

#pragma mark - AVAudioRecorderDelegate

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    [self.audioSession setActive:NO error:nil];
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
