//
//  PCUPanelItemPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-19.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelItemPresenter.h"
#import "PCUPanelItemInteractor.h"
#import "PCUPanelCollectionViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation PCUPanelItemPresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)updateView {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userInterface.titleLabel.text = self.itemInteractor.titleString;
        self.userInterface.imageView.image = self.itemInteractor.iconImage;
    });
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, itemInteractor.titleString) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userInterface.titleLabel.text = x;
        });
    }];
    [RACObserve(self, itemInteractor.iconImage) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userInterface.imageView.image = x;
        });
    }];
}

- (void)sendAction {
    id chatViewController = self.userInterface.panelViewController;//PCUChatViewController
    while (![NSStringFromClass([chatViewController class]) isEqualToString:@"PCUChatViewController"] &&
           chatViewController != nil) {
        chatViewController = [chatViewController parentViewController];
    }
    [self.itemInteractor sendRequestWithViewController:chatViewController];
}

- (void)setItemInteractor:(PCUPanelItemInteractor *)itemInteractor {
    _itemInteractor = itemInteractor;
    [self updateView];
}

@end
