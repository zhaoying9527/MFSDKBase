//
//  UIImage+Scale.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/20.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "UIImage+Scale.h"

@implementation UIImage(scale)
//等比例缩放
- (UIImage*)scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    CGContextRef contex = UIGraphicsGetCurrentContext();
    
    // back ground
    [[UIColor blackColor] setFill];
    CGContextFillRect(contex, CGRectMake(0, 0, size.width, size.height));
    
    // draw image
    CGFloat scale = MIN(size.width / self.size.width, size.height / self.size.height);
    CGFloat height = self.size.height * scale;
    CGFloat width = self.size.width * scale;
    [self drawInRect:CGRectMake(size.width / 2 - width / 2, size.height / 2 - height / 2, width, height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return scaledImage;
}

//截取部分图像
-(UIImage*)subImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    CFRelease(subImageRef);
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
