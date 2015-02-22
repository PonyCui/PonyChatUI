//
//  PCUPanelCollectionViewCell.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-18.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelCollectionViewCell.h"
#import "PCUPanelItemPresenter.h"

@interface PCUPanelCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PCUPanelCollectionViewCell

- (void)awakeFromNib {
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.0;
    self.imageView.layer.cornerRadius = 6.0;
    self.imageView.layer.borderColor = [UIColor colorWithRed:202.0/255.0
                                                       green:204.0/255.0
                                                        blue:206.0/255.0
                                                       alpha:1.0].CGColor;
}

- (PCUPanelItemPresenter *)eventHandler {
    if (_eventHandler == nil) {
        _eventHandler = [[PCUPanelItemPresenter alloc] init];
        _eventHandler.userInterface = self;
    }
    return _eventHandler;
}

@end
