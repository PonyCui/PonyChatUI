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
#import "NSAttributedString+PCUAttributedString.h"
#import "UILabel+PCUAttributedStringLinkResponder.h"

@interface PCUTextNodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIImageView *textLabelBackgroundImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTrailingSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelBottomSpace;

@end

@implementation PCUTextNodeViewController

- (CGFloat)heightConstraintDefaultValue {
    return 60.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self eventHandler] updateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Render

- (void)setTextLabelTextWithString:(NSString *)string {
    NSAttributedString *attributedString = [PCU[[PCUAttributedStringManager class]] attributedStringWithString:string];
    attributedString = [attributedString pcu_linkAttributedString];
    self.textLabel.attributedText = attributedString;
    [self adjustLabelSpace];
    [self adjustHeight];
    [self.textLabel performSelector:@selector(pcu_configureAttributedStringLinkResponder)
                         withObject:nil
                         afterDelay:0.001];
}

- (void)setSenderNickLabelTextWithString:(NSString *)string {
    
}

- (void)setSenderThumbImageViewWithImage:(UIImage *)image {
    self.iconImageView.image = image;
}

#pragma mark - Layouts

- (void)setHeightConstraint:(NSLayoutConstraint *)heightConstraint {
    super.heightConstraint = heightConstraint;
    [self adjustLabelSpace];
    [self performSelector:@selector(adjustHeight) withObject:nil afterDelay:0.001];
}

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
        self.textLabelTopSpace.constant = -3.0;
        self.textLabelBottomSpace.constant = 16.0;
    }
}

- (void)adjustHeight {
    if (CGRectGetHeight(self.textLabelBackgroundImageView.bounds) + 6.0 != self.heightConstraint.constant) {
        self.heightConstraint.constant = CGRectGetHeight(self.textLabelBackgroundImageView.bounds) + 6.0;
        [self.delegate nodeViewHeightDidChange];
    }
}

@end
