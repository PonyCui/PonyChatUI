//
//  PCUNodePresenter.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUNodePresenter.h"
#import "PCUNodeInterator.h"
#import "PCUNodeViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation PCUNodePresenter

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureReactiveCocoa];
    }
    return self;
}

- (void)configureReactiveCocoa {
    
}

@end
