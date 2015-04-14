//
//  UIView+UUID.m
//  MFSDK
//
//  Created by 李春荣 on 15/3/23.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "UIView+UUID.h"
#import <objc/runtime.h>

@implementation UIView (UUID)
- (id)UUID
{
    return objc_getAssociatedObject(self, UUIDPorpertyKey);
}

- (void)setUUID:(NSString *)UUID
{
    objc_setAssociatedObject(self, UUIDPorpertyKey, UUID, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
