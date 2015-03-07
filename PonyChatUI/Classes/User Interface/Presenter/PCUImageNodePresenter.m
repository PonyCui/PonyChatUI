//
//  PCUImageNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-7.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUImageNodePresenter.h"
#import "PCUImageNodeViewController.h"
#import "PCUImageNodeInteractor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PCUImageNodePresenter ()

@property (nonatomic, weak) PCUImageNodeViewController *userInterface;

@property (nonatomic, strong) PCUImageNodeInteractor *nodeInteractor;

@end

@implementation PCUImageNodePresenter

- (void)updateView {
    [self.userInterface setThumbImage:self.nodeInteractor.thumbImage];
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, nodeInteractor.senderThumbImage) subscribeNext:^(UIImage *x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setSenderThumbImageViewWithImage:x];
        });
    }];
    [RACObserve(self, nodeInteractor.thumbImage) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setThumbImage:self.nodeInteractor.thumbImage];
        });
    }];
}

@end
