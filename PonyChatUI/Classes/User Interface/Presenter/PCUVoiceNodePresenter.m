//
//  PCUVoiceNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUVoiceNodePresenter.h"
#import "PCUVoiceNodeViewController.h"
#import "PCUVoiceNodeInteractor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PCUVoiceNodePresenter ()

@property (nonatomic, weak) PCUVoiceNodeViewController *userInterface;

@property (nonatomic, strong) PCUVoiceNodeInteractor *nodeInteractor;

@end

@implementation PCUVoiceNodePresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)updateView {
    [super updateView];
    [self.userInterface setSenderThumbImageViewWithImage:self.nodeInteractor.senderThumbImage];
    [self.userInterface setDuringLabelTextWithDuringTime:self.nodeInteractor.voiceDuring];
    [self.userInterface setPlayButtonAnimated:self.nodeInteractor.isPlaying];
    [self.userInterface setUnreadSignalHidden:self.nodeInteractor.isRead];
}

- (void)configureReactiveCocoa {
    [super configureReactiveCocoa];
    @weakify(self);
    [RACObserve(self, nodeInteractor.senderThumbImage) subscribeNext:^(UIImage *x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setSenderThumbImageViewWithImage:x];
        });
    }];
    [RACObserve(self, nodeInteractor.voiceDuring) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setDuringLabelTextWithDuringTime:self.nodeInteractor.voiceDuring];
        });
    }];
    [RACObserve(self, nodeInteractor.isPlaying) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setPlayButtonAnimated:self.nodeInteractor.isPlaying];
        });
    }];
    [RACObserve(self, nodeInteractor.isRead) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setUnreadSignalHidden:self.nodeInteractor.isRead];
        });
    }];
}

- (void)toggleVoice {
    if (!self.nodeInteractor.isPlaying) {
        [self.nodeInteractor play];
    }
    else {
        [self.nodeInteractor pause];
    }
}

@end
