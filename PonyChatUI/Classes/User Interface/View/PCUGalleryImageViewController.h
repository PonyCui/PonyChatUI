//
//  PCUGalleryImageViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUGalleryImagePresenter;

@interface PCUGalleryImageViewController : UIViewController

@property (nonatomic, strong) PCUGalleryImagePresenter *eventHandler;

- (void)setImage:(UIImage *)image;

#pragma mark - IBOutlet

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *imageLoadingActivityIndicator;

@end
