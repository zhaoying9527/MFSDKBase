//
//  MFLayoutCenter.m

#import "HTMLNode.h"
#import "MFLayoutCenter.h"
#import "MFAMLScript.h"
#import "MFHelper.h"

@implementation MFLayoutCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFLayoutCenter)
- (void)removeAll
{
}

- (instancetype)init
{
    if (self = [super init]) {
        self.screenXY = [MFHelper screenXY];
        self.factor = (self.screenXY.width / STANDARD_WIDTH - 1.0);
    }
    return self;
}

- (void)canvasSizeWithStyleString:(NSString*)styleString
{
    self.canvasSize = [MFHelper formatRectWithString:styleString].size;
    self.compensateWidth = (int)self.canvasSize.width * self.factor;
    
}

- (CGRect)formatRectWithStyleString:(NSString*)styleString fit:(BOOL)fit
{
    CGRect rect = [MFHelper formatRectWithString:styleString];
    return fit?[self stretchRect:rect]:[self absoluteRect:rect];
}

- (CGRect)absoluteRect:(CGRect)rect
{
    if (self.screenXY.width > STANDARD_WIDTH) {
        rect.origin.x += self.compensateWidth ;
    }
    return rect;
}

- (CGRect)stretchRect:(CGRect)rect
{
    if (self.screenXY.width > STANDARD_WIDTH) {
        rect.size.width = rect.size.width + self.compensateWidth;
    }
    return rect;
}

- (NSInteger)round:(CGFloat)floatVal
{
    int intVal = (int)floatVal;
    return (int)(intVal+0.5);
}

- (CGRect)roundWithRect:(CGRect)rect
{
    return CGRectMake([self round:rect.origin.x], [self round:rect.origin.y], [self round:rect.size.width], [self round:rect.size.height]);
}

- (CGSize)fitPageSize:(NSDictionary*)widgetSizeDict maxSize:(CGSize)maxSize
{
    CGFloat minWidgetTop = 100000.0;
    CGFloat minWidgetLeft = 100000.0;
    CGSize size = CGSizeMake(0, 0);

    if (!widgetSizeDict.count) {
        return maxSize;
    }

    for (NSString *key in [widgetSizeDict allKeys]) {
        CGRect rect = [[widgetSizeDict objectForKey:key] CGRectValue] ;
        if (size.height < rect.origin.y + rect.size.height) {
            size.height = rect.origin.y + rect.size.height;
        }
        if (size.width < rect.origin.x + rect.size.width) {
            size.width = rect.origin.x + rect.size.width;
        }
        
        if (rect.origin.y < minWidgetTop) {
            minWidgetTop = rect.origin.y;
        }
        if (rect.origin.x < minWidgetLeft) {
            minWidgetLeft = rect.origin.x;
        }
    }
    
    if (size.height > maxSize.height) {
        size.height += (minWidgetTop<12)?minWidgetTop:12;
    } else {
        size.height = maxSize.height;
    }
    if (size.width > maxSize.width) {
        size.width += (minWidgetLeft<12)?minWidgetLeft:12;
    } else {
        size.width = maxSize.width;
    }

    return CGSizeMake(size.width, size.height);
}

- (CGRect)autoLayoutWithStyleDict:(NSDictionary*)styleItem
{
    CGRect retRect = CGRectZero;
    NSString *frameStr = [MFHelper getFrameStringWithStyle:styleItem];
    retRect = [MFHelper formatRectWithString:frameStr];
    
    return retRect;
}


- (NSDictionary*)getLayoutInfoForPage:(HTMLNode*)pageNode
                           templateId:(NSString *)templateId
                            styleDict:(NSDictionary*)styleDict
                             dataDict:(NSDictionary*)dataDict
                          dataBinding:(NSDictionary*)dataBindingDict
                      parentViewFrame:(CGRect)parentViewFrame
                        retWidgetInfo:(NSMutableDictionary *)widgetInfo

{
    CGRect pageFrame = [self sizeofPage:pageNode templateId:templateId styleDict:styleDict dataDict:dataDict dataBinding:dataBindingDict parentViewFrame:parentViewFrame retWidgetInfo:widgetInfo];
    
    NSDictionary * retDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInteger:pageFrame.size.height],KEY_WIDGET_HEIGHT,
                                    [NSNumber numberWithInteger:pageFrame.size.width],KEY_WIDGET_WIDTH,
                                    widgetInfo,KEY_WIDGET_SIZE,nil];
    return   retDictionary;
}


