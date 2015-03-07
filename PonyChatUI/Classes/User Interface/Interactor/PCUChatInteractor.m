//
//  PCUChatInterator.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/13.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUChatInteractor.h"
#import "PCUMessageManager.h"
#import "PCUMessage.h"
#import "PCUNodeInteractor.h"
#import "PCUApplication.h"

@interface PCUChatInteractor ()<PCUMessageManagerDelegate>

@end

@implementation PCUChatInteractor

- (void)dealloc {
    [self.messageManager disconnect];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.messageManager = PCU[[PCUMessageManager class]];
        self.messageManager.delegate = self;
    }
    return self;
}

#pragma mark - Send Message

- (void)sendTextMessageWithString:(NSString *)argString {
    PCUMessage *message = [[PCUMessage alloc] init];
    message.identifier = [NSString stringWithFormat:@"%d", arc4random()];
    message.isRead = YES;
    message.type = PCUMessageTypeTextMessage;
    message.sender = [PCUApplication sender];
    message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000;
    message.title = argString;
    [self.messageManager sendMessage:message];

}

- (void)sendVoiceMessageWithPath:(NSString *)argPath {
    PCUMessage *message = [[PCUMessage alloc] init];
    message.identifier = [NSString stringWithFormat:@"%d", arc4random()];
    message.isRead = YES;
    message.type = PCUMessageTypeVoiceMessage;
    message.sender = [PCUApplication sender];
    message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000;
    if (argPath != nil) {
        message.params = @{kPCUMessageParamsVoicePathKey: argPath};
    }
    [self.messageManager sendMessage:message];
}

- (void)sendImageMessageWithPath:(NSString *)argPath {
    PCUMessage *message = [[PCUMessage alloc] init];
    message.identifier = [NSString stringWithFormat:@"%d", arc4random()];
    message.isRead = YES;
    message.type = PCUMessageTypeImageMessage;
    message.sender = [PCUApplication sender];
    message.orderIndex = [[NSDate date] timeIntervalSince1970] * 1000;
    if (argPath != nil) {
        message.params = @{kPCUMessageParamsImagePathKey: argPath};
    }
    [self.messageManager sendMessage:message];
}

#pragma mark - PCUMessageManagerDelegate

- (void)messageManagerDidReceivedMessage:(PCUMessage *)message {
    NSMutableSet *nodeInteractors = self.nodeInteractors == nil ? [NSMutableSet set] : [self.nodeInteractors mutableCopy];
    if (message != nil) {
        PCUNodeInteractor *nodeInteractor = [PCUNodeInteractor nodeInteractorWithMessage:message];
        nodeInteractor.messageManager = self.messageManager;
        if ([self.nodeInteractors containsObject:nodeInteractor]) {
            //已经有相同的消息添加到对话框中了
        }
        else if (nodeInteractor != nil) {
            [nodeInteractors addObject:nodeInteractor];
            self.nodeInteractors = nodeInteractors;
        }
    }
}

- (void)messageManagerSendMessageStarted:(PCUMessage *)message {
    if (message != nil) {
        [self.nodeInteractors
         enumerateObjectsWithOptions:NSEnumerationConcurrent
         usingBlock:^(PCUNodeInteractor *obj, BOOL *stop) {
             if ([obj isNodeForMessage
                  :message]) {
                 obj.sendStatus = PCUNodeSendMessageStatusSending;
             }
        }];
    }
}

- (void)messageManagerDidSentMessage:(PCUMessage *)message {
    if (message != nil) {
        [self.nodeInteractors
         enumerateObjectsWithOptions:NSEnumerationConcurrent
         usingBlock:^(PCUNodeInteractor *obj, BOOL *stop) {
             if ([obj isNodeForMessage:message]) {
                 obj.sendStatus = PCUNodeSendMessageStatusSent;
             }
         }];
    }
}

- (void)messageManagerSendMessageFailed:(PCUMessage *)message error:(NSError *)error {
    if (message != nil) {
        [self.nodeInteractors
         enumerateObjectsWithOptions:NSEnumerationConcurrent
         usingBlock:^(PCUNodeInteractor *obj, BOOL *stop) {
             if ([obj isNodeForMessage:message]) {
                 obj.sendStatus = PCUNodeSendMessageStatusError;
             }
         }];
    }
}

#pragma mark - Setter

- (void)setNodeInteractors:(NSSet *)nodeInteractors {
    [self compareWithNewSet:nodeInteractors];
    _nodeInteractors = nodeInteractors;
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

@end
