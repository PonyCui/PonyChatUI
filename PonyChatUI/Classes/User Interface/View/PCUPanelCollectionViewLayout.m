//
//  PCUPanelCollectionViewLayout.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-18.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelCollectionViewLayout.h"

#define kPCUPanelItemWidth 60.0

@implementation PCUPanelCollectionViewLayout

- (void)configureInsetWithBounds:(CGRect)bounds {
    CGFloat gapWidth = (CGRectGetWidth(bounds) - 60.0 * 4.0) / 5.0;
    self.sectionInset = UIEdgeInsetsMake(14, gapWidth, 0, gapWidth);
    self.minimumLineSpacing = gapWidth;
}

@end
