//
//  PCUAttributedStringManager.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/12.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PCUAttributedStringConfigure;

@interface PCUAttributedStringManager : NSObject

@property (nonatomic, strong) PCUAttributedStringConfigure *configure;

@property (nonatomic, readonly) NSDictionary *attributes;

- (instancetype)initWithConfigure:(PCUAttributedStringConfigure *)configure;

- (NSAttributedString *)attributedStringWithString:(NSString *)argString;

@end
