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
@class MFImageView;

@interface MFSceneFactory : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFSceneFactory)

/**
 * 创建虚拟view节点对应的实际view
 * @param node     虚拟view节点
 */
- (id)createWidgetWithNode:(MFVirtualNode*)node;

- (BOOL)supportHtmlTag:(NSString *)htmlTag;
- (id)getProperty:(id)objC popertyName:(NSString*)popertyName;
- (BOOL)setProperty:(id)objC popertyName:(NSString*)popertyName withObject:(id)withObject;
- (void)removeAll;

@end
