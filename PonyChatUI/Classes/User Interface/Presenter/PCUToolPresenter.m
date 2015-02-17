//
//  PCUToolPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-17.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUToolPresenter.h"
#import "PCUToolViewController.h"
#import "PCUChatInterator.h"

@implementation PCUToolPresenter

- (void)sendTextMessage {
    [self.chatInteractor sendTextMessageWithString:self.userInterface.textField.text];
    self.userInterface.textField.text = @"";
}

@end
