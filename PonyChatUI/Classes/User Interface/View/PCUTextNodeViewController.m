//
//  PCUTextNodeViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/12.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUTextNodeViewController.h"
#import "PCUApplication.h"
#import "PCUAttributedStringManager.h"

@interface PCUTextNodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIImageView *textLabelBackgroundImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTrailingSpace;

@end

@implementation PCUTextNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setTextLabelText:@"我只是测试一下换行到底会怎么样啦"];
    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextLabelText:(NSString *)text {
    self.textLabel.attributedText = [PCU[[PCUAttributedStringManager class]] attributedStringWithString:text];
    [self adjustTextLabelTrailingSpace];
    [self performSelector:@selector(adjustLayout) withObject:nil afterDelay:0.001];
}

- (void)adjustTextLabelTrailingSpace {
    NSAttributedString *attributedString = self.textLabel.attributedText;
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if (size.width > CGRectGetWidth(self.view.frame) * 0.618) {
        self.textLabelTrailingSpace.constant = CGRectGetWidth(self.view.frame) - 76.0 - size.width * 0.618;
    }
    else {
        self.textLabelTrailingSpace.constant = 8.0;
    }
}

- (void)adjustLayout {
    self.heightConstraint.constant = CGRectGetHeight(self.textLabelBackgroundImageView.frame) + 6.0;
}

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    _heightConstraint = heightConstraint;
    [self adjustTextLabelTrailingSpace];
    [self performSelector:@selector(adjustLayout) withObject:nil afterDelay:0.001];
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
