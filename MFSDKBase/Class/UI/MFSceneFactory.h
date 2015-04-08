//
//  MFSceneFactory.h
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFSDK.h"

@class HTMLNode;

@interface MFSceneFactory : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFSceneFactory)

- (id)createUiWithPage:(HTMLNode*)node style:(NSDictionary*)cssDict;
- (BOOL)addActionForWidget:(UIView*)widget withPage:(HTMLNode*)node;

- (void)removeAll;
- (BOOL)supportHtmlTag:(NSString *)htmlTag;

@end
