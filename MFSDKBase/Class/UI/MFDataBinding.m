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
#import "MFButton.h"
#import "MFTipsWidget.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "NSObject+DOM.h"
#import "HTMLNode.h"
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
    if ([widget isKindOfClass:[MFLabel class]]) {
        NSString *defaultText = [((MFLabel*)widget).DOM.htmlNodes getAttributeNamed:@"value"];
        ((MFLabel*)widget).text = dataSource ? dataSource : defaultText;
    } else if ([widget isKindOfClass:[MFImageView class]]) {
        NSString *defaultSrc = [((MFImageView*)widget).DOM.htmlNodes getAttributeNamed:@"src"];
        if ((nil != dataSource && [dataSource length] > 0) || (defaultSrc && defaultSrc.length>0)) {
            if ([MFHelper isURLString:dataSource]) {
                //TODO;
            } else {
                UIImage *defaultImage = [MFResourceCenter imageNamed:defaultSrc];
                UIImage *image = [MFResourceCenter imageNamed:dataSource];
                ((MFImageView*)widget).image = image ? image : defaultImage;
            }
        }
    } else if ([widget isKindOfClass:[MFButton class]]) {
        ((MFButton*)widget).text = dataSource;
    } else if ([widget isKindOfClass:[MFTipsWidget class]]) {
        ((MFTipsWidget*)widget).text = dataSource;
    }
}
@end
