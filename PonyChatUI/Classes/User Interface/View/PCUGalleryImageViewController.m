//
//  PCUGalleryImageViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUGalleryImageViewController.h"

@interface PCUGalleryImageViewController ()<UIScrollViewDelegate> {
    BOOL _isDuringDoubleTap;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTrailingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewBottomConstraint;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *singleTapGestureRecognizer;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *doubleTapGestureRecognizer;

@end

@implementation PCUGalleryImageViewController

- (void)dealloc
{
    self.scrollView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.singleTapGestureRecognizer requireGestureRecognizerToFail:self.doubleTapGestureRecognizer];
    self.scrollView.delegate = self;
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 5.0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self updateImageViewLayout];
}

- (void)setImage:(UIImage *)image {
    self.imageView.image = image;
    [self updateImageViewLayout];
}

- (void)updateImageViewLayout {
    CGSize imageSize = self.imageView.image.size;
    if (imageSize.width == 0.0 || imageSize.height == 0.0) {
        return;
    }
    CGSize screenSize;
    if (CGRectGetHeight(self.view.bounds) > CGRectGetWidth(self.view.bounds)) {
        //竖屏
        screenSize.width = MIN(CGRectGetWidth(self.view.bounds), imageSize.width);
        screenSize.height = screenSize.width * imageSize.height / imageSize.width;
        self.imageViewLeadingConstraint.constant = 0.0;
        self.imageViewTrailingConstraint.constant = 0.0;
    }
    else {
        //横屏
        screenSize.height = MIN(CGRectGetHeight(self.view.bounds), imageSize.height);
        screenSize.width = screenSize.height * imageSize.width / imageSize.height;
        self.imageViewTopConstraint.constant = 0.0;
        self.imageViewBottomConstraint.constant = 0.0;
    }
    self.imageViewWidthConstraint.constant = screenSize.width;
    self.imageViewHeightConstraint.constant = screenSize.height;
    [self performSelector:@selector(updateImageViewInsetLayout) withObject:nil afterDelay:0.001];
}

- (void)updateImageViewInsetLayout {
    if (CGRectGetHeight(self.view.bounds) > CGRectGetWidth(self.view.bounds)) {
        //竖屏
        CGFloat heightOffset = CGRectGetHeight(self.imageView.frame) - CGRectGetHeight(self.view.bounds);
        if (heightOffset > 0) {
            self.imageViewTopConstraint.constant = 0.0;
            self.imageViewBottomConstraint.constant = 0.0;
        }
        else {
            self.imageViewTopConstraint.constant = abs(heightOffset) / 2.0;
            self.imageViewBottomConstraint.constant = 0.0;
        }
    }
    else {
        //横屏
        CGFloat widthOffset = CGRectGetWidth(self.imageView.frame) - CGRectGetWidth(self.view.bounds);
        if (widthOffset > 0) {
            self.imageViewLeadingConstraint.constant = 0.0;
            self.imageViewTrailingConstraint.constant = 0.0;
        }
        else {
            self.imageViewLeadingConstraint.constant = abs(widthOffset) / 2.0;
            self.imageViewTrailingConstraint.constant = 0.0;
        }
    }
}

- (void)updateImageViewInsetLayoutForMinimumZoomScale {
    if (CGRectGetHeight(self.view.bounds) > CGRectGetWidth(self.view.bounds)) {
        CGFloat heightOffset = self.imageViewHeightConstraint.constant - CGRectGetHeight(self.view.bounds);
        self.imageViewTopConstraint.constant = abs(heightOffset) / 2.0;
        self.imageViewBottomConstraint.constant = 0.0;
    }
    else {
        CGFloat widthOffset = self.imageViewWidthConstraint.constant - CGRectGetWidth(self.view.bounds);
        self.imageViewLeadingConstraint.constant = abs(widthOffset) / 2.0;
        self.imageViewTrailingConstraint.constant = 0.0;
    }
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (_isDuringDoubleTap) {
        return;
    }
    [self updateImageViewInsetLayout];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (_isDuringDoubleTap) {
        return;
    }
    [self updateImageViewInsetLayout];
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

#pragma mark - Touches

- (IBAction)handleDoubleTap:(UITapGestureRecognizer *)sender {
    _isDuringDoubleTap = YES;
    if (self.scrollView.zoomScale > self.scrollView.minimumZoomScale) {
        [self updateImageViewInsetLayoutForMinimumZoomScale];
        [UIView animateWithDuration:0.25 animations:^{
            [self.scrollView setZoomScale:self.scrollView.minimumZoomScale animated:NO];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _isDuringDoubleTap = NO;
        }];
    }
    else {
        CGPoint locationInView = [sender locationInView:sender.view];
        [UIView animateWithDuration:0.25 animations:^{
            self.imageViewTrailingConstraint.constant = 0.0;
            self.imageViewLeadingConstraint.constant = 0.0;
            self.imageViewTopConstraint.constant = 0.0;
            self.imageViewBottomConstraint.constant = 0.0;
            [self.scrollView zoomToRect:CGRectMake(locationInView.x-22, locationInView.y-22, 44, 44) animated:NO];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _isDuringDoubleTap = NO;
        }];
    }
}

- (IBAction)handleSingleTap:(id)sender {
    [self.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
