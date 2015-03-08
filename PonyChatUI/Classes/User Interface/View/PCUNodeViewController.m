//
//  PCUNodeViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodeViewController.h"
#import "PCUNodePresenter.h"
#import "PCUNodeInteractor.h"
#import "PCUTextNodeInteractor.h"
#import "PCUSystemNodeInteractor.h"
#import "PCUVoiceNodeInteractor.h"
#import "PCUImageNodeInteractor.h"

@interface PCUNodeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *sendingIndicatorView;

@property (weak, nonatomic) IBOutlet UIButton *sendingRetryButton;

@end

@implementation PCUNodeViewController

+ (PCUNodeViewController *)nodeViewControllerWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUNodeViewController *nodeViewController;
    NSString *viewControllerIdentifier;
    if ([nodeInteractor isKindOfClass:[PCUTextNodeInteractor class]]) {
        if (nodeInteractor.isOwner) {
            viewControllerIdentifier = @"PCUTextNodeViewControllerSender";
        }
        else {
            viewControllerIdentifier = @"PCUTextNodeViewControllerReceiver";
        }
    }
    else if ([nodeInteractor isKindOfClass:[PCUSystemNodeInteractor class]]) {
        viewControllerIdentifier = @"PCUSystemNodeViewController";
    }
    else if ([nodeInteractor isKindOfClass:[PCUVoiceNodeInteractor class]]) {
        if (nodeInteractor.isOwner) {
            viewControllerIdentifier = @"PCUVoiceNodeViewControllerSender";
        }
        else {
            viewControllerIdentifier = @"PCUVoiceNodeViewControllerReceiver";
        }
    }
    else if ([nodeInteractor isKindOfClass:[PCUImageNodeInteractor class]]) {
        if (nodeInteractor.isOwner) {
            viewControllerIdentifier = @"PCUImageNodeViewControllerSender";
        }
        else {
            viewControllerIdentifier = @"PCUImageNodeViewControllerReceiver";
        }
    }
    if (viewControllerIdentifier == nil) {
        return nil;
    }
    else {
        nodeViewController = [storyBoard instantiateViewControllerWithIdentifier:viewControllerIdentifier];
        nodeViewController.eventHandler = [PCUNodePresenter nodePresenterWithNodeInteractor:nodeInteractor];
        nodeViewController.eventHandler.userInterface = nodeViewController;
        return nodeViewController;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1.0];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateWidthConstraintWithOrientation:toInterfaceOrientation];
}

- (void)updateWidthConstraintWithOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft ||
        orientation == UIInterfaceOrientationLandscapeRight) {
        self.widthConstraint.constant = MAX(CGRectGetWidth([UIScreen mainScreen].bounds),
                                            CGRectGetHeight([UIScreen mainScreen].bounds));
    }
    else {
        self.widthConstraint.constant = MIN(CGRectGetWidth([UIScreen mainScreen].bounds),
                                            CGRectGetHeight([UIScreen mainScreen].bounds));
    }
}

- (void)configureLayouts {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    {
        NSDictionary *views = @{@"nodeView": self.view, @"superView": [self.view superview]};
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[nodeView(0)]-0-|"
                                                                        options:kNilOptions
                                                                        metrics:nil
                                                                          views:views];
        self.widthConstraint = constraints[1];
        [self updateWidthConstraintWithOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
        [[self.view superview] addConstraints:constraints];
    }
    {
        NSLayoutConstraint *constaint = [NSLayoutConstraint constraintWithItem:self.view
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeNotAnAttribute
                                                                    multiplier:1.0
                                                                      constant:self.heightConstraintDefaultValue];
        self.heightConstraint = constaint;
        [[self.view superview] addConstraint:self.heightConstraint];
    }
    [self.view layoutIfNeeded];
}

- (void)sendingIndicatorViewStartAnimating {
    [[self sendingIndicatorView] startAnimating];
}

- (void)sendingIndicatorViewStopAnimating {
    [[self sendingIndicatorView] stopAnimating];
}

- (void)setSendingRetryButtonHidden:(BOOL)isHidden {
    [self sendingRetryButton].hidden = isHidden;
}

- (void)setSenderNickLabelTextWithString:(NSString *)string {
    
}

- (void)setSenderThumbImageViewWithImage:(UIImage *)image {
    self.iconImageView.image = image;
}

#pragma mark - Retry

- (IBAction)handleRetryButtonTapped:(id)sender {
    [self.eventHandler retrySendMessage];
}

@end
