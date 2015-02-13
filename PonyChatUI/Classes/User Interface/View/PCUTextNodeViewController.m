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

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelBottomSpace;

@end

@implementation PCUTextNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setTextLabelText:@"我只是测试一下换行到底会怎么样啦我只是测试一下换行到底会怎么样啦我只是测试一下换行到底会怎么样啦我只是测试一下换行到底会怎么样啦"];
    });
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setTextLabelText:(NSString *)text {
    self.textLabel.attributedText = [PCU[[PCUAttributedStringManager class]] attributedStringWithString:text];
    [self adjustLabelSpace];
    [self performSelector:@selector(adjustHeight)
               withObject:nil
               afterDelay:0.001];
}

#pragma mark - Setter

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    _heightConstraint = heightConstraint;
    [self adjustLabelSpace];
    [self performSelector:@selector(adjustHeight)
               withObject:nil
               afterDelay:0.001];
}

#pragma mark - Layouts

- (void)adjustLabelSpace {
    NSAttributedString *attributedString = self.textLabel.attributedText;
    CGSize size = [attributedString boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.view.bounds), CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    if (size.width > CGRectGetWidth(self.view.bounds) * 0.618) {
        self.textLabelTrailingSpace.constant = CGRectGetWidth(self.view.bounds) - 76.0 - size.width * 0.618;//双行
        self.textLabelTopSpace.constant = -7.0;
        self.textLabelBottomSpace.constant = 22.0;
    }
    else if (size.height > 30.0) {
        self.textLabelTopSpace.constant = -7.0;
        self.textLabelBottomSpace.constant = 22.0;
        //多行
    }
    else {
        self.textLabelTrailingSpace.constant = 8.0;//单行
        self.textLabelTopSpace.constant = 0.0;
        self.textLabelBottomSpace.constant = 16.0;
    }
}

- (void)adjustHeight {
    self.heightConstraint.constant = CGRectGetHeight(self.textLabelBackgroundImageView.bounds) + 6.0;
    [self.delegate textNodeViewHeightDidChange];
}

@end
