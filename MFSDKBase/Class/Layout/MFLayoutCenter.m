//
//  MFLayoutCenter.m

#import "HTMLNode.h"
#import "MFLayoutCenter.h"
#import "MFSceneFactory.h"
#import "MFSceneCenter.h"
#import "MFHelper.h"
#import "MFDOM.h"
#import "MFVirtualNode.h"
#import "NSObject+VirtualNode.h"
#import "UIView+MFHelper.h"
#import "MFLabel.h"
#import "MFRichLabel.h"
#import "MFImageView.h"


#import "MFCloudImageView.h"
#import "UIView+Sizes.h"

@implementation MFLayoutCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFLayoutCenter)
- (instancetype)init
{
    self = [super init];
    return self;
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
    }else {
        size.height = maxSize.height;
    }
    if (size.width > maxSize.width) {
        size.width += (minWidgetLeft<12)?minWidgetLeft:12;
    }else {
        size.width = maxSize.width;
    }

    return CGSizeMake(size.width, size.height);
}

- (NSDictionary*)sizeOfHeadNode:(MFVirtualNode*)node superFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource
{
    NSString *dataKey           = node.dom.bindingField;
    NSString *dataString        = dataSource[dataKey];
    CGSize maxSize              = CGSizeMake(superFrame.size.width-70, 1000);
    CGSize size                 = CGSizeZero;
    if (dataString) {
        size = [MFHelper sizeWithFont:dataString font:[UIFont systemFontOfSize:MFCellHeaderFontSize] size:maxSize];
        size.width += 3*MFTipsWidthSpace;
        size.height += MFTipsHeightSpace;
    }
    CGRect domFrame = CGRectMake(0, 0, size.width, size.height);

    NSDictionary *retDictionary = nil;
    NSString *domID = node.dom.uuid;
    if (domID) {
        NSMutableDictionary *widgetsInfo = [NSMutableDictionary dictionaryWithObject:[NSValue valueWithCGRect:domFrame] forKey:domID];
        retDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@(domFrame.size.height), MF_KEY_WIDGET_HEIGHT,
                         @(domFrame.size.width), MF_KEY_WIDGET_WIDTH, widgetsInfo, MF_KEY_WIDGET_SIZE, nil];
    }
    node.widgetSize = size;
    node.frame = domFrame;
    
    return retDictionary;
}

- (NSDictionary*)sizeOfFootNode:(MFVirtualNode*)node superFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource
{
    NSString *dataKey           = node.dom.bindingField;
    NSString *dataString        = dataSource[dataKey];
    CGSize maxSize              = CGSizeMake(superFrame.size.width-70, 1000);
    CGSize size                 = CGSizeZero;
    if (dataString) {
        size = [MFHelper sizeWithFont:dataString font:[UIFont systemFontOfSize:MFCellFooterFontSize] size:maxSize];
        size.width += 3*MFTipsWidthSpace;
        size.height += MFTipsHeightSpace;
    }
    CGRect domFrame = CGRectMake(0, 0, size.width, size.height);
    
    NSDictionary * retDictionary = nil;
    NSString *domID = node.dom.uuid;
    if (domID) {
        NSMutableDictionary *widgetsInfo = [NSMutableDictionary dictionaryWithObject:[NSValue valueWithCGRect:domFrame] forKey:domID];
        retDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@(domFrame.size.height), MF_KEY_WIDGET_HEIGHT,
                         @(domFrame.size.width), MF_KEY_WIDGET_WIDTH, widgetsInfo, MF_KEY_WIDGET_SIZE, nil];
    }
    node.widgetSize = size;
    node.frame = domFrame;

    return retDictionary;
}

- (NSDictionary*)sizeOfBodyNode:(MFVirtualNode*)node superFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource
{
    NSMutableDictionary *widgetsInfo = [NSMutableDictionary dictionary];
    CGRect domFrame = [self layoutInfoOfNode:node superFrame:superFrame dataSource:dataSource retWidgets:widgetsInfo];
    NSDictionary *retDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@(domFrame.size.height), MF_KEY_WIDGET_HEIGHT,
                                    @(domFrame.size.width), MF_KEY_WIDGET_WIDTH, widgetsInfo, MF_KEY_WIDGET_SIZE, nil];
    node.widgetSize = domFrame.size;
    node.frame = domFrame;

    return retDictionary;
}

