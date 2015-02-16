//
//  NSAttributedString+PCUAttributedString.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/16.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "NSAttributedString+PCUAttributedString.h"

@implementation NSAttributedString (PCUAttributedString)

- (NSAttributedString *)pcu_linkAttributedString {
    NSMutableAttributedString *mutableAttributedString = [self mutableCopy];
    NSString *originalString = [self string];
    NSRegularExpression *regularExpression = [NSRegularExpression
                                              regularExpressionWithPattern:@"\\u005B.*?]\\(.*?\\)"
                                              options:kNilOptions
                                              error:nil];
    NSArray *matches = [regularExpression matchesInString:originalString
                                                  options:kNilOptions
                                                    range:NSMakeRange(0, [originalString length])];
    [matches
     enumerateObjectsWithOptions:NSEnumerationReverse
     usingBlock:^(NSTextCheckingResult *obj, NSUInteger idx, BOOL *stop) {
        NSString *foundString = [originalString substringWithRange:obj.range];
        NSArray *components = [foundString componentsSeparatedByString:@"]("];
        NSString *titleString;
        NSString *URLString;
        if ([[components firstObject] length]) {
            titleString = [[components firstObject] substringFromIndex:1];
        }
        if ([[components lastObject] length]) {
            URLString = [[components lastObject] substringToIndex:[[components lastObject] length]-1];
        }
        [mutableAttributedString addAttributes:@{
                                                 NSLinkAttributeName : URLString
                                                 } range:obj.range];
        [mutableAttributedString replaceCharactersInRange:obj.range withString:titleString];
    }];
    return [mutableAttributedString copy];
}

@end
