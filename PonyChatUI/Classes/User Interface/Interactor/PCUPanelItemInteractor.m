//
//  PCUPanelItemInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-22.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUPanelItemInteractor.h"
#import "PCUPanelItemManager.h"
#import "PCUPanelItem.h"
#import <AFNetworking/AFNetworking.h>
#import <PonyRouter/PGRApplication.h>

@interface PCUPanelItemInteractor ()

@property (nonatomic, strong) PCUPanelItem *item;

@end

@implementation PCUPanelItemInteractor

- (instancetype)initWithPanelItem:(PCUPanelItem *)item {
    self = [super init];
    if (self) {
        self.item = item;
        [self sendIconImageRequest];
    }
    return self;
}

- (NSString *)titleString {
    return self.item.title;
}

- (void)sendIconImageRequest {
    if ([self.item.iconURLString hasPrefix:@"http"]) {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.item.iconURLString]
                                                 cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval:15.0];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer.acceptableContentTypes = nil;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            self.iconImage = [UIImage imageWithData:responseObject];
        } failure:nil];
        [[[AFHTTPSessionManager manager] operationQueue] addOperation:operation];
    }
    else {
        self.iconImage = [UIImage imageNamed:self.item.iconURLString];
    }
}

- (void)sendRequestWithViewController:(UIViewController *)viewController {
    [[PGRApplication sharedInstance] openURL:[NSURL URLWithString:self.item.actionURLString]
                                sourceObject:viewController];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.item.actionURLString]];
}

@end
