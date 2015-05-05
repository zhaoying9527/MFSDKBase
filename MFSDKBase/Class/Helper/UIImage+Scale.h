//
//  UIImage+Scale.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/20.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(scale)
- (UIImage*)subImage:(CGRect)rect;
- (UIImage*)scaleToSize:(CGSize)size;
@end
