//
//  PCUGalleryPresentTransition.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUGalleryPresentTransition.h"

@interface PCUGalleryPresentTransition ()

@end

@implementation PCUGalleryPresentTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext
                                            viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext
                                          viewControllerForKey:UITransitionContextToViewControllerKey];
    toViewController.view.alpha = 0.0;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    [UIView
     animateKeyframesWithDuration:[self transitionDuration:transitionContext]
     delay:0.0f
     options:kNilOptions
     animations:^{
         toViewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

@end
