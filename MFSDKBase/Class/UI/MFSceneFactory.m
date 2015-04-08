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
#import "UIView+Events.h"
#import "MFHelper.h"
#import "MFLabel.h"
#import "MFImageView.h"
#import "MFEmojiView.h"
#import "MFLayoutCenter.h"
#import "MFStrategyCenter.h"
#import "MFDataBinding.h"
#import "MFDOM.h"
@interface MFSceneFactory()
@property (nonatomic,weak)id object;
@property (nonatomic,copy)NSString *pageID;
@property (nonatomic,strong)NSDictionary *classMapDict;
@property (nonatomic,strong)NSDictionary *propertyMapDict;

- (BOOL)setProperty:(id)objC popertyName:(NSString*)popertyName withObject:(id)withObject;
- (id)getProperty:(id)objC popertyName:(NSString*)popertyName;
- (id)allocObjC:(NSString*)className;
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

- (id)createUiWithDOM:(MFDOM*)domObj
{
    id widget = nil;
  
    if ([self supportHtmlTag:domObj.clsType]) {
        widget = [self allocObject:domObj.clsType];
        NSString *uuid = [domObj.htmlNodes getAttributeNamed:KEYWORD_ID];
        [widget setUUID:uuid];
        if([self bindObject:widget]) {
            [self batchExecution:domObj.cssNodes];
        }
        
        if ([widget respondsToSelector:@selector(setOpaque:)]) {
            [widget setOpaque:YES];
        }
        if ([widget respondsToSelector:@selector(setAlpha:)]) {
            [widget setAlpha:1.0];
        }

    }
    
    return widget;
}





- (id)createUiWithPage:(HTMLNode*)node style:(NSDictionary*)cssDict
{
    if (!node || ![self supportHtmlTag:node.tagName]) {
        return nil;
    }

    UIView *widget = [self allocObject:node.tagName];
    NSString *uuid = [node getAttributeNamed:KEYWORD_ID];
    [widget setUUID:uuid];
    if([self bindObject:widget]) {
        [self batchExecution:cssDict];
    }

    if ([widget respondsToSelector:@selector(setOpaque:)]) {
        [widget setOpaque:YES];
    }
    if ([widget respondsToSelector:@selector(setAlpha:)]) {
        [widget setAlpha:1.0];
    }

    return widget;
}

- (BOOL)addActionForWidget:(UIView*)widget withPage:(HTMLNode*)node;
{
    if (!node || ![self supportHtmlTag:node.tagName]) {
        return NO;
    }

    NSArray *attributes = [node getAttributes];
    NSString *actionRegix = @"on.*=(.*)\\((.*)\\)";
    NSString *realAttribute = @"";
    BOOL hasAction = NO;
    for (realAttribute in attributes) {
        if ([realAttribute rangeOfString:actionRegix options:NSRegularExpressionSearch].length > 0) {
            hasAction = YES;
            break;
        }
    }
    if (!hasAction) {
        return NO;
    }

    NSArray * components = [realAttribute componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
    if (components.count < 2) {
        return NO;
    }

    NSString *actionName = components[0];
    NSString *actionFunction = components[1];
    [widget attachEvent:actionName handlerName:actionFunction];

    return hasAction;
}

- (void)createPage:(NSString*)pageID
          pageNode:(HTMLNode*)pageNode
       styleParams:(NSDictionary*)styleParams
       dataBinding:(NSDictionary*)dataBinding
        parentView:(UIView*)parentView
     retWidgetInfo:(NSMutableDictionary *)widgetInfo
{
    if (![pageID isEqualToString:self.pageID]) {
        self.pageID = pageID;
        [parentView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            [view removeFromSuperview];
        }];

        [self createWidgetWithPage:pageNode
                        parentView:parentView
                       styleParams:styleParams
                 dataBindingParams:dataBinding
                     retWidgetInfo:widgetInfo];
    }
}

