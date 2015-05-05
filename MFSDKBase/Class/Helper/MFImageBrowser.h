//
//  MFImageBrowser.h
//  MFSDK
//
//  Created by chicp on 15-3-31.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFCloudImageView.h"

@interface MFImageBrowser : NSObject

/**
 *	@brief	浏览图片
 *
 *	@param 	oldImageView 	头像所在的imageView
 */
+ (void)showImage:(MFCloudImageView *)avatarImageView delegate:(__weak id<UIScrollViewDelegate>)delegate;

+ (void)positionControl:(UIScrollView *)scrollView;

@end
