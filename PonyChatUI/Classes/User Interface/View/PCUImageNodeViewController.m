//
//  PCUImageNodeViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-7.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUImageNodeViewController.h"

@interface PCUImageNodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewWidthConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thumbImageViewHeightConstraint;

@end

@implementation PCUImageNodeViewController

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

- (void)setThumbImage:(UIImage *)thumbImage {
    self.thumbImageView.image = thumbImage;
    self.thumbImageViewWidthConstraint.constant = self.thumbImageView.image.size.width;
    self.thumbImageViewHeightConstraint.constant = self.thumbImageView.image.size.height;
    self.heightConstraint.constant = self.thumbImageViewHeightConstraint.constant + 28.0;
}

- (void)setThumbImageViewIsLoading:(BOOL)isLoading {
    if (isLoading) {
        self.thumbImageView.image = [UIImage imageNamed:@"sharemore_pic"];
    }
}

@end
