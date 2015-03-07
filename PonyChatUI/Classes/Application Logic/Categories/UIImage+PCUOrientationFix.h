//
// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
//

#import <UIKit/UIKit.h>

@interface UIImage (PCUOrientationFix)

- (UIImage *)pcu_resizedImageWithUncompressedSizeInMB:(CGFloat)destImageSize
                                 interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)pcu_resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality;

@end
