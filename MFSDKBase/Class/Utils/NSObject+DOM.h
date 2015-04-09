//
//  UIView+Scene.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFDOM.h"
static void * DomKey = (void *)@"DomKey";

@interface NSObject (DOM)

- (void)attachDOM:(MFDOM*)dom;
- (MFDOM*)DOM;
- (void)detachDOM;
@end
