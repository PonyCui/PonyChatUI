//
//  PCUGalleryImagePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUGalleryImagePresenter.h"
#import "PCUImageNodeInteractor.h"
#import "PCUGalleryImageViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation PCUGalleryImagePresenter

- (void)dealloc
{
    self.nodeInteractor.originalImage = nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)setNodeInteractor:(PCUImageNodeInteractor *)nodeInteractor {
    _nodeInteractor.originalImage = nil;
    _nodeInteractor = nodeInteractor;
}

- (void)updateView {
    if (self.nodeInteractor.thumbImage != nil) {
        [self.userInterface setImage:self.nodeInteractor.thumbImage];
        [self.userInterface.imageLoadingActivityIndicator startAnimating];
    }
    [self.nodeInteractor sendOriginalImageAsyncRequest];
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, nodeInteractor.originalImage) subscribeNext:^(id x) {
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.userInterface setImage:self.nodeInteractor.originalImage];
            [self.userInterface.imageLoadingActivityIndicator stopAnimating];
        });
    }];
}

@end
