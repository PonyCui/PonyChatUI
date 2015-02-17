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
#import "NSAttributedString+PCUAttributedString.h"
#import "UILabel+PCUAttributedStringLinkResponder.h"

@interface PCUSystemNodeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *textButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightConstraint;

@end

@implementation PCUSystemNodeViewController

- (CGFloat)heightConstraintDefaultValue {
    return 40.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textButton.titleLabel.userInteractionEnabled = YES;
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
    NSAttributedString *attributedString = [PCU[[PCUAttributedStringManager class]]
                                            systemNodeAttrbutedStringWithString:string];
    attributedString = [attributedString pcu_linkAttributedString];
    [self.textButton setAttributedTitle:attributedString forState:UIControlStateNormal];
    [self performSelector:@selector(adjustButtonHeight) withObject:nil afterDelay:0.001];
    [self performSelector:@selector(configureLinkResponder) withObject:nil afterDelay:0.001];
}

- (void)adjustButtonHeight {
    self.buttonHeightConstraint.constant = CGRectGetHeight(self.textButton.titleLabel.bounds) + 10.0;
    [self performSelector:@selector(adjustHeight) withObject:nil afterDelay:0.001];
}

- (void)adjustHeight {
    if (self.buttonHeightConstraint.constant + 12.0 != self.heightConstraint.constant) {
        self.heightConstraint.constant = self.buttonHeightConstraint.constant + 12.0;
        [self.delegate nodeViewHeightDidChange];
    }
}

- (void)configureLinkResponder {
    [self.textButton.titleLabel pcu_configureAttributedStringLinkResponder];
}

@end
