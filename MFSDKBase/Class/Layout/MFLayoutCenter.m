//
//  MFLayoutCenter.m

#import "HTMLNode.h"
#import "MFLayoutCenter.h"
#import "MFSceneFactory.h"
#import "MFHelper.h"
#import "MFDOM.h"
#import "NSObject+DOM.h"
#import "UIView+UUID.h"

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

- (NSDictionary*)sizeOfDom:(MFDOM*)dom superDomFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource
{
    NSMutableDictionary *widgetsInfo = [NSMutableDictionary dictionary];
    CGRect domframe = [self layoutInfoOfDom:dom superDomFrame:superFrame dataSource:dataSource retWidgets:widgetsInfo];
    NSDictionary * retDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@(domframe.size.height), KEY_WIDGET_HEIGHT,
                                    @(domframe.size.width), KEY_WIDGET_WIDTH, widgetsInfo, KEY_WIDGET_SIZE, nil];
    return retDictionary;
}

- (CGRect)layoutInfoOfDom:(MFDOM*)dom superDomFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource retWidgets:(NSMutableDictionary*)widgetsInfo
{
    NSString *clsType = [dom.clsType lowercaseString];
    NSString *domID = dom.uuid;
    NSString *dataKey = dom.bindingField;
    NSDictionary *cssItem = dom.cssNodes;
    
    NSString *layoutKey = cssItem[@"layout"];
    NSInteger layoutType = (nil == layoutKey) ? MFLayoutTypeNone:[MFHelper formatLayoutWithString:layoutKey];
    NSString *pageFrameStr = [MFHelper getFrameStringWithCssStyle:cssItem];
    CGRect pageFrame = [MFHelper formatFrameWithString:pageFrameStr layoutType:layoutType superFrame:superFrame];
    CGSize realSize = CGSizeZero;

    if ([MFHelper isKindOfLabel:clsType]) {
        NSString *multiLineStr = cssItem[KEYWORD_NUMBEROFLINES];
        if (nil != multiLineStr && [MFHelper supportMultiLine:multiLineStr]) {
            //emoji格式化
            //TODO dataSource = [dataSource[dataKey] ubb2unified];

            NSString *defaultText = [dom.htmlNodes getAttributeNamed:@"value"];
            NSString *realDataValue = dataSource[dataKey] ? dataSource[dataKey] : defaultText;
            realSize = [self sizeOfLabelWithDataSource:cssItem dataSource:realDataValue superFrame:superFrame];
        }
    } else if ([MFHelper isKindOfImage:clsType]) {
        realSize = [self imageSizeWithDataInfo:dataSource dataItems:dataSource[dataKey]];
    }

    if (realSize.width > 0 && realSize.height > 0) {
        if (realSize.height <= pageFrame.size.height) {
            realSize = pageFrame.size;
        }
    } else {
        realSize = pageFrame.size;
    }
    pageFrame.size.width = realSize.width;
    pageFrame.size.height = realSize.height;
    CGSize pageSize = pageFrame.size;

    NSMutableDictionary *childWidgetsInfo = [NSMutableDictionary dictionary];
    for (MFDOM *subDom in dom.subDoms) {
        CGRect childFrame = [self layoutInfoOfDom:subDom superDomFrame:pageFrame dataSource:dataSource retWidgets:widgetsInfo];
        NSString *subDomID = [subDom.htmlNodes getAttributeNamed:KEYWORD_ID];
        [childWidgetsInfo setObject:[NSValue valueWithCGRect:childFrame] forKey:subDomID];
    }

    CGSize fitSize = [self fitPageSize:childWidgetsInfo maxSize:pageSize];
    [widgetsInfo addEntriesFromDictionary:childWidgetsInfo];
    if (!((fitSize.width == pageSize.width) && (fitSize.height == pageSize.height))) {
        pageFrame.size = fitSize;
    }
    [widgetsInfo setObject:[NSValue valueWithCGRect:pageFrame] forKey:domID];

    return pageFrame;
}

- (void)layout:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo
{
    if (![view UUID]) {
        return;
    }
    
    CGRect rectValue = [sizeInfo[KEY_WIDGET_SIZE][view.UUID] CGRectValue];
    view.frame = rectValue;

    for (UIView *subView in view.subviews) {
        [self layout:subView withSizeInfo:sizeInfo];
    }
}

- (CGSize)imageSizeWithDataInfo:(NSDictionary*)dataInfo dataItems:(NSString*)dataItems
{
    CGSize retSize = CGSizeMake(0, 0);
    NSDictionary *data = dataInfo;
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

- (CGSize)sizeOfLabelWithDataSource:(NSDictionary*)layoutInfo dataSource:(NSString*)dataSource superFrame:(CGRect)superFrame
{
    NSString *fontString = [layoutInfo objectForKey:@"font"];
    UIFont *font = [MFHelper formatFontWithString:fontString];

    NSString *layoutKey = [layoutInfo objectForKey:@"layout"];
    NSInteger layoutType = (nil == layoutKey) ? MFLayoutTypeNone:[MFHelper formatLayoutWithString:layoutKey];

    CGRect frame;
    NSString *frameString = [MFHelper getFrameStringWithCssStyle:layoutInfo];
    if (MFLayoutTypeNone == layoutType) {
        frame = [MFHelper formatRectWithString:frameString superFrame:superFrame];
    } else if (MFLayoutTypeAbsolute == layoutType) {
        frame = [MFHelper formatAbsoluteRectWithString:frameString];
    } else if (MFLayoutTypeStretch == layoutType) {
        frame = [MFHelper formatFitRectWithString:frameString];
    }

    return [MFHelper sizeWithFont:dataSource font:font size:frame.size];
}
@end
