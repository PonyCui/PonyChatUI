//
//  PCUGalleryDismissTransition.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUGalleryDismissTransition.h"

@implementation PCUGalleryDismissTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext
                                            viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext
                                          viewControllerForKey:UITransitionContextToViewControllerKey];
    fromViewController.view.alpha = 1.0;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toViewController.view];
    [containerView addSubview:fromViewController.view];
    [UIView
     animateKeyframesWithDuration:[self transitionDuration:transitionContext]
     delay:0.0f
     options:kNilOptions
     animations:^{
         fromViewController.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
         fromViewController.view.alpha = 0.0;
     } completion:^(BOOL finished) {
         [transitionContext completeTransition:YES];
     }];
}

@end
