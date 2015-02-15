//
//  PCUChatViewPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUChatPresenter.h"
#import "PCUChatViewController.h"
#import "PCUChatInterator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation PCUChatPresenter

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureReactiveCocoa];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    return self;
}

- (void)handleKeyboardWillShowNotification:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardHeight = CGRectGetHeight(keyboardFrame);
    [self.userInterface setBottomLayoutHeight:keyboardHeight];
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)notification {
    [self.userInterface setBottomLayoutHeight:0];
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, chatInteractor.titleString) subscribeNext:^(id x) {
        @strongify(self);
        self.userInterface.title = x;
    }];
    [RACObserve(self, chatInteractor.nodeInteractors) subscribeNext:^(id x) {
        @strongify(self);
        [self updateChatView];
    }];
}

- (void)updateChatView {
    
}

@end
