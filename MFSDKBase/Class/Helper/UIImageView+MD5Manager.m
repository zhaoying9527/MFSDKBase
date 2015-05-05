//
//  UIImageView+MD5Manager.m
//  MFSDK
//
//  Created by chicp on 15-4-3.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "UIImageView+MD5Manager.h"

@implementation UIImageView (MD5Manager)

- (void)setImageWithChatIdentifer:(NSString*)identifer
                 placeholderImage:(UIImage*)placeholderImage
                     fitImageSize:(CGSize)fitImageSize
                       completion:(void (^)(UIImage* image, NSError* error))complete
{
//TODO
//    if ([identifer rangeOfString:@"local_key_"].length > 0) {
//        NSString* realMD5 = [identifer stringByReplacingOccurrencesOfString:@"local_key_" withString:@""];
//        [self setImageWithUploadLocalId:realMD5 completion:complete];
//    }
//    else {
//
//        [self setImageCloudId:identifer placeholderImage:placeholderImage size:fitImageSize progress:^(double percentage, long long partialBytes, long long totalBytes) {
//            
//        } completion:^(UIImage *image, NSError *error) {
//            complete(image,error);
//
//        }];
//    }
}

@end
