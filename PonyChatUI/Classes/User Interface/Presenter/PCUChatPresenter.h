//
//  PCUChatViewPresenter.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUChatViewController, PCUChatInteractor;

@interface PCUChatPresenter : NSObject

@property (nonatomic, strong) PCUChatViewController *userInterface;

@property (nonatomic, strong) PCUChatInteractor *chatInteractor;

- (NSArray *)orderedEventHandler;

@end
