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
#import "PCUApplication.h"
#import "PCUPanelCollectionViewLayout.h"

@interface PCUPanelViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, assign) BOOL wasEditing;

@property (nonatomic, weak) NSLayoutConstraint *bottomSpaceConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet PCUPanelCollectionViewLayout *collectionViewLayout;

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
    [self configurePCUEndEditingNotifications];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionViewLayout configureInsetWithBounds:self.view.bounds];
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

#pragma mark - Observe PCUApplication endEditing Notification

- (void)configurePCUEndEditingNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEndEditingNotification)
                                                 name:kPCUEndEditingNotification
                                               object:nil];
}

- (void)handleEndEditingNotification {
    if (self.isPresenting) {
        self.wasEditing = NO;
        self.isPresenting = NO;
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

#pragma mark - UICollectionViewDataSource

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.collectionViewLayout configureInsetWithBounds:self.view.bounds];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1001];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderWidth = 1.0;
        imageView.layer.cornerRadius = 6.0;
        imageView.layer.borderColor = [UIColor colorWithRed:202.0/255.0
                                                      green:204.0/255.0
                                                       blue:206.0/255.0
                                                      alpha:1.0].CGColor;
    }
    {
        UILabel *label = (UILabel *)[cell viewWithTag:1002];
    }
    return cell;
}

@end
