//
//  PCUPanelPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-22.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelPresenter.h"
#import "PCUPanelViewController.h"
#import "PCUPanelInteractor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation PCUPanelPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.panelInteractor = [[PCUPanelInteractor alloc] init];
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)updateView {
    [self.panelInteractor findItems];
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, panelInteractor.items) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface reloadCollectionView];
        });
    }];
}

@end
