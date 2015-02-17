//
//  UILabel+PCUAttributedStringLinkResponder.m
//  PonyChatUI
//
//  Created by 崔 明辉 on 15/2/16.
//  Copyright (c) 2015年 多玩事业部 iOS开发组 YY Inc. All rights reserved.
//

#import "UILabel+PCUAttributedStringLinkResponder.h"
#import <objc/runtime.h>
#import <CoreText/CoreText.h>

#define kPCULinkAttributeName @"PCULinkAttributeName"

static char kPCUAttributedStringLinkResponderLinkStringBounds;

@interface PCULinkResponderClickableItem : NSObject

@property (nonatomic, assign) NSRange range;

@property (nonatomic, assign) CGRect responseRect;

@property (nonatomic, strong) NSURL *URL;

@end

@implementation UILabel (PCUAttributedStringLinkResponder)

- (void)setPcu_linkStringBounds:(NSArray *)pcu_linkStringBounds {
    objc_setAssociatedObject(self,
                             &kPCUAttributedStringLinkResponderLinkStringBounds,
                             pcu_linkStringBounds,
                             OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSArray *)pcu_linkStringBounds {
    return objc_getAssociatedObject(self, &kPCUAttributedStringLinkResponderLinkStringBounds);
}

- (void)pcu_configureAttributedStringLinkResponder {
    NSMutableArray *linkItems = [NSMutableArray array];
    NSAttributedString *attributedString = [self attributedText];
    [attributedString
     enumerateAttributesInRange:NSMakeRange(0, [attributedString length])
     options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired
     usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
         if (attrs[kPCULinkAttributeName] != nil) {
             PCULinkResponderClickableItem *item = [[PCULinkResponderClickableItem alloc] init];
             CGRect stringRect = [self pcu_boundingRectForCharacterRange:range];
             stringRect.size.height += 16.0;
             stringRect.size.width += 16.0;
             stringRect.origin.x -= 8.0;
             stringRect.origin.y -= 8.0;
             item.range = range;
             item.responseRect = stringRect;
             item.URL = [NSURL URLWithString:attrs[kPCULinkAttributeName]];
             [linkItems addObject:item];
         }
    }];
    [[self gestureRecognizers]
     enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeGestureRecognizer:obj];
    }];
    if ([linkItems count] > 0) {
        self.pcu_linkStringBounds = linkItems;
        UITapGestureRecognizer *tapGestureRecognizer =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handlePCUAttributedStringLinkResponderSingleTapped:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)handlePCUAttributedStringLinkResponderSingleTapped:(UITapGestureRecognizer *)tapGesture {
    CGPoint locationInView = [tapGesture locationInView:self];
    [self.pcu_linkStringBounds
     enumerateObjectsUsingBlock:^(PCULinkResponderClickableItem *obj, NSUInteger idx, BOOL *stop) {
         if (locationInView.x > obj.responseRect.origin.x &&
             locationInView.x < obj.responseRect.origin.x + obj.responseRect.size.width &&
             locationInView.y > obj.responseRect.origin.y &&
             locationInView.y < obj.responseRect.origin.y + obj.responseRect.size.height) {
             [[UIApplication sharedApplication] openURL:obj.URL];
         }
    }];
}

- (NSUInteger)glyphIndexForPoint:(CGPoint)point
{
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    textContainer.lineFragmentPadding = 0;
    textContainer.lineBreakMode = self.lineBreakMode;
    [layoutManager addTextContainer:textContainer];
    return [layoutManager glyphIndexForPoint:point inTextContainer:textContainer];;
}

- (CGRect)pcu_boundingRectForCharacterRange:(NSRange)range {
    NSAttributedString *text = [self attributedText];
    NSMutableAttributedString *mutableAttributedString = [text mutableCopy];
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:mutableAttributedString];

    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [textStorage addLayoutManager:layoutManager];
    
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:CGSizeMake(self.bounds.size.width, CGFLOAT_MAX)];
    [textContainer setLineFragmentPadding:0.0];
    
    [layoutManager addTextContainer:textContainer];
    NSRange glyphRange;
    [layoutManager characterRangeForGlyphRange:range actualGlyphRange:&glyphRange];
    return [layoutManager boundingRectForGlyphRange:glyphRange inTextContainer:textContainer];
}

@end

@implementation PCULinkResponderClickableItem

@end
