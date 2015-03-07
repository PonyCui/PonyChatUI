//
//  PCUNodeViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PCUNodePresenter.h"

@class PCUNodeInteractor, PCUNodePresenter;

@interface PCUNodeViewController : UIViewController

@property (nonatomic, assign) BOOL isSender;

@property (nonatomic, strong) PCUNodePresenter *eventHandler;

@property (nonatomic, strong) NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@property (nonatomic, strong) NSLayoutConstraint *bottomConstraint;

@property (nonatomic, readonly) CGFloat heightConstraintDefaultValue;

+ (PCUNodeViewController *)nodeViewControllerWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor;

- (void)configureLayouts;

- (void)sendingIndicatorViewStartAnimating;

- (void)sendingIndicatorViewStopAnimating;

- (void)setSendingRetryButtonHidden:(BOOL)isHidden;

@end
