//
//  PCUPanelInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-22.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelInteractor.h"
#import "PCUPanelItemManager.h"
#import "PCUPanelItemInteractor.h"

@interface PCUPanelInteractor ()

@property (nonatomic, strong) PCUPanelItemManager *itemManager;

@end

@implementation PCUPanelInteractor

- (void)findItems {
    NSArray *dataItems = [self.itemManager standardItems];
    NSMutableArray *interactorItems = [NSMutableArray array];
    [dataItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [interactorItems addObject:[[PCUPanelItemInteractor alloc] initWithPanelItem:obj]];
    }];
    self.items = interactorItems;
}

- (PCUPanelItemManager *)itemManager {
    if (_itemManager == nil) {
        _itemManager = [[PCUPanelItemManager alloc] init];
    }
    return _itemManager;
}

@end
