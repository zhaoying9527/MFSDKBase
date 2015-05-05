//
//  MFPhoto.h
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/22.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#ifndef ZYQAssetPickerControllerDemo_MFPhoto_h
#define ZYQAssetPickerControllerDemo_MFPhoto_h
#define IS_IOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#define BLUETEXTCOLOR [UIColor colorWithRed:0.0 green:170.0 / 255.0 blue:238.0 / 25.0 alpha:1.0]
#define kThumbnailLength [[UIScreen mainScreen] bounds].size.width/4.0-2//78.0f
#define kThumbnailSize CGSizeMake(kThumbnailLength, kThumbnailLength)
#define kPopoverContentSize  [[UIScreen mainScreen] bounds].size

#endif
