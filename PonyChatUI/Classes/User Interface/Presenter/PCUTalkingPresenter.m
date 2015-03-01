//
//  PCUTalkingPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUTalkingPresenter.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface PCUTalkingPresenter ()<AVAudioRecorderDelegate>

@property (nonatomic, strong) AVAudioSession *audioSession;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

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

- (void)startRecording {
    NSError *error;
    [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                       withOptions:AVAudioSessionCategoryOptionDuckOthers
                             error:&error];
    if (error == nil) {
        [self.audioSession setActive:YES error:&error];
        if (error == nil) {
            NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:self.audioFilePath];
            self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL
                                                             settings:[self recordSetting]
                                                                error:&error];
            self.audioRecorder.delegate = self;
            if (error == nil) {
                [self.audioRecorder record];
            }
        }
    }
}

- (void)cancelRecord {
    [self endRecording];
}

- (void)endRecording {
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
