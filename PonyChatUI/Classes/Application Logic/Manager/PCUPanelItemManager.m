//
//  PCUPanelItemManager.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-22.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelItemManager.h"
#import "PCUPanelItem.h"

@implementation PCUPanelItemManager

/**
 *  一些基础对话组件
 *
 *  @return NSArray
 */
- (NSArray *)standardItems {
    return [NSArray arrayWithObjects:
            [self album],
            nil];
}

#pragma mark - Item Defines

- (PCUPanelItem *)album {
    PCUPanelItem *item = [[PCUPanelItem alloc] init];
    item.title = @"照片";
    item.iconURLString = @"http://tp2.sinaimg.cn/1930378853/180/40066682121/1";
    item.actionURLString = @"http://www.baidu.com/";
    return item;
}

@end
