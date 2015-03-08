//
//  PCUGalleryPageViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-8.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUGalleryPageViewController.h"
#import "PCUGalleryImageViewController.h"
#import "PCUImageNodeInteractor.h"
#import "PCUGalleryImageViewController.h"
#import "PCUGalleryImagePresenter.h"

@interface PCUGalleryPageViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@end

@implementation PCUGalleryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureContentViewController];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureContentViewController {
    UIViewController *imageViewController =
    [self contentViewControllerWithNodeInteractor:[self.galleryDataSource galleryEnterNode]];
    if (imageViewController != nil) {
        [self setViewControllers:@[imageViewController]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    }
}

- (UIViewController *)contentViewControllerWithNodeInteractor:(PCUNodeInteractor *)nodeInteractor {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"PCUStoryBoard" bundle:nil];
    PCUGalleryImageViewController *viewController = [storyBoard instantiateViewControllerWithIdentifier:@"PCUGalleryImageViewController"];
    viewController.eventHandler = [[PCUGalleryImagePresenter alloc] init];
    viewController.eventHandler.userInterface = viewController;
    viewController.eventHandler.nodeInteractor = (PCUImageNodeInteractor *)nodeInteractor;
    return viewController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    return nil;
}

@end
