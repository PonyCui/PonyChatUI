//
//  PCUChatInterator.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUChatInterator.h"
#import "PCUMessageManager.h"
#import "PCUMessage.h"
#import "PCUChat.h"
#import "PCUNodeInterator.h"
#import "PCUApplication.h"

@interface PCUChatInterator ()<PCUMessageManagerDelegate>

@end

@implementation PCUChatInterator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messageManager = PCU[[PCUMessageManager class]];
        self.messageManager.delegate = self;
    }
    return self;
}

- (void)messageManagerDidReceivedMessage:(PCUMessage *)message {
    NSMutableArray *nodeInteractors = self.nodeInteractors == nil ? [@[] mutableCopy] : [self.nodeInteractors mutableCopy];
    if (message != nil) {
        PCUNodeInterator *nodeInteractor = [PCUNodeInterator nodeInteractorWithMessage:message];
        if (nodeInteractor != nil) {
            [nodeInteractors addObject:nodeInteractor];
            [nodeInteractors sortUsingComparator:^NSComparisonResult(PCUNodeInterator *obj1, PCUNodeInterator *obj2) {
                if (obj1.orderIndex == obj2.orderIndex) {
                    return NSOrderedSame;
                }
                else {
                    return obj1.orderIndex < obj2.orderIndex ? NSOrderedAscending : NSOrderedDescending;
                }
            }];
            self.nodeInteractors = nodeInteractors;
        }
    }
}

@end
