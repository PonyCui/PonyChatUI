//
//  PCUImageNodeViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-7.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeViewController.h"

@interface PCUImageNodeViewController : PCUNodeViewController

- (void)setSenderThumbImageViewWithImage:(UIImage *)image;

- (void)setSenderNickLabelTextWithString:(NSString *)string;

- (void)setThumbImage:(UIImage *)thumbImage;

- (void)setThumbImageViewIsLoading:(BOOL)isLoading;

@end
