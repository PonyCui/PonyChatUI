//
//  PCUVoiceNodeViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCUNodeViewController.h"

@interface PCUVoiceNodeViewController : PCUNodeViewController

- (void)setSenderThumbImageViewWithImage:(UIImage *)image;

- (void)setDuringLabelTextWithDuringTime:(NSInteger)duringTime;

- (void)setPlayButtonAnimated:(BOOL)isAnimated;

- (void)setUnreadSignalHidden:(BOOL)isHidden;

- (void)setVoicePreparing:(BOOL)isPreparing;

- (void)setVoiceRequestFail:(BOOL)isFail;

@end
