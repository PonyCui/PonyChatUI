//
//  PCUPanelViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-17.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelViewController.h"
#import "PCUChatViewController.h"
#import "PCUToolViewController.h"

@interface PCUPanelViewController ()

@property (nonatomic, assign) BOOL wasEditing;

@property (nonatomic, weak) NSLayoutConstraint *bottomSpaceConstraint;

@end

@implementation PCUPanelViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isPresenting = NO;
    [self configureKeyboardNotifications];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Observe Real Keyboard

- (void)configureKeyboardNotifications {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleRealKeyboardWillShowNotificaiton:)
     name:UIKeyboardWillShowNotification
     object:nil];
}

- (void)handleRealKeyboardWillShowNotificaiton:(NSNotification *)sender {
    if (sender.userInfo[UIKeyboardFrameBeginUserInfoKey] != nil) {
        //It's real
        _isPresenting = NO;
        self.bottomSpaceConstraint.constant = -216.0;
        [self.view layoutIfNeeded];
    }
}

#pragma mark - toggle

- (void)setIsPresenting:(BOOL)isPresenting {
    _isPresenting = isPresenting;
    isPresenting ?
    [self performSelector:@selector(presentPanel) withObject:nil afterDelay:0.001] :
    [self performSelector:@selector(dismissPanel) withObject:nil afterDelay:0.001];
}

- (void)presentPanel {
    PCUChatViewController *chatViewController = (PCUChatViewController *)[self parentViewController];
    if (chatViewController.toolViewController.textField.editing) {
        self.wasEditing = YES;
        [chatViewController.toolViewController.textField endEditing:YES];
        [self performSelector:@selector(presentPanel) withObject:nil afterDelay:0.50];
//        self.bottomSpaceConstraint.constant = 0.0;
//        [self.view layoutIfNeeded];
    }
    else {
        self.bottomSpaceConstraint.constant = 0.0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:UIKeyboardWillShowNotification
         object:nil
         userInfo:@{
                    UIKeyboardFrameEndUserInfoKey :
                        [NSValue valueWithCGRect:CGRectMake(0,
                                                            0,
                                                            CGRectGetWidth(self.view.bounds),
                                                            CGRectGetHeight(self.view.bounds))]
                    }];
    }
}

- (void)dismissPanel {
    if (self.wasEditing) {
        self.wasEditing = NO;
        PCUChatViewController *chatViewController = (PCUChatViewController *)[self parentViewController];
        [chatViewController.toolViewController.textField becomeFirstResponder];
        self.bottomSpaceConstraint.constant = -216.0;
        [self.view layoutIfNeeded];
    }
    else {
        self.bottomSpaceConstraint.constant = -216.0;
        [UIView animateWithDuration:0.25 animations:^{
            [self.view layoutIfNeeded];
        }];
        [[NSNotificationCenter defaultCenter]
         postNotificationName:UIKeyboardWillHideNotification
         object:nil
         userInfo:@{
                    UIKeyboardFrameEndUserInfoKey :
                        [NSValue valueWithCGRect:CGRectMake(0,
                                                            0,
                                                            CGRectGetWidth(self.view.bounds),
                                                            CGRectGetHeight(self.view.bounds))]
                    }];
    }
}

#pragma mark - Layouts

- (void)configureViewLayouts {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{
                            @"wrapView": self.view
                            };
    {
        NSArray *constraints = [NSLayoutConstraint
                               constraintsWithVisualFormat:@"|-0-[wrapView]-0-|"
                               options:kNilOptions
                               metrics:nil
                               views:views];
        [[self.view superview] addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:[wrapView(216)]-(-216)-|"
                                options:kNilOptions
                                metrics:nil
                                views:views];
        self.bottomSpaceConstraint = [constraints lastObject];
        [[self.view superview] addConstraints:constraints];
    }
}

@end
