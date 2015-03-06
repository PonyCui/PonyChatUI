//
//  PCUPanelItemInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-22.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PCUPanelItem, UIImage;

@interface PCUPanelItemInteractor : NSObject

@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) UIImage *iconImage;

- (instancetype)initWithPanelItem:(PCUPanelItem *)item;

/**
 *  发送请求
 */
- (void)sendRequestWithViewController:(UIViewController *)viewController;

@end
