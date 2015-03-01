//
//  PCUTalkingViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUTalkingPresenter, PCUTalkingHUDViewController, PCUTalkingCancelHUDViewController;

@interface PCUTalkingViewController : UIViewController

@property (nonatomic, strong) PCUTalkingPresenter *eventHandler;

@property (nonatomic, strong) PCUTalkingHUDViewController *talkingHUDViewController;

@property (nonatomic, strong) PCUTalkingCancelHUDViewController *cancelHUDViewController;

@end
