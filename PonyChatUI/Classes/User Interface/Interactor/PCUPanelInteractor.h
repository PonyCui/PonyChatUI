//
//  PCUPanelInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-22.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCUPanelInteractor : NSObject

/**
 *  NSArray -> PCUPanelItemInteractor
 */
@property (nonatomic, copy) NSArray *items;

- (void)findItems;

@end
