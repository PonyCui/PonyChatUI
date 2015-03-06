//
//  PCUVoiceNodeViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUVoiceNodeViewController.h"
#import "PCUVoiceNodePresenter.h"

@interface PCUVoiceNodeViewController () {
    NSInteger _playButtonAnimatingFrame;
}

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *sendingRetryButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceNodeBackgroundWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *duringLabel;

@property (nonatomic, strong) PCUVoiceNodePresenter *eventHandler;

@property (nonatomic, strong) NSTimer *playButtonAnimatingTimer;

@property (weak, nonatomic) IBOutlet UIImageView *playButtonImageView;

@end

@implementation PCUVoiceNodeViewController

- (CGFloat)heightConstraintDefaultValue {
    return 60.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.eventHandler updateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Render

- (void)setSenderThumbImageViewWithImage:(UIImage *)image {
    self.iconImageView.image = image;
}

#pragma mark - Juhua

- (void)sendingIndicatorViewStartAnimating {
    [super sendingIndicatorViewStartAnimating];
    self.duringLabel.hidden = YES;
}

- (void)sendingIndicatorViewStopAnimating {
    [super sendingIndicatorViewStopAnimating];
    if (self.duringLabel.text.length) {
        self.duringLabel.hidden = NO;
    }
}

- (void)setSendingRetryButtonHidden:(BOOL)isHidden {
    [super setSendingRetryButtonHidden:isHidden];
    if (isHidden && !self.sendingIndicatorView.isAnimating) {
        if (self.duringLabel.text.length) {
            self.duringLabel.hidden = NO;
        }
    }
    else {
        self.duringLabel.hidden = YES;
    }
}

- (void)setDuringLabelTextWithDuringTime:(NSInteger)duringTime {
    if (duringTime <= 0) {
        self.duringLabel.text = @"";
    }
    else {
        self.duringLabel.text = [NSString stringWithFormat:@"%ld''", (long)duringTime];
        [self adjustBackgroundImageViewWidthWithDuringTime:duringTime];
    }
}

- (void)adjustBackgroundImageViewWidthWithDuringTime:(NSInteger)duringTime {
    self.voiceNodeBackgroundWidthConstraint.constant = MIN(66.0 + (duringTime - 1) * 5, 220.0);
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    }];
}

/**
 *  isPaused  播放音频
 *  isPlaying 暂停播放
 */
- (IBAction)handleVoicePlayButtonTapped:(id)sender {
    [self.eventHandler toggleVoice];
}

- (void)setPlayButtonAnimated:(BOOL)isAnimated {
    if (isAnimated) {
        _playButtonAnimatingFrame = 1;
        __weak typeof(self) welf = self;
        [self.playButtonAnimatingTimer invalidate];
        self.playButtonAnimatingTimer = [NSTimer scheduledTimerWithTimeInterval:0.35
                                                                         target:self
                                                                       selector:@selector(updatePlayButtonAnimation)
                                                                       userInfo:nil
                                                                        repeats:YES];
    }
    else {
        [self.playButtonAnimatingTimer invalidate];
        if (self.isSender) {
            self.playButtonImageView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
        }
        else {
            self.playButtonImageView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
        }
    }
}

- (void)updatePlayButtonAnimation {
    if (self.isSender) {
        self.playButtonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%ld", (long)_playButtonAnimatingFrame]];
    }
    else {
        self.playButtonImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%ld", (long)_playButtonAnimatingFrame]];
    }
    _playButtonAnimatingFrame++;
    if (_playButtonAnimatingFrame > 3) {
        _playButtonAnimatingFrame = 1;
    }
}

@end
