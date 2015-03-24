//
//  PCUTalkingHUDViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-1.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUTalkingHUDViewController.h"

@interface PCUTalkingHUDViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *voiceValueImageView;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitingActivityIndicator;

@end

@implementation PCUTalkingHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 8.0f;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setWaiting:(BOOL)isWaiting {
    if (isWaiting) {
        [self.waitingActivityIndicator startAnimating];
        self.voiceValueImageView.hidden = YES;
    }
    else {
        [self.waitingActivityIndicator stopAnimating];
        self.voiceValueImageView.hidden = NO;
    }
}

- (void)setVoiceValue:(NSUInteger)aValue {
    NSString *imageFile = [NSString stringWithFormat:@"RecordingSignal00%lu", aValue];
    self.voiceValueImageView.image = [UIImage imageNamed:imageFile];
}

- (void)configureViewLayouts {
    if (self.view.superview == nil) {
        return;
    }
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"view": self.view};
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"[view(==150)]"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views];
        [[self.view superview] addConstraints:constraints];
    }
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(==150)]"
                                                                       options:kNilOptions
                                                                       metrics:nil
                                                                         views:views];
        [[self.view superview] addConstraints:constraints];
    }
    {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view.superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
        [[self.view superview] addConstraint:constraint];
    }
    {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view.superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
        [[self.view superview] addConstraint:constraint];
    }
}

@end
