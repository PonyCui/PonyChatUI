//
//  PCUNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PCUNodePresenter.h"
#import "PCUTextNodePresenter.h"
#import "PCUSystemNodePresenter.h"
#import "PCUVoiceNodePresenter.h"
#import "PCUImageNodePresenter.h"
#import "PCUNodeInteractor.h"
#import "PCUTextNodeInteractor.h"
#import "PCUSystemNodeInteractor.h"
#import "PCUVoiceNodeInteractor.h"
#import "PCUImageNodeInteractor.h"
#import "PCUNodeViewController.h"


@interface PCUNodePresenter ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIAlertView *retrySendMessageAlertView;

@end

@implementation PCUNodePresenter

+ (PCUNodePresenter *)nodePresenterWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor {
    if ([nodeInteractor isKindOfClass:[PCUTextNodeInteractor class]]) {
        PCUTextNodePresenter *textNodePresenter = [[PCUTextNodePresenter alloc] init];
        textNodePresenter.nodeInteractor = nodeInteractor;
        return textNodePresenter;
    }
    else if ([nodeInteractor isKindOfClass:[PCUSystemNodeInteractor class]]) {
        PCUSystemNodePresenter *systemNodePresenter = [[PCUSystemNodePresenter alloc] init];
        systemNodePresenter.nodeInteractor = nodeInteractor;
        return systemNodePresenter;
    }
    else if ([nodeInteractor isKindOfClass:[PCUVoiceNodeInteractor class]]) {
        PCUVoiceNodePresenter *voiceNodePresenter = [[PCUVoiceNodePresenter alloc] init];
        voiceNodePresenter.nodeInteractor = nodeInteractor;
        return voiceNodePresenter;
    }
    else if ([nodeInteractor isKindOfClass:[PCUImageNodeInteractor class]]) {
        PCUImageNodePresenter *imageNodePresenter = [[PCUImageNodePresenter alloc] init];
        imageNodePresenter.nodeInteractor = nodeInteractor;
        return imageNodePresenter;
    }
    else {
        return nil;
    }
}

- (void)dealloc {
    self.retrySendMessageAlertView.delegate = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)updateView {
    [self updateNodeStatus];
}

- (void)updateNodeStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.nodeInteractor.isOwner) {
            if (self.nodeInteractor.sendStatus == PCUNodeSendMessageStatusSending) {
                [self.userInterface sendingIndicatorViewStartAnimating];
                [self.userInterface setSendingRetryButtonHidden:YES];
            }
            else if (self.nodeInteractor.sendStatus == PCUNodeSendMessageStatusTimeout ||
                     self.nodeInteractor.sendStatus == PCUNodeSendMessageStatusError) {
                [self.userInterface sendingIndicatorViewStopAnimating];
                [self.userInterface setSendingRetryButtonHidden:NO];
            }
            else {
                [self.userInterface sendingIndicatorViewStopAnimating];
                [self.userInterface setSendingRetryButtonHidden:YES];
            }
        }
    });
}

- (void)removeViewFromSuperView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.userInterface.view removeFromSuperview];
    });
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, nodeInteractor.sendStatus) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateNodeStatus];
        });
    }];
}

- (void)retrySendMessage {
    self.retrySendMessageAlertView = [[UIAlertView alloc] initWithTitle:nil
                                                message:@"重发该消息？"
                                               delegate:self
                                      cancelButtonTitle:@"取消"
                                      otherButtonTitles:@"重发", nil];
    [self.retrySendMessageAlertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView == self.retrySendMessageAlertView && buttonIndex != alertView.cancelButtonIndex) {
        [self.nodeInteractor retrySendMessage];
    }
}

@end