- (CGRect)layoutInfoOfNode:(MFVirtualNode*)node superFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource retWidgets:(NSMutableDictionary*)widgetsInfo
{
    MFDOM *dom = node.dom;
    NSString *domID        = dom.uuid;
    NSDictionary *cssItem  = dom.cssNodes;
    NSString *dataKey      = dom.bindingField;
    NSString *clsType      = [dom.clsType lowercaseString];
    
    BOOL autoWidth         = [MFHelper autoWidthTypeWithCssStyle:cssItem];
    BOOL autoHeight        = [MFHelper autoHeightTypeWithCssStyle:cssItem];
    NSString *pageFrameStr = [MFHelper getFrameStringWithCssStyle:cssItem];
    CGRect pageFrame       = [MFHelper formatFrameWithString:pageFrameStr superFrame:superFrame];
    CGFloat maxWidth       = [MFHelper maxWidthWithCssStyle:cssItem superFrame:(CGRect)superFrame];
    CGFloat maxHeight      = [MFHelper maxHeightWithCssStyle:cssItem superFrame:(CGRect)superFrame];
    CGSize realSize        = CGSizeZero;
    
    NSDictionary *dataDict = dataSource;
    NSString *multiLineStr = cssItem[MF_KEYWORD_NUMBEROFLINES];
    if ([MFHelper isKindOfLabel:clsType] && [MFHelper supportMultiLine:multiLineStr]) {
        //emoji格式化
        //NSString *labelText = [dataDict[dataKey] ubb2unified];
        NSString *labelText = dataDict[dataKey];
        NSString *defaultText = [dom.htmlNodes getAttributeNamed:@"value"];
        NSString *realText = labelText ? labelText : defaultText;
        realSize = [self sizeOfLabelWithDataSource:cssItem dataSource:realText superFrame:superFrame];
    }else if ([MFHelper isKindOfImage:clsType]) {
        realSize = [self imageSizeWithDataInfo:dataDict dataItems:dataDict[dataKey]];
    }else if ([MFHelper isKindOfAudio:clsType]) {
        realSize = [self audioSizeWithDataInfo:dataDict dataItems:dataDict[dataKey] superFrame:superFrame];
    }
    
    realSize.width         = autoWidth? MIN(realSize.width, maxWidth) : MAX(realSize.width, pageFrame.size.width);
    realSize.height        = autoHeight ? MIN(realSize.height, maxHeight) : MAX(realSize.height, pageFrame.size.height);
    
    pageFrame.size.width   = realSize.width;
    pageFrame.size.height  = realSize.height;
    CGSize pageSize        = pageFrame.size;
    NSInteger subWidth     = 0;
    NSInteger subHeight    = 0;
    
    NSMutableDictionary *childWidgetsInfo = [NSMutableDictionary dictionary];
    NSArray *sortedNodes = [self resortNodes:node.subNodes];
    for (MFVirtualNode *subNode in sortedNodes) {
        NSString *childFrameStr = [MFHelper getFrameStringWithCssStyle:subNode.dom.cssNodes];
        CGRect childFrame = [MFHelper formatFrameWithString:childFrameStr superFrame:pageFrame];
        CGRect maxSuperFrame = CGRectMake(pageFrame.origin.x, pageFrame.origin.y,
                                          realSize.width>0?realSize.width:maxWidth,
                                          realSize.height>0?realSize.height:maxHeight);
        CGRect childRealFrame = [self layoutInfoOfNode:subNode superFrame:maxSuperFrame dataSource:dataSource retWidgets:widgetsInfo];
        childRealFrame.origin.y += subHeight;
        childRealFrame.origin.x += subWidth;
        
        NSInteger deltaHeight = childRealFrame.size.height - childFrame.size.height;
        subHeight += autoHeight ? deltaHeight : MAX(0, deltaHeight);
        NSInteger deltaWidth = childRealFrame.size.width - childFrame.size.width;
        subWidth += autoWidth ? deltaWidth : MAX(0, deltaWidth);
        
        NSString *subDomID = [subNode.dom.htmlNodes getAttributeNamed:MF_KEYWORD_ID];
        [childWidgetsInfo setObject:[NSValue valueWithCGRect:childRealFrame] forKey:subDomID];
        
        subNode.widgetSize = childRealFrame.size;
        subNode.frame = childRealFrame;
    }
    
    CGSize fitSize = [self fitPageSize:childWidgetsInfo maxSize:pageSize];
    [widgetsInfo addEntriesFromDictionary:childWidgetsInfo];
    if (!((fitSize.width == pageSize.width) && (fitSize.height == pageSize.height))) {
        pageFrame.size = fitSize;
    }
    [widgetsInfo setObject:[NSValue valueWithCGRect:pageFrame] forKey:domID];
    node.widgetSize = pageFrame.size;
    node.frame = pageFrame;
    
    return pageFrame;
}

- (NSArray*)resortNodes:(NSArray*)nodes
{
    NSArray *sortedArray = [nodes sortedArrayUsingComparator:^NSComparisonResult(MFVirtualNode *node1, MFVirtualNode *node2) {
        NSInteger order1 = node1.dom.cssNodes[@"order"] ? [node1.dom.cssNodes[@"order"] intValue] : INT32_MAX;
        NSInteger order2 = node2.dom.cssNodes[@"order"] ? [node2.dom.cssNodes[@"order"] intValue] : INT32_MAX;
        if (order1 > order2) {
            return NSOrderedDescending;
        }else if (order1 == order2) {
            return NSOrderedSame;
        }else {
            return NSOrderedAscending;
        }
    }];
    return sortedArray;
}

- (void)layout:(MFVirtualNode*)node
{
    if (![node.objRef MFUUID]) {
        return;
    }

    CGRect rectValue = node.frame;
    node.objRef.frame = rectValue;

    for (MFVirtualNode *subNode in node.subNodes) {
        [self layout:subNode];
    }
}

