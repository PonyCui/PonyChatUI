//
//  PCUGalleryImagePresenter.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUGalleryImageViewController, PCUImageNodeInteractor;

@interface PCUGalleryImagePresenter : NSObject

@property (nonatomic, weak) PCUGalleryImageViewController *userInterface;

@property (nonatomic, strong) PCUImageNodeInteractor *nodeInteractor;

- (void)updateView;

@end
