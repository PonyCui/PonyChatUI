//
//  PCULinkNodeViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCULinkNodeViewController.h"
#import "PCULinkNodePresenter.h"

@interface PCULinkNodeViewController ()

@property (nonatomic, strong) PCULinkNodePresenter *eventHandler;

@end

@implementation PCULinkNodeViewController

- (CGFloat)heightConstraintDefaultValue {
    return 120.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)handleLinkTapped:(UITapGestureRecognizer *)sender {
    [self.eventHandler openLink];
}


@end
