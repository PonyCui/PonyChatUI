//
//  PCUNodeViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCUNodePresenter.h"

@protocol PCUNodeViewControllerDelegate <NSObject>

@required
- (void)nodeViewHeightDidChange;

@end

@class PCUNodeInteractor, PCUNodePresenter;

@interface PCUNodeViewController : UIViewController

@property (nonatomic, weak) id<PCUNodeViewControllerDelegate> delegate;

@property (nonatomic, strong) PCUNodePresenter *eventHandler;

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

+ (PCUNodeViewController *)nodeViewControllerWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor;

- (void)configureLayouts;

@end
