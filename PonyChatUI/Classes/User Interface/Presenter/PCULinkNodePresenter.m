//
//  PCULinkNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCULinkNodePresenter.h"
#import "PCULinkNodeInteractor.h"
#import "PCULinkNodeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PCULinkNodePresenter ()

@property (nonatomic, weak) PCULinkNodeViewController *userInterface;

@property (nonatomic, strong) PCULinkNodeInteractor *nodeInteractor;

@end

@implementation PCULinkNodePresenter

- (void)updateView {
    [super updateView];
    self.userInterface.linkIconImageView.image = self.nodeInteractor.iconImage;
    self.userInterface.titleLabel.text = self.nodeInteractor.titleString;
    self.userInterface.descriptionLabel.text = self.nodeInteractor.descriptionString;
}

- (void)configureReactiveCocoa {
    [super configureReactiveCocoa];
    @weakify(self);
    [RACObserve(self, nodeInteractor.iconImage) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userInterface.linkIconImageView.image = self.nodeInteractor.iconImage;
        });
    }];
    [RACObserve(self, nodeInteractor.titleString) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userInterface.titleLabel.text = self.nodeInteractor.titleString;
        });
    }];
    [RACObserve(self, nodeInteractor.descriptionString) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userInterface.descriptionLabel.text = self.nodeInteractor.descriptionString;
        });
    }];
}

- (void)openLink {
    if (self.nodeInteractor.linkURLString.length) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.nodeInteractor.linkURLString]];
    }
}

@end
