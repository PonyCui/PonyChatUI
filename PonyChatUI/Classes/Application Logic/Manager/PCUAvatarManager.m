//
//  PCUAvatarManager.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-2-15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUAvatarManager.h"
#import <TMCache/TMCache.h>
#import <AFNetworking/AFNetworking.h>

#define kPCUAvatarManagerTMCachePrefix @"kPCUAvatarManagerTMCachePrefix"

@interface PCUAvatarManager ()

@property (nonatomic, strong) NSMutableDictionary *asyncQueue;

@end

@implementation PCUAvatarManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.asyncQueue = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)sendAsyncRequestWithURLString:(NSString *)URLString {
    if (self.asyncQueue[URLString] == nil) {
        [self.asyncQueue setObject:@1 forKey:URLString];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]
                                                 cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                             timeoutInterval:15.0];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer.acceptableContentTypes = nil;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.asyncQueue removeObjectForKey:URLString];
            UIImage *avatarImage = [UIImage imageWithData:responseObject];
            NSString *cacheKey = [NSString stringWithFormat:@"%@.%@",
                                  kPCUAvatarManagerTMCachePrefix, URLString];
            [[TMCache sharedCache] setObject:avatarImage forKey:cacheKey];
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kPCUAvatarManagerDidResponseUIImageNotification object:avatarImage];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self.asyncQueue performSelector:@selector(removeObjectForKey:) withObject:URLString afterDelay:15.0];
        }];
        [[[AFHTTPSessionManager manager] operationQueue] addOperation:operation];
    }
}

- (UIImage *)sendSyncRequestWithURLString:(NSString *)URLString {
    NSString *cacheKey = [NSString stringWithFormat:@"%@.%@", kPCUAvatarManagerTMCachePrefix, URLString];
    return [[TMCache sharedCache] objectForKey:cacheKey];
}

@end