- (void)sideSubViews:(MFVirtualNode*)node withAlignmentType:(MFAlignmentType)alignType
{
    if (![node.objRef MFUUID]) {
        return;
    }
    
    [[MFSceneFactory sharedMFSceneFactory] setProperty:node.objRef popertyName:@"alignmentType" withObject:@(alignType)];
    BOOL side = [[[MFSceneFactory sharedMFSceneFactory] getProperty:node.objRef popertyName:@"side"] boolValue];
    BOOL reverse = [[[MFSceneFactory sharedMFSceneFactory] getProperty:node.objRef popertyName:@"reverse"] boolValue];
    NSInteger alignmentType = [[[MFSceneFactory sharedMFSceneFactory] getProperty:node.objRef popertyName:@"alignmentType"] integerValue];
    
    CGRect rawRect = node.frame;
    CGRect superRect = node.superNode ? node.superNode.frame : node.objRef.superview.frame;
    
    if (MFAlignmentTypeLeft == alignmentType || MFAlignmentTypeNone == alignmentType) {
        
    }else if (MFAlignmentTypeCenter == alignmentType) {
        CGRect rect = rawRect;
        rect.origin.x = (superRect.size.width - rect.size.width)/2;
        if (![MFHelper sameRect:node.frame withRect:rect]) {
            node.objRef.frame = rect;
        }
    }else if (MFAlignmentTypeRight == alignmentType) {
        CGRect rect = rawRect;
        if (side) {
            if (!reverse) {
                rect.origin.x = superRect.size.width - rect.origin.x - rect.size.width;
            }
        }else {
            if (rect.origin.x>=7) {
                rect.origin.x -= 7;
            }
        }
        
        if (![MFHelper sameRect:node.frame withRect:rect]) {
            node.objRef.frame = rect;
        }
    }

    
    if ([node.objRef respondsToSelector:@selector(alignHandling)]) {
        [(id)node.objRef alignHandling];
    }
    
    for (MFVirtualNode *subNode in node.subNodes) {
        [self sideSubViews:subNode withAlignmentType:alignType];
    }
}

- (void)reverseSubViews:(MFVirtualNode*)node
{
    if (![node.objRef MFUUID]) {
        return;
    }
    
    BOOL side = [[[MFSceneFactory sharedMFSceneFactory] getProperty:node.objRef popertyName:@"side"] boolValue];
    BOOL reverseType = [[[MFSceneFactory sharedMFSceneFactory] getProperty:node.objRef popertyName:@"reverse"] boolValue];
    NSInteger alignmentType = [[[MFSceneFactory sharedMFSceneFactory] getProperty:node.objRef popertyName:@"alignmentType"] integerValue];
    if (reverseType && side && MFAlignmentTypeRight == alignmentType) {
        if ([node.objRef respondsToSelector:@selector(reverseHandling)]) {
            [(id)node.objRef reverseHandling];
        }
    }
    
    for ( MFVirtualNode *subNode in node.subNodes) {
        [self reverseSubViews:subNode];
    }
}

- (CGSize)audioSizeWithDataInfo:(NSDictionary*)dataInfo dataItems:(NSString*)dataItems superFrame:(CGRect)superFrame
{
    CGFloat audioLen = 35;
    NSDictionary *data = dataInfo;
    CGFloat lenght = [[data objectForKey:@"l"] floatValue];

    if (lenght > 0) {
        audioLen += lenght*2.0 + (30-lenght)*0.01;
    }

    return CGSizeMake(audioLen, 0);
}

- (CGSize)imageSizeWithDataInfo:(NSDictionary*)dataInfo dataItems:(NSString*)dataItems
{
    CGSize retSize = CGSizeMake(0, 0);
    NSDictionary *data = dataInfo;
    CGFloat width = [[data objectForKey:@"w"] floatValue];
    CGFloat height = [[data objectForKey:@"h"] floatValue];
    
    if (width > 0.0f && height > 0.0f) {
        retSize = [self fitImageSize:CGSizeMake(width, height)];
    }
    return retSize;
}

- (CGSize)fitImageSize:(CGSize)imageSize
{
    if (imageSize.width < MF_IMAGEWIDTH && imageSize.height < MF_IMAGEHEIGHT) {
        return  imageSize;
    }
    CGRect rect = CGRectMake(0, 0, MF_IMAGEWIDTH, MF_IMAGEHEIGHT);
    CGRect retRect = [MFHelper imageFitRect:rect aImageSize:imageSize];
    return retRect.size;
}

- (CGSize)sizeOfLabelWithDataSource:(NSDictionary*)layoutInfo dataSource:(NSString*)dataSource superFrame:(CGRect)superFrame
{
    NSString *fontString = [layoutInfo objectForKey:@"font"];
    UIFont *font = [MFHelper formatFontWithString:fontString];

    CGRect frame = CGRectZero;
    NSString *frameString = [MFHelper getFrameStringWithCssStyle:layoutInfo];
    frame = [MFHelper formatRectWithString:frameString superFrame:superFrame];

    return [MFHelper sizeWithFont:dataSource font:font size:frame.size];
}
@end
