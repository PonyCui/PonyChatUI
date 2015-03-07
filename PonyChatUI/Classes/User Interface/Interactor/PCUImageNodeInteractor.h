//
//  PCUImageNodeInteractor.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-7.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeInteractor.h"

typedef NS_ENUM(NSInteger, PCUImageNodeThumbImageStatus) {
    PCUImageNodeThumbImageStatusLoading,
    PCUImageNodeThumbImageStatusLoaded,
    PCUImageNodeThumbImageStatusFailed
};

@interface PCUImageNodeInteractor : PCUNodeInteractor

@property (nonatomic, assign) PCUImageNodeThumbImageStatus thumbStatus;

@property (nonatomic, strong) UIImage *thumbImage;

/**
 *  @brief 发送者昵称
 */
@property (nonatomic, copy) NSString *senderName;

/**
 *  @brief 发送者头像缩略图
 */
@property (nonatomic, copy) UIImage  *senderThumbImage;

@end
