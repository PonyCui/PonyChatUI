//
//  PCUGalleryPageViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUNodeInteractor;

@protocol PCUGalleryDataSource <NSObject>

- (PCUNodeInteractor *)galleryEnterNode;

- (NSArray *)galleryNodes;

@end

@interface PCUGalleryPageViewController : UIPageViewController

@property (nonatomic, weak) id<PCUGalleryDataSource> galleryDataSource;

@end
