//
//  PCUGalleryPresentTransition.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUGalleryPresentTransition.h"
#import "PCUGalleryPageViewController.h"

@interface PCUGalleryPresentTransition ()

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIImageView *imageViewClone;

@end

@implementation PCUGalleryPresentTransition

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.20;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext
                                            viewControllerForKey:UITransitionContextFromViewControllerKey];
    PCUGalleryPageViewController *toViewController = (PCUGalleryPageViewController *)[transitionContext
                                                  viewControllerForKey:UITransitionContextToViewControllerKey];
    [self cloneImageView:(UIImageView *)toViewController.enterView];
    toViewController.view.alpha = 0.0;
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:fromViewController.view];
    [containerView addSubview:toViewController.view];
    [containerView addSubview:self.maskView];
    [containerView addSubview:self.imageViewClone];
    CGFloat scale = 1.0;
    if (CGRectGetWidth(toViewController.view.bounds) < CGRectGetHeight(toViewController.view.bounds)) {
        scale = CGRectGetWidth(toViewController.view.bounds) / CGRectGetWidth(self.imageViewClone.bounds);
    }
    else {
        scale = CGRectGetHeight(toViewController.view.bounds) / CGRectGetHeight(self.imageViewClone.bounds);
    }
    [UIView
     animateKeyframesWithDuration:[self transitionDuration:transitionContext]
     delay:0.0f
     options:kNilOptions
     animations:^{
         self.maskView.alpha = 1.0;
         self.imageViewClone.center = toViewController.view.center;
         self.imageViewClone.transform = CGAffineTransformMakeScale(scale, scale);
    } completion:^(BOOL finished) {
        toViewController.view.alpha = 1.0;
        [self.maskView removeFromSuperview];
        [self.imageViewClone removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
}

- (UIView *)maskView {
    if (_maskView == nil) {
        _maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.0;
    }
    return _maskView;
}

- (void)cloneImageView:(UIImageView *)imageView {
    if ([imageView isKindOfClass:[UIImageView class]]) {
        UIImageView *cloneView = [[UIImageView alloc] initWithFrame:imageView.frame];
        cloneView.image = imageView.image;
        cloneView.contentMode = imageView.contentMode;
        CGFloat yOffset = 0.0;
        CGFloat xOffset = 0.0;
        if ([imageView.superview.superview.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)imageView.superview.superview.superview;
            yOffset = CGRectGetMinY(imageView.frame) + CGRectGetMinY(imageView.superview.frame) - scrollView.contentOffset.y + CGRectGetMinY(scrollView.frame);
            xOffset = CGRectGetMinX(imageView.frame) + CGRectGetMinX(scrollView.frame);
        }
        cloneView.frame = CGRectMake(xOffset, yOffset, CGRectGetWidth(cloneView.frame), CGRectGetHeight(cloneView.frame));
        self.imageViewClone = cloneView;
    }
}

@end
