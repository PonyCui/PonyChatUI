//
//  PCUChatViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUChatPresenter;

@interface PCUChatViewController : UIViewController

@property (nonatomic, strong) PCUChatPresenter *chatPresenter;

- (void)setBottomLayoutHeight:(CGFloat)layoutHeight;

@end
