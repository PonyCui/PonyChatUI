//
//  PCUToolViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUToolViewController.h"
#import "PCUToolPresenter.h"
#import "PCUChatViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PCUToolViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *emotionButton;

@property (weak, nonatomic) IBOutlet UIButton *emotionCoveredKeyboardButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;

@end

@implementation PCUToolViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureTextView];
    [self.eventHandler updateView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextView

- (void)configureTextView {
    [self.textField.layer setCornerRadius:6.0f];
    [self.textField.layer setBorderWidth:0.5f];
    [self.textField.layer setBorderColor:[UIColor colorWithRed:171.0/255.0
                                                         green:173.0/255.0
                                                          blue:178.0/255.0
                                                         alpha:0.5].CGColor];
    [self.textField setTextContainerInset:UIEdgeInsetsMake(5, 2, 5, 2)];
    @weakify(self);
    [RACObserve(self.textField, contentSize) subscribeNext:^(id x) {
        @strongify(self);
        [UIView animateWithDuration:0.05 delay:0.15 options:UIViewAnimationOptionCurveLinear animations:^{
            self.textViewHeightConstraint.constant = self.textField.contentSize.height;
            [self adjustToolViewHeight];
            [self.view.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }];
}

- (void)adjustToolViewHeight {
    [(PCUChatViewController *)self.parentViewController
     setToolViewLayoutHeight:self.textViewHeightConstraint.constant+16.0];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length) {
            [self.eventHandler sendTextMessage];
        }
        return NO;
    }
    return YES;
}

#pragma mark - Events

- (IBAction)handlePanelButtonTapped:(UIButton *)sender {
    [self.eventHandler togglePanelView];
}

- (IBAction)handleEmotionButtonTapped:(UIButton *)sender {
    [self.eventHandler toggleEmotionView];
}

- (IBAction)handleKeyboardButtonTapped:(UIButton *)sender {
    [self.textField becomeFirstResponder];
}

- (void)setEmotionCoveredKeyboardButtonShow:(BOOL)isShow {
    if (isShow) {
        self.emotionCoveredKeyboardButton.hidden = NO;
        self.emotionButton.hidden = YES;
    }
    else {
        self.emotionCoveredKeyboardButton.hidden = YES;
        self.emotionButton.hidden = NO;
    }
}

@end
