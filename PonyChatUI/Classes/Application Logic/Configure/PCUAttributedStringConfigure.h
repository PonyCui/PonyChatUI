//
//  PCUAttributedStringConfigure.h
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/12.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, PCUAttributedStringFontSize) {
    PCUAttributedStringFontSizeSmall,
    PCUAttributedStringFontSizeNormal,
    PCUAttributedStringFontSizeLarge
};

typedef NS_ENUM(NSUInteger, PCUAttributedStringFontWeight) {
    PCUAttributedStringFontWeightNormal,
    PCUAttributedStringFontWeightBolder
};

@interface PCUAttributedStringConfigure : NSObject

@property (nonatomic, assign) PCUAttributedStringFontSize fontSize;

@property (nonatomic, assign) PCUAttributedStringFontWeight fontWeight;

@end
