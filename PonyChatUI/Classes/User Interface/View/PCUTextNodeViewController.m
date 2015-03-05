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
#import <PonyEmotionBoard/PEBApplication.h>

@interface PCUTextNodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UIImageView *textLabelBackgroundImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabeHorizonSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTopSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelBottomSpace;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *sendingRetryButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelWidthConstraint;

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
    if (string == nil) {
        return;
    }
    NSAttributedString *attributedString = [PCU[[PCUAttributedStringManager class]] attributedStringWithString:string];
    attributedString = [attributedString pcu_linkAttributedString];
    attributedString = [[PEBApplication sharedInstance] emotionAttributedStringWithAttributedString:attributedString];
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
        self.textLabeHorizonSpace.constant = CGRectGetWidth(self.view.bounds) - 76.0 - size.width * 0.618;//双行
        self.textLabelTopSpace.constant = -10.0;
        self.textLabelBottomSpace.constant = 22.0;
    }
    else if (size.height > 30.0) {
        self.textLabelTopSpace.constant = -10.0;
        self.textLabelBottomSpace.constant = 22.0;
        //多行
    }
    else if (![attributedString.string stringByReplacingOccurrencesOfString:@"\U0000fffc"
                                                                 withString:@""].length) {
        //纯表情，单行文字
        self.textLabeHorizonSpace.constant = 8.0;//单行
        self.textLabelTopSpace.constant = -6.0;
        self.textLabelBottomSpace.constant = 16.0;
    }
    else {
        //单行文字
        if ([attributedString.string rangeOfString:@"\U0000fffc"].location != NSNotFound) {
            //文字表情混排
            self.textLabeHorizonSpace.constant = 8.0;//单行
            self.textLabelTopSpace.constant = -4.0;
            self.textLabelBottomSpace.constant = 16.0;
        }
        else {
            //纯文字
            self.textLabeHorizonSpace.constant = 8.0;
            self.textLabelTopSpace.constant = -3.0;
            self.textLabelBottomSpace.constant = 16.0;
        }
    }
    if (size.width < 32.0) {
        self.textLabelWidthConstraint.constant = size.width + 2.0;
    }
}

- (void)adjustHeight {
    if (CGRectGetHeight(self.textLabelBackgroundImageView.bounds) + 6.0 != self.heightConstraint.constant) {
        self.heightConstraint.constant = CGRectGetHeight(self.textLabelBackgroundImageView.bounds) + 6.0;
        [self.delegate nodeViewHeightDidChange];
    }
}

@end
