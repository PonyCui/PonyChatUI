//
//  PCUImageNodeInteractor.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15-3-7.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUImageNodeInteractor.h"
#import "PCUMessage.h"
#import "PCUSender.h"
#import "PCUApplication.h"
#import "PCUAvatarManager.h"
#import <AFNetworking/AFNetworking.h>

@interface PCUImageNodeInteractor ()

@property (nonatomic, strong) PCUMessage *message;

@property (nonatomic, copy) NSString *senderThumbURLString;

@end

@implementation PCUImageNodeInteractor

- (instancetype)initWithMessage:(PCUMessage *)message {
    self = [super initWithMessage:message];
    if (self) {
        self.message = message;
        self.senderThumbURLString = message.sender.thumbURLString;
        self.senderThumbImage = [PCU[[PCUAvatarManager class]]
                                 sendSyncRequestWithURLString:self.senderThumbURLString];
        if (self.senderThumbImage == nil) {
            [PCU[[PCUAvatarManager class]] sendAsyncRequestWithURLString:self.senderThumbURLString];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleAvatarManagerResponseUIImage:)
                                                     name:kPCUAvatarManagerDidResponseUIImageNotification
                                                   object:nil];
        [self sendThumbImageAsyncRequest];
    }
    return self;
}

- (void)handleAvatarManagerResponseUIImage:(NSNotification *)sender {
    if ([[sender userInfo][@"URLString"] isEqualToString:self.senderThumbURLString] &&
        [sender.object isKindOfClass:[UIImage class]]) {
        self.senderThumbImage = sender.object;
    }
}

- (void)sendThumbImageAsyncRequest {
    NSString *thumbImageURLString = self.message.params[kPCUMessageParamsThumbImagePathKey];
    if ([thumbImageURLString hasPrefix:@"http"]) {
        NSString *localCachePath = [NSTemporaryDirectory() stringByAppendingFormat:@".remoteThumbImage.%@", self.message.identifier];
        if ([[NSFileManager defaultManager] fileExistsAtPath:localCachePath]) {
            [self responseThumbImageWithLocalPath:localCachePath];
        }
        else {
            self.thumbStatus = PCUImageNodeThumbImageStatusLoading;
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:thumbImageURLString]
                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                 timeoutInterval:60.0];
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject isKindOfClass:[NSData class]]) {
                    NSError *error;
                    [responseObject writeToFile:localCachePath options:kNilOptions error:&error];
                    if (error == nil) {
                        [self responseThumbImageWithLocalPath:localCachePath];
                    }
                    else {
                        self.thumbStatus = PCUImageNodeThumbImageStatusFailed;
                    }
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                self.thumbStatus = PCUImageNodeThumbImageStatusFailed;
            }];
            [[[AFHTTPSessionManager manager] operationQueue] addOperation:operation];
        }
    }
    else {
        [self responseThumbImageWithLocalPath:thumbImageURLString];
    }
}

- (void)responseThumbImageWithLocalPath:(NSString *)localPath {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.thumbImage = [UIImage imageWithContentsOfFile:localPath];//NSData -> UIImage将在子线程中进行
        if (self.thumbImage != nil) {
            self.thumbImage = [self scaleThumbImageWithImage:self.thumbImage];
            self.thumbStatus = PCUImageNodeThumbImageStatusLoaded;
        }
    });
}

- (UIImage *)scaleThumbImageWithImage:(UIImage *)image {
    CGFloat eagerWidth = 180.0;
    CGFloat eagerHeight = self.thumbImage.size.height * eagerWidth / self.thumbImage.size.width;
    if (eagerHeight > 240.0) {
        eagerHeight = 240.0;
    }
    CGFloat ratio = self.thumbImage.size.width / eagerWidth;
    CGRect eagerRect = CGRectMake(0, 0, eagerWidth, eagerHeight);
    CGRect ratioRect = CGRectMake(0, 0, eagerWidth * ratio, eagerHeight *ratio);
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(self.thumbImage.CGImage, ratioRect);
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageRef];
    UIGraphicsBeginImageContextWithOptions(eagerRect.size, YES, [[UIScreen mainScreen] scale]);
    [cutImage drawInRect:eagerRect];
    UIImage *eagerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return eagerImage;
}

@end
