//
//  PCULinkNodeViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeViewController.h"

@interface PCULinkNodeViewController : PCUNodeViewController

#pragma mark - IBOutlet

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *linkIconImageView;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
