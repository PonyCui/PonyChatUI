//
//  PCUToolPresenter.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-17.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUToolViewController, PCUChatInteractor;

@interface PCUToolPresenter : NSObject

@property (nonatomic, weak) PCUToolViewController *userInterface;

@property (nonatomic, weak) PCUChatInteractor *chatInteractor;

- (void)sendTextMessage;

- (void)togglePanelView;

- (void)toggleEmotionView;

@end
