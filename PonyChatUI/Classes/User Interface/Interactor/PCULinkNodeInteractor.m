//
//  PCULinkNodeInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-15.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCULinkNodeInteractor.h"
#import "PCUMessage.h"
#import "PCUDefines.h"
#import <AFNetworking/AFNetworking.h>

@interface PCULinkNodeInteractor ()

@property (nonatomic, strong) PCUMessage *message;

@end

@implementation PCULinkNodeInteractor

- (instancetype)initWithMessage:(PCUMessage *)message {
    self = [super initWithMessage:message];
    if (self) {
        self.message = message;
        self.titleString = message.title;
        self.descriptionString = message.params[kPCUMessageParamsLinkDescriptionKey];
        self.linkURLString = message.params[kPCUMessageParamsLinkURLKey];
        [self sendIconImageAsyncRequest];
    }
    return self;
}

- (void)sendIconImageAsyncRequest {
    NSString *thumbImageURLString = self.message.params[kPCUMessageParamsLinkIconPathKey];
    if ([thumbImageURLString hasPrefix:@"http"]) {
        NSString *localCachePath = [NSTemporaryDirectory() stringByAppendingFormat:@".remoteIconImage.%@", self.message.identifier];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localCachePath]) {
            [self responseIconImageWithLocalPath:localCachePath];
        }
        else {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:thumbImageURLString]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:60.0];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSError *error;
                    [responseObject writeToFile:localCachePath options:kNilOptions error:&error];
                    if (error == nil) {
                        [self responseIconImageWithLocalPath:localCachePath];
                    }
                    else {
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            }];
            [[[AFHTTPSessionManager manager] operationQueue] addOperation:operation];
        }
    }
    else {
        [self responseIconImageWithLocalPath:thumbImageURLString];
    }
}

- (void)responseIconImageWithLocalPath:(NSString *)localPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *theImage = [UIImage imageWithContentsOfFile:localPath];//NSData -> UIImage将在子线程中进行
        if (theImage != nil) {
            self.iconImage = theImage;
        }
    });
}

@end
