//
//  PCUTextNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUTextNodePresenter.h"
#import "PCUTextNodeViewController.h"
#import "PCUTextNodeInteractor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PCUTextNodePresenter ()

@property (nonatomic, weak) PCUTextNodeViewController *userInterface;

@property (nonatomic, strong) PCUTextNodeInteractor *nodeInteractor;

@end

@implementation PCUTextNodePresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)updateView {
    [super updateView];
    [self.userInterface setTextLabelTextWithString:self.nodeInteractor.titleString];
}

- (void)configureReactiveCocoa {
    [super configureReactiveCocoa];
    @weakify(self);
    [RACObserve(self, nodeInteractor.titleString) subscribeNext:^(NSString *x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setTextLabelTextWithString:x];
        });
    }];
}

@end
