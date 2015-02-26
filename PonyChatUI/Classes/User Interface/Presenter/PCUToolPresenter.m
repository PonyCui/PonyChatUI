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
#import <PonyEmotionBoard/PEBApplication.h>

@interface PCUToolPresenter ()

@property (nonatomic, weak) PCUPanelViewController *panelViewController;

@end

@implementation PCUToolPresenter

- (void)sendTextMessage {
    [self.chatInteractor sendTextMessageWithString:self.userInterface.textField.text];
    self.userInterface.textField.text = @"";
}

- (void)togglePanelView {
    if ([[PEBApplication sharedInstance] isEditingWithParentViewController:self.userInterface.parentViewController]) {
        [[PEBApplication sharedInstance] setEditing:NO
                               parentViewController:self.userInterface.parentViewController
                                 textInputContainer:nil];
        [self performSelector:@selector(togglePanelView) withObject:nil afterDelay:0.50];
        return;
    }
    if (self.panelViewController == nil) {
        PCUWireframe *wireframe = PCU[[PCUWireframe class]];
        self.panelViewController = [wireframe presentPanelViewToChatViewController:(PCUChatViewController *)[[self userInterface] parentViewController]];
    }
    self.panelViewController.isPresenting = !self.panelViewController.isPresenting;
}

- (void)toggleEmotionView {
    if (self.panelViewController.isPresenting) {
        self.panelViewController.isPresenting = NO;
        [self performSelector:@selector(toggleEmotionView) withObject:nil afterDelay:0.50];
        return;
    }
    BOOL isEditing = [[PEBApplication sharedInstance]
                      isEditingWithParentViewController:self.userInterface.parentViewController];
    [[PEBApplication sharedInstance] setEditing:!isEditing
                           parentViewController:self.userInterface.parentViewController
                             textInputContainer:self.userInterface.textField];
}

@end
