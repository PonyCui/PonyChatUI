//
//  PCUImageNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-7.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeInteractor.h"

typedef NS_ENUM(NSInteger, PCUImageNodeImageStatus) {
    PCUImageNodeImageStatusLoading,
    PCUImageNodeImageStatusLoaded,
    PCUImageNodeImageStatusFailed
};

@interface PCUImageNodeInteractor : PCUNodeInteractor

@property (nonatomic, assign) PCUImageNodeImageStatus thumbStatus;

@property (nonatomic, strong) UIImage *thumbImage;

@property (nonatomic, assign) PCUImageNodeImageStatus originalStatus;

@property (nonatomic, strong) UIImage *originalImage;

- (void)sendOriginalImageAsyncRequest;

@end
