//
//  MFUIFactory.h
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HTMLNode;
@interface MFUIFactory : NSObject

+ (id)createUiWithPage:(HTMLNode*)node style:(NSDictionary*)cssDict;
+ (BOOL)addActionForWidget:(UIView*)widget withPage:(HTMLNode*)node;

@end
