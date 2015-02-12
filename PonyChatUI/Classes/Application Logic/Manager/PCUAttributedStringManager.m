//
//  PCUAttributedStringManager.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/12.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "PCUAttributedStringManager.h"
#import "PCUAttributedStringConfigure.h"

@interface PCUAttributedStringManager ()

@property (nonatomic, strong) NSDictionary *attributes;

@end

@implementation PCUAttributedStringManager

- (instancetype)initWithConfigure:(PCUAttributedStringConfigure *)configure {
    self = [super init];
    if (self) {
        self.configure = configure;
    }
    return self;
}

- (NSAttributedString *)attributedStringWithString:(NSString *)argString {
    return [[NSAttributedString alloc] initWithString:argString attributes:self.attributes];
}

- (void)setConfigure:(PCUAttributedStringConfigure *)configure {
    _configure = configure;
    self.attributes = nil;
}

- (NSDictionary *)attributes {
    if (_attributes == nil) {
        _attributes = @{
                        NSFontAttributeName : [self font],
                        NSParagraphStyleAttributeName : [self pragraphStyle]
                        };
    }
    return _attributes;
}

- (UIFont *)font {
    if (self.configure.fontWeight == PCUAttributedStringFontWeightBolder) {
        switch (self.configure.fontSize) {
            case PCUAttributedStringFontSizeSmall:
                return [UIFont boldSystemFontOfSize:15.0];
                break;
            case PCUAttributedStringFontSizeNormal:
                return [UIFont boldSystemFontOfSize:17.0];
                break;
            case PCUAttributedStringFontSizeLarge:
                return [UIFont boldSystemFontOfSize:19.0];
                break;
            default:
                return [UIFont boldSystemFontOfSize:17.0];
                break;
        }
    }
    else if (self.configure.fontWeight == PCUAttributedStringFontWeightNormal) {
        switch (self.configure.fontSize) {
            case PCUAttributedStringFontSizeSmall:
                return [UIFont systemFontOfSize:15.0];
                break;
            case PCUAttributedStringFontSizeNormal:
                return [UIFont systemFontOfSize:17.0];
                break;
            case PCUAttributedStringFontSizeLarge:
                return [UIFont systemFontOfSize:19.0];
                break;
            default:
                return [UIFont systemFontOfSize:17.0];
                break;
        }
    }
    else {
        return [UIFont systemFontOfSize:17.0];
    }
}

- (NSParagraphStyle *)pragraphStyle {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    switch (self.configure.fontSize) {
        case PCUAttributedStringFontSizeSmall:
            break;
        case PCUAttributedStringFontSizeNormal:
            style.minimumLineHeight = 23.0;
            style.maximumLineHeight = 23.0;
            style.lineBreakMode = NSLineBreakByTruncatingTail;
            break;
        case PCUAttributedStringFontSizeLarge:
            break;
        default:
            break;
    }
    return [style copy];
}

@end
