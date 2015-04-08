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
#import "MFScene.h"
@class HTMLNode;

@interface MFSceneFactory : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFSceneFactory)
- (id)createUiWithDOM:(MFDOM*)domObj;

- (id)createUiWithPage:(HTMLNode*)node style:(NSDictionary*)cssDict;
- (BOOL)addActionForWidget:(UIView*)widget withPage:(HTMLNode*)node;

- (void)createPage:(NSString*)pageID
          pageNode:(HTMLNode*)pageNode
       styleParams:(NSDictionary*)styleParams
       dataBinding:(NSDictionary*)dataBinding
        parentView:(UIView*)parentView
     retWidgetInfo:(NSMutableDictionary *)widgetInfo;
- (void)createWidgetWithPage:(HTMLNode *)pageNode
                  parentView:(UIView*)parentView
                 styleParams:(NSDictionary *)styleParams
           dataBindingParams:(NSDictionary *)dataBindingParams
               retWidgetInfo:(NSMutableDictionary *)widgetInfo;
- (void)registerWidget:(UIView*)widget
              widgetId:(NSString*)widgetId
            widgetNode:(HTMLNode*)widgetNode
           widgetStyle:(NSDictionary*)widgetStyle
     widgetDataBinding:(NSDictionary*)widgetDataBinding
         retWidgetDict:(NSMutableDictionary*)widgetInfo;

- (void)bindingAndLayoutPageData:(NSDictionary*)dataSource
                      parentView:(UIView*)parentView
               widgetDataBinding:(NSDictionary*)dataBinding
                      widgetDict:(NSMutableDictionary*)widgetInfo;

- (void)removeAll;
- (BOOL)supportHtmlTag:(NSString *)htmlTag;

@end
