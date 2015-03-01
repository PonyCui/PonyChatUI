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
#import "PCUDefines.h"

typedef NS_ENUM(NSUInteger, PCUKeyboardType) {
    PCUKeyboardTypeSystem,
    PCUKeyboardTypePanel,
    PCUKeyboardTypeEmotion
};

@interface PCUToolPresenter ()

@property (nonatomic, weak) PCUPanelViewController *panelViewController;

@property (nonatomic, weak) PEBKeyboardViewController *emotionViewController;

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
            [self dismissKeyboardWithType:PCUKeyboardTypePanel];
            [self dismissKeyboardWithType:PCUKeyboardTypeEmotion];
        }
        [self adjustLayouts];
    }];
    [RACObserve(self, panelViewController.isPresenting) subscribeNext:^(id x) {
        @strongify(self);
        if (self.panelViewController.isPresenting) {
            self.currentKeyboardHeight = CGRectGetHeight(self.panelViewController.view.bounds);
            [self dismissKeyboardWithType:PCUKeyboardTypeSystem];
            [self dismissKeyboardWithType:PCUKeyboardTypeEmotion];
        }
        [self adjustLayouts];
    }];
    [RACObserve(self, emotionViewController.isPresenting) subscribeNext:^(id x) {
        @strongify(self);
        if (self.emotionViewController.isPresenting) {
            self.currentKeyboardHeight = CGRectGetHeight(self.emotionViewController.view.bounds);
            [self dismissKeyboardWithType:PCUKeyboardTypePanel];
            [self dismissKeyboardWithType:PCUKeyboardTypeSystem];
        }
        [self.userInterface setEmotionCoveredKeyboardButtonShow:self.emotionViewController.isPresenting];
        [self adjustLayouts];
    }];
    [RACObserve(self, panelViewController.view.bounds) subscribeNext:^(id x) {
        @strongify(self);
        if (self.panelViewController.isPresenting) {
            self.currentKeyboardHeight = CGRectGetHeight(self.panelViewController.view.bounds);
        }
        [self adjustLayouts];
    }];
}

#pragma mark - Dismiss Keyboard

- (void)dismissAllKeyboards {
    [self dismissKeyboardWithType:PCUKeyboardTypeSystem];
    [self dismissKeyboardWithType:PCUKeyboardTypePanel];
    [self dismissKeyboardWithType:PCUKeyboardTypeEmotion];
}

- (void)dismissKeyboardWithType:(PCUKeyboardType)type {
    if (type == PCUKeyboardTypeSystem && self.isSystemKeyboardPresented) {
        [self.userInterface.textField resignFirstResponder];
    }
    else if (type == PCUKeyboardTypePanel && self.panelViewController.isPresenting) {
        [self.panelViewController setIsPresenting:NO];
    }
    else if (type == PCUKeyboardTypeEmotion && self.emotionViewController.isPresenting) {
        [self.emotionViewController setIsPresenting:NO];
    }
}

#pragma mark - ToolView Adjusting

- (void)adjustLayouts {
    if (!self.isSystemKeyboardPresented && !self.panelViewController.isPresenting && !self.emotionViewController.isPresenting) {
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
    [self dismissAllKeyboards];
}

#pragma mark - PanelViewController

- (void)togglePanelView {
    self.panelViewController.isPresenting = !self.panelViewController.isPresenting;
}

- (PCUPanelViewController *)panelViewController {
    if (_panelViewController == nil) {
        PCUWireframe *wireframe = PCU[[PCUWireframe class]];
        _panelViewController = [wireframe presentPanelViewToChatViewController:(PCUChatViewController *)[[self userInterface] parentViewController]];
    }
    return _panelViewController;
}

#pragma mark - EmotionViewController

- (void)toggleEmotionView {
    self.emotionViewController.isPresenting = !self.emotionViewController.isPresenting;
}

- (PEBKeyboardViewController *)emotionViewController {
    if (_emotionViewController == nil) {
        _emotionViewController = [[PEBApplication sharedInstance]
                                  addKeyboardViewControllerToViewController:self.userInterface.parentViewController
                                                              withTextField:(id)self.userInterface.textField];
    }
    return _emotionViewController;
}

#pragma mark - Send Message

- (void)sendTextMessage {
    [self.chatInteractor sendTextMessageWithString:self.userInterface.textField.text];
    self.userInterface.textField.text = @"";
}

@end