- (void)createWidgetWithPage:(HTMLNode *)pageNode
                  parentView:(UIView*)parentView
                 styleParams:(NSDictionary *)styleParams
           dataBindingParams:(NSDictionary *)dataBindingParams
               retWidgetInfo:(NSMutableDictionary *)widgetInfo
{
    if (!(pageNode && parentView && styleParams && dataBindingParams)) {
        return;
    }

    NSString *uuid = [pageNode getAttributeNamed:KEYWORD_ID];
    NSDictionary *styleDict = [styleParams objectForKey:uuid];
    NSDictionary *dataBindingDict = [dataBindingParams objectForKey:uuid];

    UIView * rootWidget = [[MFSceneFactory sharedMFSceneFactory] createUiWithPage:pageNode style:styleDict];
    NSString *frameString = [MFHelper getFrameStringWithStyle:styleDict];
    CGRect frame = [MFHelper formatRectWithString:frameString parentFrame:parentView.frame];
    rootWidget.frame = frame;
    [[MFSceneFactory sharedMFSceneFactory] addActionForWidget:rootWidget withPage:pageNode];

    if (nil != rootWidget) {
        [parentView addSubview:rootWidget];

        [self registerWidget:rootWidget
                    widgetId:uuid
                  widgetNode:pageNode
                 widgetStyle:styleDict
           widgetDataBinding:dataBindingDict
               retWidgetDict:widgetInfo];
    }

    for (HTMLNode *chindViewNode in [pageNode children]) {
        if (![[MFSceneFactory sharedMFSceneFactory] supportHtmlTag:chindViewNode.tagName]) {
            continue;
        }

        [self createWidgetWithPage:chindViewNode
                        parentView:rootWidget
                       styleParams:styleParams
                 dataBindingParams:dataBindingParams
                     retWidgetInfo:widgetInfo];
    }
}

- (void)registerWidget:(UIView*)widget
              widgetId:(NSString*)widgetId
            widgetNode:(HTMLNode*)widgetNode
           widgetStyle:(NSDictionary*)widgetStyle
     widgetDataBinding:(NSDictionary*)widgetDataBinding
         retWidgetDict:(NSMutableDictionary*)widgetInfo
{
    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:widget forKey:KEY_WIDGET];
    [info setValue:widgetNode forKey:KEY_WIDGET_NODE];
    [info setValue:widgetStyle forKey:KEY_WIDGET_STYLE];
    [info setValue:widgetDataBinding forKey:KEY_WIDGET_DATA_BINDING];
    [widgetInfo setObject:info forKey:widgetId];
}

- (void)bindingAndLayoutPageData:(NSDictionary*)dataSource
                      parentView:(UIView*)parentView
               widgetDataBinding:(NSDictionary*)dataBinding
                      widgetDict:(NSMutableDictionary*)widgetInfo
{
    if (!(parentView && dataSource)) {
        return;
    }

    NSString *uuid = [parentView UUID];
    NSDictionary *widgetInfoDict = [widgetInfo objectForKey:uuid];
    NSDictionary *dataBindingDict =[widgetInfoDict objectForKey:KEY_WIDGET_DATA_BINDING];
    UIView* widgetObject = [widgetInfoDict objectForKey:KEY_WIDGET];
    [MFDataBinding bindingWidget:widgetObject withDataSource:dataSource dataBinding:dataBindingDict];

    for (UIView *childView in parentView.subviews) {
        uuid = [childView UUID];
        widgetInfoDict = [widgetInfo objectForKey:uuid];
        dataBindingDict = dataBinding;
        UIView* widgetObject = [widgetInfoDict objectForKey:KEY_WIDGET];
        //TODO        widgetObject.frame = [[self.autoLayoutSizeInfo objectForKey:uuid] CGRectValue];
        [self bindingAndLayoutPageData:dataSource
                            parentView:childView
                     widgetDataBinding:dataBinding
                            widgetDict:widgetInfo];
    }
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
    for (NSString *metaProperty in [scriptDict allKeys]) {
        NSString *propertyName = [self.propertyMapDict objectForKey:metaProperty];
        NSString *propertyValue = [scriptDict objectForKey:metaProperty];
        id dataObject = [self valueFormat:propertyValue withPropertyName:metaProperty];
        if (nil == propertyName || nil == dataObject) {
            NSLog(@"warning: propertyName or dataObject is nil");
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
        retObj = [UIImage imageNamed:propertyValue];
    }else if ([propertyName isEqualToString:@"backgroundImage"]) {
        retObj = [UIImage imageNamed:propertyValue];
    }else if ([propertyName isEqualToString:@"align"]) {
        MFAlignmentType alignment = [MFHelper formatAlignmentWithString:propertyValue];
        retObj = [NSNumber numberWithInt:alignment];
    }else if ([propertyName isEqualToString:@"visibility"]) {
        retObj = [MFHelper formatVisibilityWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"layout"]) {
        MFLayoutType layoutType = [MFHelper formatLayoutWithString:propertyValue];
        retObj = [NSNumber numberWithInt:layoutType];
    }else if ([propertyName isEqualToString:@"format"]) {
        retObj = propertyValue;
    }else if ([propertyName isEqualToString:@"side"]) {
        retObj = [MFHelper formatSideWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"touchEnabled"]) {
        retObj = [MFHelper formatTouchEnableWithString:propertyValue];
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

