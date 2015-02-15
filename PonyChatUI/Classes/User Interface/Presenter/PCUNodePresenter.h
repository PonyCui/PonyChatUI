//
//  PCUNodePresenter.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUNodeInteractor, PCUNodeViewController;

@interface PCUNodePresenter : NSObject

@property (nonatomic, weak) PCUNodeViewController *userInterface;

@property (nonatomic, strong) PCUNodeInteractor *nodeInteractor;

+ (PCUNodePresenter *)nodePresenterWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor;

- (void)updateView;

- (void)removeViewFromSuperView;

@end
