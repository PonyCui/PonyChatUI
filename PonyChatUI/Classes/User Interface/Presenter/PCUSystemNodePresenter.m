//
//  PCUSystemNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/16.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUSystemNodePresenter.h"
#import "PCUSystemNodeViewController.h"
#import "PCUSystemNodeInteractor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PCUSystemNodePresenter ()

@property (nonatomic, weak) PCUSystemNodeViewController *userInterface;

@property (nonatomic, strong) PCUSystemNodeInteractor *nodeInteractor;

@end

@implementation PCUSystemNodePresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)configureReactiveCocoa {
    [super configureReactiveCocoa];
    @weakify(self);
    [RACObserve(self, nodeInteractor.titleString) subscribeNext:^(id x) {
        @strongify(self);
        [self updateView];
    }];
}

- (void)updateView {
    [self.userInterface setTextWithString:self.nodeInteractor.titleString];
}

@end
