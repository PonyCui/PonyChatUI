//
//  PCUToolViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUToolViewController.h"
#import "PCUToolPresenter.h"

@interface PCUToolViewController ()<UITextFieldDelegate>

@end

@implementation PCUToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.eventHandler updateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length) {
        [self.eventHandler sendTextMessage];
    }
    return YES;
}

- (IBAction)handlePanelButtonTapped:(UIButton *)sender {
    [self.eventHandler togglePanelView];
}

- (IBAction)handleEmotionButtonTapped:(UIButton *)sender {
    [self.eventHandler toggleEmotionView];
}

@end
