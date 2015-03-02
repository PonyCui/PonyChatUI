//
//  PCUVoiceNodeViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/3/2.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUVoiceNodeViewController.h"

@interface PCUVoiceNodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *sendingRetryButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *voiceNodeBackgroundWidthConstraint;

@end

@implementation PCUVoiceNodeViewController

- (CGFloat)heightConstraintDefaultValue {
    return 60.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.eventHandler updateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Render

- (void)setSenderThumbImageViewWithImage:(UIImage *)image {
    self.iconImageView.image = image;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
