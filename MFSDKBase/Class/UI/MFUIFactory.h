//
//  MFUIFactory.h
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFDefine.h"

@class HTMLNode;
@interface MFUIFactory : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFUIFactory)

- (id)createUiWithPage:(HTMLNode*)node style:(NSDictionary*)cssDict;
- (BOOL)addActionForWidget:(UIView*)widget withPage:(HTMLNode*)node;
//- (BOOL)bindObject:(id)object;
//- (void)batchExecution:(NSDictionary *)scriptDict;
//- (id)valueFormat:(NSString *)propertyValue withPropertyName:(NSString *)propertyName;
//- (id)allocObject:(NSString*)amlScript;
//- (BOOL)setProperty:(id)objC popertyName:(NSString*)popertyName withObject:(id)withObject;
//- (id)getProperty:(id)objC popertyName:(NSString*)popertyName;
- (BOOL)supportHtmlTag:(NSString *)htmlTag;


@end
