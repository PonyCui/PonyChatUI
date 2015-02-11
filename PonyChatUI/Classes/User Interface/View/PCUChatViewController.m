//
//  PCUChatViewController.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/11.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUChatViewController.h"
#import "PCUToolViewController.h"
#import "PCUApplication.h"
#import "PCUWireframe.h"

@interface PCUChatViewController ()

@property (nonatomic, strong) PCUToolViewController *toolViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *chatScrollView;

@end

@implementation PCUChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PCUWireframe *wireframe = PCU[@protocol(PCUWireframe)];
    self.toolViewController = [wireframe addToolViewToView:self.view];
    [self configureLayouts];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layouts

- (void)setBottomLayoutHeight:(CGFloat)layoutHeight {
    __block NSLayoutConstraint *constraint;
    [self.view.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.secondItem == self.toolViewController.view &&
            obj.firstItem == self.view &&
            obj.firstAttribute == NSLayoutAttributeBottom &&
            obj.secondAttribute == NSLayoutAttributeBottom) {
            constraint = obj;
        }
    }];
    [self.view layoutIfNeeded];
    constraint.constant = layoutHeight;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)configureLayouts {
    self.chatScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *views = @{@"toolView": self.toolViewController.view,
                            @"chatScrollView": self.chatScrollView};
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatScrollView]-0-[toolView]-0-|"
                                                                    options:kNilOptions
                                                                    metrics:nil
                                                                      views:views];
    [self.view addConstraints:hConstraints];
}

@end
