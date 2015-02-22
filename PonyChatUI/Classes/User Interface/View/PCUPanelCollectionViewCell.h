//
//  PCUPanelCollectionViewCell.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-18.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PCUPanelItemPresenter;

@interface PCUPanelCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) PCUPanelItemPresenter *eventHandler;

#pragma mark - IBOutlet

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