- (CGRect)sizeofPage:(HTMLNode*)pageNode
          templateId:(NSString *)templateId
           styleDict:(NSDictionary*)styleDict
            dataDict:(NSDictionary*)dataDict
         dataBinding:(NSDictionary*)dataBindingDict
     parentViewFrame:(CGRect)parentViewFrame
       retWidgetInfo:(NSMutableDictionary *)widgetInfo
{
    NSInteger subHeight = 0;
    NSString *type = [[pageNode tagName] lowercaseString];
    NSString *pageNodeUuid = [pageNode getAttributeNamed:@"id"];
    NSDictionary *styleItem = [styleDict objectForKey:pageNodeUuid];
    NSDictionary *dataItem = [dataDict objectForKey:pageNodeUuid];
    NSString *pageFrameStr = [MFHelper getFrameStringWithStyle:styleItem];
    CGRect pageFrame = [MFHelper formatRectWithString:pageFrameStr parentFrame:parentViewFrame];
    CGSize realSize = CGSizeZero;

    if ([MFHelper isKindOfLabel:type]) {
        NSString *amlMultiLineStr = [styleItem objectForKey:KEYWORD_NUMBEROFLINES];
        if ([MFHelper supportMultiLine:amlMultiLineStr]) {
            //TODO NSDictionary *data = [dataDict objectForKey:KEYWORD_DS_DATA];
            NSString *dataKey = [[dataBindingDict objectForKey:pageNodeUuid] objectForKey:KEYWORD_DATASOURCEKEY];
            NSString *dataSource = [dataItem objectForKey:dataKey];
            //emoji格式化
            //TODO dataSource = [dataSource ubb2unified];
            dataSource = dataSource;
            realSize = [self sizeOfLabelWithDataSource:styleItem dataSource:dataSource parentFrame:parentViewFrame];
        }
    }else if ([MFHelper isKindOfImage:type]) {
        realSize = [self imageSizeWithDataInfo:dataDict dataItems:dataItem];
    }
    
    if (realSize.width > 0 && realSize.height > 0) {
        if (realSize.height > pageFrame.size.height) {
            subHeight = realSize.height - pageFrame.size.height;
        }else {
            realSize = pageFrame.size;
        }
    }else {
        realSize = pageFrame.size;
    }

    pageFrame.size.width = realSize.width;
    pageFrame.size.height = realSize.height;
    CGSize pageSize = pageFrame.size;
    
    __block NSString *uuid;
    __block CGRect childFrame;
    __block NSMutableDictionary *childWidgetInfo = [NSMutableDictionary dictionary];
    [[pageNode children] enumerateObjectsUsingBlock:^(HTMLNode *chindViewNode, NSUInteger idx, BOOL *stop) {
        if ([[MFAMLScript sharedMFAMLScript] supportHtmlTag:chindViewNode.tagName]) {
            uuid = [chindViewNode getAttributeNamed:@"id"];
            childFrame = [self sizeofPage:chindViewNode templateId:templateId styleDict:styleDict dataDict:dataDict dataBinding:dataBindingDict
                           parentViewFrame:pageFrame retWidgetInfo:widgetInfo];

            [childWidgetInfo setObject:[NSValue valueWithCGRect:childFrame] forKey:uuid];
            //[widgetInfo setObject:[NSValue valueWithCGRect:childFrame] forKey:uuid];
        }
    }];

    CGSize fitSize = [self fitPageSize:childWidgetInfo maxSize:pageSize];
    [widgetInfo addEntriesFromDictionary:childWidgetInfo];
//    CGSize fitSize = [self fitPageSize:widgetInfo maxSize:pageSize];
    if (!((fitSize.width == pageSize.width) && (fitSize.height == pageSize.height))) {
        pageFrame.size = fitSize;
    }
    [widgetInfo setObject:[NSValue valueWithCGRect:pageFrame] forKey:pageNodeUuid];
    
    return   pageFrame;
}

