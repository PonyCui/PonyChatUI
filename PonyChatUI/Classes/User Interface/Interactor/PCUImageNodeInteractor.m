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

@end

@implementation PCUImageNodeInteractor

- (instancetype)initWithMessage:(PCUMessage *)message {
    self = [super initWithMessage:message];
    if (self) {
        self.message = message;
        [self sendThumbImageAsyncRequest];
    }
    return self;
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
        UIImage *theImage = [UIImage imageWithContentsOfFile:localPath];//NSData -> UIImage将在子线程中进行
        if (theImage != nil) {
            self.thumbImage = [self scaleThumbImageWithImage:theImage];
            self.thumbStatus = PCUImageNodeThumbImageStatusLoaded;
        }
    });
}

- (UIImage *)scaleThumbImageWithImage:(UIImage *)image {
    CGFloat eagerWidth = 120.0;
    CGFloat eagerHeight = image.size.height * eagerWidth / image.size.width;
    if (eagerHeight > 160.0) {
        eagerHeight = 160.0;
    }
    CGFloat ratio = image.size.width / eagerWidth;
    CGRect eagerRect = CGRectMake(0, 0, eagerWidth, eagerHeight);
    CGRect ratioRect = CGRectMake(0, 0, eagerWidth * ratio, eagerHeight *ratio);
    CGImageRef cutImageRef = CGImageCreateWithImageInRect(image.CGImage, ratioRect);
    UIImage *cutImage = [UIImage imageWithCGImage:cutImageRef];
    UIGraphicsBeginImageContextWithOptions(eagerRect.size, YES, [[UIScreen mainScreen] scale]);
    [cutImage drawInRect:eagerRect];
    UIImage *eagerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return eagerImage;
}

@end
