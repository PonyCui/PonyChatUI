//
//  PCUNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PCUNodePresenter.h"
#import "PCUTextNodePresenter.h"
#import "PCUSystemNodePresenter.h"
#import "PCUNodeInteractor.h"
#import "PCUTextNodeInteractor.h"
#import "PCUSystemNodeInteractor.h"
#import "PCUNodeViewController.h"


@implementation PCUNodePresenter

+ (PCUNodePresenter *)nodePresenterWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor {
    if ([nodeInteractor isKindOfClass:[PCUTextNodeInteractor class]]) {
        PCUTextNodePresenter *textNodePresenter = [[PCUTextNodePresenter alloc] init];
        textNodePresenter.nodeInteractor = nodeInteractor;
        return textNodePresenter;
    }
    else if ([nodeInteractor isKindOfClass:[PCUSystemNodeInteractor class]]) {
        PCUSystemNodePresenter *systemNodePresenter = [[PCUSystemNodePresenter alloc] init];
        systemNodePresenter.nodeInteractor = nodeInteractor;
        return systemNodePresenter;
    }
    else {
        return nil;
    }
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)updateView {
    [self updateIndicatorView];
}

- (void)updateIndicatorView {
    if (self.nodeInteractor.isOwner) {
        if ([self.userInterface respondsToSelector:@selector(sendingIndicatorView)]) {
            if (self.nodeInteractor.sendStatus == PCUNodeSendMessageStatusSending) {
                [[self.userInterface sendingIndicatorView] startAnimating];
            }
            else {
                [[self.userInterface sendingIndicatorView] stopAnimating];
            }
        }
    }
}

- (void)removeViewFromSuperView {
    [self.userInterface.view removeFromSuperview];
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, nodeInteractor.sendStatus) subscribeNext:^(id x) {
        @strongify(self);
        [self updateIndicatorView];
    }];
}

@end
