//
//  PCUChatViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCUNodeViewController.h"

@class PCUChatPresenter, PCUTextNodeViewController, PCUToolViewController;

@interface PCUChatViewController : UIViewController<PCUNodeViewControllerDelegate>

@property (nonatomic, strong) PCUChatPresenter *eventHandler;

@property (nonatomic, strong) PCUToolViewController *toolViewController;

#pragma mark - Datasource

- (void)reloadData;

#pragma mark - Layouts

- (void)configureViewLayouts;

- (void)setBottomLayoutHeight:(CGFloat)layoutHeight;

- (void)scrollToBottom:(BOOL)animated;

@end
