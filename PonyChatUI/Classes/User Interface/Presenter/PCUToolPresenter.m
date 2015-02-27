//
//  PCUToolPresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-17.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUToolPresenter.h"
#import "PCUToolViewController.h"
#import "PCUChatInteractor.h"
#import "PCUWireframe.h"
#import "PCUPanelViewController.h"
#import "PCUChatViewController.h"
#import <PonyEmotionBoard/PEBApplication.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

//#define kPCUKeyboardIdentifier @"kPCUKeyboardIdentifier"
#define kPCUEndEditingNotification @"kPCUEndEditingNotification"

@interface PCUToolPresenter ()

@property (nonatomic, weak) PCUPanelViewController *panelViewController;

@property (nonatomic, assign) NSInteger currentKeyboardHeight;

@property (nonatomic, assign) BOOL isSystemKeyboardPresented;

@end

@implementation PCUToolPresenter

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillShowNotification:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleKeyboardWillHideNotification:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handlePCUEndEditingNotification:)
                                                     name:kPCUEndEditingNotification
                                                   object:nil];
    }
    return self;
}

- (void)updateView {
    [self configureReactiveCocoa];
}

- (void)configureReactiveCocoa {
    @weakify(self);
    [RACObserve(self, isSystemKeyboardPresented) subscribeNext:^(id x) {
        @strongify(self);
        if (self.isSystemKeyboardPresented) {
            [self dismissKeyboardsWithIdentifier:@"Panel"];
        }
        [self adjustLayouts];
    }];
    [RACObserve(self, panelViewController.isPresenting) subscribeNext:^(id x) {
        @strongify(self);
        if (self.panelViewController.isPresenting) {
            self.currentKeyboardHeight = CGRectGetHeight(self.panelViewController.view.bounds);
            [self dismissKeyboardsWithIdentifier:@"System"];
        }
        [self adjustLayouts];
    }];
}

- (void)dismissKeyboardsWithIdentifier:(NSString *)keyboardIdentifier {
    if ([keyboardIdentifier isEqualToString:@"System"]) {
        [self.userInterface.textField resignFirstResponder];
    }
    else if ([keyboardIdentifier isEqualToString:@"Panel"]) {
        [self.panelViewController setIsPresenting:NO];
    }
}

#pragma mark - ToolView Adjusting

- (void)adjustLayouts {
    if (!self.isSystemKeyboardPresented && !self.panelViewController.isPresenting) {
        //All Closed
        [(PCUChatViewController *)self.userInterface.parentViewController setBottomLayoutHeight:0.0];
    }
    else {
        [(PCUChatViewController *)self.userInterface.parentViewController setBottomLayoutHeight:self.currentKeyboardHeight];
    }
}

#pragma mark - UIKeyboardNotifications

- (void)handleKeyboardWillShowNotification:(NSNotification *)sender {
    CGRect keyboardFrame = [sender.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.currentKeyboardHeight = CGRectGetHeight(keyboardFrame);
    self.isSystemKeyboardPresented = YES;
}

- (void)handleKeyboardWillHideNotification:(NSNotification *)sender {
    self.isSystemKeyboardPresented = NO;
}

- (void)handlePCUEndEditingNotification:(NSNotification *)sender {
    [self dismissKeyboardsWithIdentifier:@"Panel"];
    [self dismissKeyboardsWithIdentifier:@"System"];
}

#pragma mark - PanelViewController

- (void)togglePanelView {
    [self.panelViewController setIsPresenting:!self.panelViewController.isPresenting];
}

- (PCUPanelViewController *)panelViewController {
    if (_panelViewController == nil) {
        PCUWireframe *wireframe = PCU[[PCUWireframe class]];
        _panelViewController = [wireframe presentPanelViewToChatViewController:(PCUChatViewController *)[[self userInterface] parentViewController]];
    }
    return _panelViewController;
}

#pragma mark - Send Message

- (void)sendTextMessage {
    [self.chatInteractor sendTextMessageWithString:self.userInterface.textField.text];
    self.userInterface.textField.text = @"";
}

@end
