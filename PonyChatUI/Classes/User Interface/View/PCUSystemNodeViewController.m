//
//  PCUSystemNodeViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/16.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUSystemNodeViewController.h"
#import "PCUApplication.h"
#import "PCUAttributedStringManager.h"

@interface PCUSystemNodeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *textButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

@end

@implementation PCUSystemNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textButton.titleLabel.numberOfLines = 0;
    self.textButton.layer.cornerRadius = 6.0f;
    [self.eventHandler updateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextWithString:(NSString *)string {
    [self.textButton setTitle:string forState:UIControlStateNormal];
    [self performSelector:@selector(adjustButtonHeight) withObject:nil afterDelay:0.001];
}

- (void)adjustButtonHeight {
    self.buttonHeightConstraint.constant = CGRectGetHeight(self.textButton.titleLabel.bounds) + 10.0;
    [self performSelector:@selector(adjustHeight) withObject:nil afterDelay:0.001];
}

- (void)adjustHeight {
    self.heightConstraint.constant = self.buttonHeightConstraint.constant + 8.0;
    [self.delegate nodeViewHeightDidChange];
}

@end
