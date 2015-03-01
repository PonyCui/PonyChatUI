//
//  PCUTalkingHUDViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCUTalkingHUDViewController : UIViewController

/**
 *  设置录音声音大小
 *
 *  @param aValue 1~8
 */
- (void)setVoiceValue:(NSUInteger)aValue;

- (void)configureViewLayouts;

@end
