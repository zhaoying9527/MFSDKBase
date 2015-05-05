//
//  UIImageView.h
//  MFSDK
//
//  Created by chicp on 15-4-3.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIImageView (MD5Manager)

- (void)setImageWithChatIdentifer:(NSString*)identifer
                 placeholderImage:(UIImage*)placeholderImage
                     fitImageSize:(CGSize)fitImageSize
                       completion:(void (^)(UIImage* image, NSError* error))complete;

@end
