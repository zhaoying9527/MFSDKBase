//
//  MFPhotoAPI.h
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/24.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFPhotoPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
@interface MFPhotoAPI : NSObject
/**
 *  相机胶卷多图选择控件
 *
 *  属性：maximumNumberOfSelection 多张控制
 *
 *  @return 选择控制器
 */
+ (MFPhotoPickerController*)callAssetPickerController;
/**
 *  从资产对象对象获取图片数据
 *
 *  @param asset      资产对象
 *  @param theOiginal 是否取原始图片还是屏幕截屏
 *
 *  @return 图片数据
 */
+ (UIImage*)imageWithAssetItem:(ALAsset*)asset theOiginal:(BOOL)theOiginal;
@end
