//
//  PCUToolViewController.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PCUToolPresenter;

@interface PCUToolViewController : UIViewController

@property (nonatomic, strong) PCUToolPresenter *eventHandler;

#pragma mark - IBOutlet

@property (weak, nonatomic) IBOutlet UITextField *textField;

@end
