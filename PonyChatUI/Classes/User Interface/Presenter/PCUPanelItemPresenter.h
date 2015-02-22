//
//  PCUPanelItemPresenter.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-19.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PCUPanelCollectionViewCell, PCUPanelItemInteractor;

@interface PCUPanelItemPresenter : NSObject

@property (nonatomic, weak) PCUPanelCollectionViewCell *userInterface;

@property (nonatomic, strong) PCUPanelItemInteractor *itemInteractor;

- (void)updateView;

- (void)sendAction;

@end