//- (NSDictionary*)sizeofPage:(HTMLNode*)pageNode
//                 templateId:(NSString *)templateId
//                  styleDict:(NSDictionary*)styleDict
//                   dataDict:(NSDictionary*)dataDict
//                dataBinding:(NSDictionary*)dataBindingDict
//{
//    NSMutableDictionary *sumRectDictionary = [[NSMutableDictionary alloc] init];
//    NSInteger subHeight = 0;
//
//    NSString *pageNodeUuid = [pageNode getAttributeNamed:@"id"];
//    NSDictionary *styleItem = [styleDict objectForKey:pageNodeUuid];
//    NSDictionary *dataItem = [dataDict objectForKey:pageNodeUuid];
//    NSString *pageFrameStr = [MFHelper getFrameStringWithStyle:styleItem];
//    CGRect pageFrame = [MFHelper formatRectWithString:pageFrameStr];
//    CGSize pageSize = pageFrame.size;
//
//    
//    for (HTMLNode *chindViewNode in [pageNode children]) {
//        if (![[MFScript sharedMFScript] supportHtmlTag:chindViewNode.tagName]) {
//            continue;
//        }
//        
//        CGRect widgetFrame = CGRectZero;
//        CGSize realSize = CGSizeZero;
//        NSString *uuid = [chindViewNode getAttributeNamed:@"id"];
//        NSString *type = [[chindViewNode tagName] lowercaseString];
//        styleItem = [styleDict objectForKey:uuid];
//        dataItem = dataDict;
//        NSString *frameStr = [MFHelper getFrameStringWithStyle:styleItem];
//        widgetFrame = [MFHelper formatRectWithString:frameStr];
//        
//        widgetFrame.origin.y += subHeight;
//        if ([MFScriptHelper isKindOfLabel:type]) {
//            NSString *amlMultiLineStr = [styleItem objectForKey:KEYWORD_NUMBEROFLINES];
//            if ([MFScriptHelper supportMultiLine:amlMultiLineStr]) {
//                //TODO NSDictionary *data = [dataDict objectForKey:KEYWORD_DS_DATA];
//                NSString *dataKey = [[dataBindingDict objectForKey:uuid] objectForKey:KEYWORD_DATASOURCEKEY];
//                NSString *dataSource = [dataItem objectForKey:dataKey];
//                //emoji格式化
//                //TODO dataSource = [dataSource ubb2unified];
//                dataSource = dataSource;
//                realSize = [MFScriptHelper sizeOfLabelWithDataSource:styleItem dataSource:dataSource];
//            }
//        }else if ([MFScriptHelper isKindOfImage:type]) {
//            realSize = [self imageSizeWithDataInfo:dataDict dataItems:dataItem];
//        }
//        
//        if (realSize.width > 0 && realSize.height > 0) {
//            if (realSize.height > widgetFrame.size.height) {
//                subHeight = realSize.height - widgetFrame.size.height;
//            }else {
//                realSize = widgetFrame.size;
//            }
//        }else {
//            realSize = widgetFrame.size;
//        }
//        
//        widgetFrame.size.width = realSize.width;
//        widgetFrame.size.height = realSize.height;
//        [sumRectDictionary setObject:[NSValue valueWithCGRect:widgetFrame] forKey:uuid];
//    }
//    
//    CGSize fitSize = [self fitPageSize:sumRectDictionary maxSize:pageSize];
//    if (!((fitSize.width == pageSize.width) && (fitSize.height == pageSize.height))) {
//        pageFrame.size = fitSize;
//    }
//    [sumRectDictionary setObject:[NSValue valueWithCGRect:pageFrame] forKey:pageNodeUuid];
//    NSDictionary * retDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInteger:fitSize.height],KEY_WIDGET_HEIGHT,
//                                    [NSNumber numberWithInteger:fitSize.width],KEY_WIDGET_WIDTH,
//                                    sumRectDictionary,KEY_WIDGET_SIZE,nil];
//    
//    return   retDictionary;
//}

- (CGSize)imageSizeWithDataInfo:(NSDictionary*)dataInfo dataItems:(NSDictionary*)dataItems
{
    CGSize retSize = CGSizeMake(0, 0);
    NSDictionary *data = dataInfo;
//    NSDictionary *data = [dataInfo objectForKey:KEYWORD_DS_DATA];
    CGFloat width = [[data objectForKey:@"imageWidth"] floatValue];
    CGFloat height = [[data objectForKey:@"imageHeight"] floatValue];
    
    if (width > 0.0f && height > 0.0f) {
        retSize = [self fitImageSize:CGSizeMake(width, height)];
    }
    return retSize;
}

- (CGSize)fitImageSize:(CGSize)imageSize
{
    if (imageSize.width < IMAGEWIDTH && imageSize.height < IMAGEHEIGHT) {
        return  imageSize;
    }
    CGRect rect = CGRectMake(0, 0, IMAGEWIDTH, IMAGEHEIGHT);
    CGRect retRect = [MFHelper imageFitRect:rect aImageSize:imageSize];
    return retRect.size;
}

- (CGSize)sizeOfLabelWithDataSource:(NSDictionary*)layoutInfo dataSource:(NSString*)dataSource parentFrame:(CGRect)parentFrame
{
    NSString *fontString = [layoutInfo objectForKey:@"font"];
    UIFont *font = [MFHelper formatFontWithString:fontString];
    
    NSString *layoutKey = [layoutInfo objectForKey:@"layout"];
    NSInteger layoutType = (nil == layoutKey) ? MFLayoutTypeNone:[MFHelper formatLayoutWithString:layoutKey];
    
    CGRect frame;
    NSString *frameString = [MFHelper getFrameStringWithStyle:layoutInfo];
    if (MFLayoutTypeNone == layoutType) {
        frame = [MFHelper formatRectWithString:frameString parentFrame:parentFrame];
    }else if (MFLayoutTypeAbsolute == layoutType) {
        frame = [MFHelper formatAbsoluteRectWithString:frameString];
    }else if (MFLayoutTypeStretch == layoutType) {
        frame = [MFHelper formatFitRectWithString:frameString];
    }
    
    return [MFHelper sizeWithFont:dataSource font:font size:frame.size];
}

@end
