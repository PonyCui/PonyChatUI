//
//  PCUTalkingViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUTalkingViewController.h"
#import "PCUToolViewController.h"
#import "PCUToolPresenter.h"
#import "PCUTalkingPresenter.h"
#import "PCUApplication.h"
#import "PCUWireframe.h"
#import "PCUTalkingHUDViewController.h"
#import "PCUTalkingCancelHUDViewController.h"
#import "PCUDefines.h"

@interface PCUTalkingViewController ()

@property (weak, nonatomic) IBOutlet UIButton *talkingButton;

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGuestureRecognizer;

@end

@implementation PCUTalkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eventHandler = [[PCUTalkingPresenter alloc] init];
    self.eventHandler.userInterface = self;
    [self configureEvents];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didMoveToParentViewController:(UIViewController *)parent {
    if ([parent isKindOfClass:[PCUToolViewController class]]) {
        self.eventHandler.chatInteractor = [(PCUToolViewController *)parent eventHandler].chatInteractor;
    }
}

#pragma mark - Styles

- (void)setTalkingButtonLongPressedStyle {
    [self.talkingButton setBackgroundColor:[UIColor colorWithRed:198.0/255.0
                                                           green:199.0/255.0
                                                            blue:202.0/255.0
                                                           alpha:1.0]];
    [self.talkingButton setSelected:YES];
}

- (void)setTalkingButtonNormalStyle {
    [self.talkingButton setBackgroundColor:[UIColor clearColor]];
    [self.talkingButton setSelected:NO];
}

#pragma mark - Events

- (void)configureEvents {
    self.longPressGuestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                        initWithTarget:self
                                        action:@selector(handleLongPress:)];
    self.longPressGuestureRecognizer.minimumPressDuration = 0.15;
    self.longPressGuestureRecognizer.numberOfTouchesRequired = 1;
    [self.talkingButton addGestureRecognizer:self.longPressGuestureRecognizer];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [PCU[@protocol(PCUWireframe)] presentTalkingHUDToViewController:self];
        [self setTalkingButtonLongPressedStyle];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPCUPreventScreenRotationNotification
                                                            object:nil];
        [self.eventHandler performSelector:@selector(startRecording) withObject:nil afterDelay:0.001];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint figureLocation = [sender locationInView:[[[UIApplication sharedApplication] delegate] window]];
        if ([self shouldCancelRecordWithFigureLocation:figureLocation]) {
            [PCU[@protocol(PCUWireframe)] presentCancelHUDToViewController:self];
        }
        else {
            [PCU[@protocol(PCUWireframe)] presentTalkingHUDToViewController:self];
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint figureLocation = [sender locationInView:[[[UIApplication sharedApplication] delegate] window]];
        if ([self shouldCancelRecordWithFigureLocation:figureLocation]) {
            [self.eventHandler performSelector:@selector(cancelRecord) withObject:nil afterDelay:0.001];
        }
        else {
            [self.eventHandler performSelector:@selector(endRecording) withObject:nil afterDelay:0.001];
        }
        [self setTalkingButtonNormalStyle];
        [self.talkingHUDViewController.view removeFromSuperview];
        [self.cancelHUDViewController.view removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPCUAllowScreenRotationNotification
                                                            object:nil];
    }
}

- (BOOL)shouldCancelRecordWithFigureLocation:(CGPoint)location {
    if (location.y < CGRectGetHeight([[[[UIApplication sharedApplication] delegate] window] bounds]) - 108.0) {
        return YES;
    }
    else {
        return NO;
    }
}


@end
