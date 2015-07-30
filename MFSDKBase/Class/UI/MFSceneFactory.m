//
//  MFSceneFactory.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFSceneFactory.h"
#import "HTMLNode.h"
#import "UIView+UUID.h"
#import "UIView+Sizes.h"
#import "MFHelper.h"
#import "MFLabel.h"
#import "MFImageView.h"
#import "MFEmojiView.h"
#import "MFLayoutCenter.h"
#import "MFStrategyCenter.h"
#import "MFResourceCenter.h"
#import "MFDOM.h"
#import "MFVirtualNode.h"
#import "NSObject+VirtualNode.h"
@interface MFSceneFactory()
@property (nonatomic,weak)id object;
@property (nonatomic,copy)NSString *pageID;
@property (nonatomic,strong)NSDictionary *classMapDict;
@property (nonatomic,strong)NSDictionary *propertyMapDict;
@end

@implementation MFSceneFactory
SYNTHESIZE_SINGLETON_FOR_CLASS(MFSceneFactory)
- (void)removeAll
{
    self.classMapDict = nil;
    self.propertyMapDict = nil;
    self.object = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        if (nil == self.classMapDict || nil == self.propertyMapDict) {
            self.classMapDict = [[MFStrategyCenter sharedMFStrategyCenter] sourceWithID:@"MFWidgetMap"];
            self.propertyMapDict = [[MFStrategyCenter sharedMFStrategyCenter] sourceWithID:@"MFPropertyMap"];
        }
    }
    return self;
}

- (id)createWidgetWithNode:(MFVirtualNode*)node
{
    id widget = nil;

    MFDOM *domObj = node.dom;
    if ([self supportHtmlTag:domObj.clsType]) {
        widget = [self allocObject:domObj.clsType];
        NSString *uuid = [domObj.htmlNodes getAttributeNamed:KEYWORD_ID];
        
        if([self bindObject:widget]) {
            [self batchExecution:domObj.cssNodes];
        }
        
        if ([widget respondsToSelector:@selector(setOpaque:)]) {
            [widget setOpaque:YES];
        }
        if ([widget respondsToSelector:@selector(setAlpha:)]) {
            [widget setAlpha:1.0];
        }
        
        [widget setUUID:uuid];
    }
    
    return widget;
}


- (id)createUIWithNode:(MFVirtualNode*)node sizeInfo:(NSDictionary*)sizeInfo
{
    if (![self supportHtmlTag:node.dom.clsType]) {
        return nil;
    }
    
    UIView * widget = nil;
    widget = [self createWidgetWithNode:node];
    [widget attachVirtualNode:node];
    for (MFVirtualNode *subNode in node.subNodes) {
        UIView *subWidget = [self createUIWithNode:subNode sizeInfo:sizeInfo];
        if (subWidget) {
            [widget addSubview:subWidget];
        }
    }
    
    return widget;
}

- (id)allocObject:(NSString*)classKey
{
    id result = nil;
    NSString *className = [self.classMapDict objectForKey:classKey];
    if (nil != className) {
        result = [self allocObjC:className];
    }
    return result;
}

- (BOOL)bindObject:(id)object
{
    BOOL ret = NO;
    if (nil != object) {
        self.object = object;
        ret = YES;
    }
    
    return ret;
}

- (void)batchExecution:(NSDictionary *)scriptDict
{
    NSString *propertyName = nil;
    NSString *propertyValue = nil;
    id dataObject = nil;
    
    for (NSString *metaProperty in [scriptDict allKeys]) {
        propertyName = [self.propertyMapDict objectForKey:metaProperty];
        propertyValue = [scriptDict objectForKey:metaProperty];
        dataObject = [self valueFormat:propertyValue withPropertyName:metaProperty];
        if (nil == propertyName || nil == dataObject) {
            continue;
        }
        [self setProperty:self.object popertyName:propertyName withObject:dataObject];
    }
}

#pragma mark run-time
#pragma --
- (BOOL)setProperty:(id)objC popertyName:(NSString*)popertyName withObject:(id)withObject
{
    BOOL ret = NO;
    SEL sel = NSSelectorFromString(popertyName);
    if([objC respondsToSelector:sel]) {
        [objC setValue:withObject forKey:popertyName];
        ret = YES;
    }else if ([popertyName isEqualToString:@"hidden"]) {
        [objC setValue:withObject forKey:@"hidden"];
    }

    return ret;
}

- (id)getProperty:(id)objC popertyName:(NSString*)popertyName
{
    id retObjC = nil;
    SEL sel = NSSelectorFromString(popertyName);
    if([objC respondsToSelector:sel]) {
        retObjC = [objC valueForKey:popertyName];
    }
    return retObjC;
}

- (id)allocObjC:(NSString*)className
{
    Class  tClass =  NSClassFromString(className);
    if (tClass) {
        return [[tClass alloc] init];
    }
    return nil;
}

- (id)valueFormat:(NSString *)propertyValue withPropertyName:(NSString *)propertyName
{
    id retObj = nil;
    if ([propertyName isEqualToString:@"height"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"width"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"left"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"top"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"border-radius"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"border-width"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"border-color"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"color"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"background-color"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"highlightedTextColor"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"text-align"]) {
        NSTextAlignment textAlignment = [MFHelper formatTextAlignmentWithString:propertyValue];
        retObj = [NSNumber numberWithInt:textAlignment];
    }else if ([propertyName isEqualToString:@"numberOfLines"]) {
        retObj = [NSNumber numberWithInt:[propertyValue intValue]];
    }else if ([propertyName isEqualToString:@"font"]) {
        retObj = [MFHelper formatFontWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"image"]) {
        retObj = [MFHelper formatImageWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"background-image"]) {
        retObj = propertyValue;
    }else if ([propertyName isEqualToString:@"alignmentType"]) {
        MFAlignmentType alignment = [MFHelper formatAlignmentWithString:propertyValue];
        retObj = [NSNumber numberWithInt:alignment];
    }else if ([propertyName isEqualToString:@"visibility"]) {
        retObj = [MFHelper formatVisibilityWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"format"]) {
        retObj = propertyValue;
    }else if ([propertyName isEqualToString:@"touchEnabled"]) {
        retObj = [MFHelper formatTouchEnableWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"style"]) {
        retObj = propertyValue;
    }else if ([propertyName isEqualToString:@"reverse"]) {
        retObj = [MFHelper formatReverseWithString:propertyValue];
    }
    
    return retObj;
}

- (BOOL)supportHtmlTag:(NSString *)htmlTag
{
    BOOL support = NO;
    if ([self.classMapDict objectForKey:htmlTag]) {
        support = YES;
    }
    return support;
}
@end
