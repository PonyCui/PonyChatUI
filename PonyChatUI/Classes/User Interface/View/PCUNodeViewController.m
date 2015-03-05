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

@interface PCUNodeViewController ()

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
        viewControllerIdentifier = @"PCUVoiceNodeViewController";
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

- (void)configureLayouts {
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    {
        NSDictionary *views = @{@"nodeView": self.view, @"superView": [self.view superview]};
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[nodeView(0)]-0-|"
                                                                        options:kNilOptions
                                                                        metrics:nil
                                                                          views:views];
        self.widthConstraint = constraints[1];
        self.widthConstraint.constant = 414.0;
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
}

- (UIActivityIndicatorView *)sendingIndicatorView {
    return nil;
}

- (UIButton *)sendingRetryButton {
    return nil;
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

#pragma mark - Retry

- (IBAction)handleRetryButtonTapped:(id)sender {
    [self.eventHandler retrySendMessage];
}

@end
