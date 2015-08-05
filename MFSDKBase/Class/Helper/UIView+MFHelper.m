//
//  UIView+MFHelper.m
//  MFSDK
//
//  Created by 李春荣 on 15/3/23.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "UIView+MFHelper.h"
#import <objc/runtime.h>

@implementation UIView (MFHelper)
- (id)MFUUID
{
    return objc_getAssociatedObject(self, MF_UUIDPorpertyKey);
}

- (void)setMFUUID:(NSString *)UUID
{
    objc_setAssociatedObject(self, MF_UUIDPorpertyKey, UUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)MFViewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (UITableViewCell*)MFViewCell {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell*)nextResponder;
        }
    }
    return nil;
}
@end
