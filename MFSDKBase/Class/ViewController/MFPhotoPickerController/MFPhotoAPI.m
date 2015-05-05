//
//  MFPhotoAPI.m
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/24.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFPhotoAPI.h"

@implementation MFPhotoAPI
+ (MFPhotoPickerController*)callAssetPickerController
{
    MFPhotoPickerController* picker = [[MFPhotoPickerController alloc] init];
    picker.maximumNumberOfSelection = 9;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = nil;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary* bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        }
        else {
            return YES;
        }
    }];
    return picker;
}

+ (UIImage*)imageWithAssetItem:(ALAsset*)asset theOiginal:(BOOL)theOiginal
{
    if ([asset isKindOfClass:[ALAsset class]]) {
        if (theOiginal) {
            return [UIImage imageWithCGImage:[asset defaultRepresentation].fullResolutionImage];
        }
        else {
            return [UIImage imageWithCGImage:[asset defaultRepresentation].fullScreenImage];
        }
    }
    return nil;
}
@end
