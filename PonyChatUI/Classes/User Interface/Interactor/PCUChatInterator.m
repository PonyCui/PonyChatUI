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
#import "PCUNodeInteractor.h"
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
    NSMutableSet *nodeInteractors = self.nodeInteractors == nil ? [NSMutableSet set] : [self.nodeInteractors mutableCopy];
    if (message != nil) {
        PCUNodeInteractor *nodeInteractor = [PCUNodeInteractor nodeInteractorWithMessage:message];
        if (nodeInteractor != nil) {
            [nodeInteractors addObject:nodeInteractor];
            self.nodeInteractors = nodeInteractors;
        }
    }
}

- (void)compareWithNewSet:(NSSet *)newSet {
    {
        NSMutableSet *minusSet = [self.nodeInteractors mutableCopy];
        [minusSet minusSet:newSet];
        self.minusInteractors = [minusSet copy];
    }
    {
        NSMutableSet *plusSet = [newSet mutableCopy];
        [plusSet minusSet:self.nodeInteractors];
        self.plusInteractors = plusSet;
    }
}

- (void)setNodeInteractors:(NSSet *)nodeInteractors {
    [self compareWithNewSet:nodeInteractors];
    _nodeInteractors = nodeInteractors;
}

@end

//[nodeInteractors sortUsingComparator:^NSComparisonResult(PCUNodeInterator *obj1, PCUNodeInterator *obj2) {
//    if (obj1.orderIndex == obj2.orderIndex) {
//        return NSOrderedSame;
//    }
//    else {
//        return obj1.orderIndex < obj2.orderIndex ? NSOrderedAscending : NSOrderedDescending;
//    }
//}];
