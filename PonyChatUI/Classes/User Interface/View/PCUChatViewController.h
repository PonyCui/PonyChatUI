//
//  PCUChatViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PCUChatPresenter, PCUTextNodeViewController, PCUToolViewController;

@interface PCUChatViewController : UIViewController

@property (nonatomic, strong) PCUChatPresenter *eventHandler;

@property (nonatomic, strong) PCUToolViewController *toolViewController;

#pragma mark - Layouts

- (void)setBottomLayoutHeight:(CGFloat)layoutHeight;

#pragma mark - Node Operations

- (void)addNodeViewController:(PCUTextNodeViewController *)nodeViewController;

- (void)insertNodeViewController:(PCUTextNodeViewController *)nodeViewController
                         atIndex:(NSUInteger)index;

- (void)removeNodeViewController:(PCUTextNodeViewController *)nodeViewController;

- (void)removeNodeViewControllerAtIndex:(NSUInteger)index;

- (void)scrollToLastNodeViewController;

@end
