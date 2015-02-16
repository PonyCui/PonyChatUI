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
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[nodeView(==superView)]"
                                                                        options:kNilOptions
                                                                        metrics:nil
                                                                          views:views];
        [[self.view superview] addConstraints:constraints];
    }
    {
        NSLayoutConstraint *constaints = [NSLayoutConstraint constraintWithItem:self.view
                                                                      attribute:NSLayoutAttributeHeight
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:nil
                                                                      attribute:NSLayoutAttributeNotAnAttribute
                                                                     multiplier:1.0
                                                                       constant:0.0];
        self.heightConstraint = constaints;
        [[self.view superview] addConstraint:self.heightConstraint];
    }
}

@end
