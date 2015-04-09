//
//  MFDataBinding.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/9.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDataBinding.h"
#import "MFLabel.h"
#import "MFImageView.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "NSObject+DOM.h"
@implementation MFDataBinding
+ (void)bind:(UIView*)view withDataSource:(NSDictionary*)dataSource
{
    if (nil != view.DOM.bindingField) {
       [self bindDataToWidget:view dataSource:dataSource[view.DOM.bindingField]];
    }

    for (UIView *subView in view.subviews) {
        [self bind:subView withDataSource:dataSource];
    }
}

+ (void)bindDataToWidget:(id)widget dataSource:(NSString*)dataSource
{
    if (nil == dataSource) {
        return;
    }
    
    if ([widget isKindOfClass:[MFLabel class]]) {
        ((MFLabel*)widget).text = dataSource;
    } else if ([widget isKindOfClass:[MFImageView class]]) {
        if ([MFHelper isURLString:dataSource]) {
            //TODO;
        } else {
            UIImage *image = [MFResourceCenter imageNamed:dataSource];
            ((MFImageView*)widget).image = image;
        }
    }
}
@end
