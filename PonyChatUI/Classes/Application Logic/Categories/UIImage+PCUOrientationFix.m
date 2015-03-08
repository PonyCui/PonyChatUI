//
// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
//

#import "UIImage+PCUOrientationFix.h"

#define imageBytesPerMB 1048576.0f
#define imageBytesPerPixel 4.0f
#define imagePixelsPerMB ( imageBytesPerMB / imageBytesPerPixel ) // 262144 pixels, for 4 bytes per pixel.

@implementation UIImage (PCUOrientationFix)

// Resizes the image to fit an uncompressed destination size in MB
- (UIImage *)pcu_resizedImageWithUncompressedSizeInMB:(CGFloat)destImageSize
                             interpolationQuality:(CGInterpolationQuality)quality
{
    CGSize sourceResolution = CGSizeZero;
    sourceResolution.width = self.size.width;
    sourceResolution.height = self.size.height;
    
    CGFloat sourceTotalPixels = sourceResolution.width * sourceResolution.height;
    
    CGFloat ratio = destImageSize * imagePixelsPerMB / sourceTotalPixels;
    
    CGSize newSize = CGSizeMake(floorf(self.size.width * ratio), floorf(self.size.height * ratio));
    
    return [self pcu_resizedImage:newSize interpolationQuality:quality];
}

// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)pcu_resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self pcu_resizedImage:newSize
                        transform:[self pcu_transformForOrientation:newSize]
                   drawTransposed:drawTransposed
             interpolationQuality:quality];
}

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)pcu_resizedImage:(CGSize)newSize
                    transform:(CGAffineTransform)transform
               drawTransposed:(BOOL)transpose
         interpolationQuality:(CGInterpolationQuality)quality {
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));
    
    if (bitmap == NULL) {
        NSLog(@"Failed context creation - image format is not supported by device. To force creation, try setting colorspace as CGColorSpaceCreateDeviceRGB() and/or bitmapinfo as kCGImageAlphaNone");
    } else {
        
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(bitmap, transform);
        
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, quality);
        
        // Draw into the context; this scales the image
        CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
        
        // Get the resized image from the context and a UIImage
        CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
        UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:screenScale orientation:UIImageOrientationUp];
        
        // Clean up
        CGContextRelease(bitmap);
        CGImageRelease(newImageRef);
        
        return newImage;
    }
    return nil;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)pcu_transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
        case UIImageOrientationDown:
            break;
            
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
    }
    
    return transform;
}

@end
