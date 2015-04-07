//
//  MFChatLayoutCenter.m

#import "MFChatLayoutCenter.h"
#import "MFHelper.h"
#import "MFDefine.h"

@interface MFChatLayoutCenter ()

@end

@implementation MFChatLayoutCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFChatLayoutCenter)

- (instancetype)init
{
    if (self = [super init]) {
        self.factor = (self.screenXY.width / STANDARD_WIDTH - 1.0);
    }
    return self;
}

- (CGSize)fitCellSize:(NSDictionary*)widgetSizeDict maxSize:(CGSize)maxSize
{
    CGSize size = CGSizeMake(0, 0);
    for (NSString *key in [widgetSizeDict allKeys]) {
        CGRect rect = [[widgetSizeDict objectForKey:key] CGRectValue] ;
        if (size.height < rect.origin.y + rect.size.height) {
            size.height = rect.origin.y + rect.size.height;
        }
        if (size.width < rect.origin.x + rect.size.width) {
            size.width = rect.origin.x + rect.size.width;
        }
    }
    
    CGRect firstWidgetRect = [[widgetSizeDict objectForKey:@"1"] CGRectValue];
    if (size.height > maxSize.height) {
        size.height += (firstWidgetRect.origin.y<12)?firstWidgetRect.origin.y:12;
    }else {
        size.height = maxSize.height;
    }
    
    if (size.width < (maxSize.width-firstWidgetRect.origin.x)) {
        size.width += (firstWidgetRect.origin.x<12)?firstWidgetRect.origin.x:12;;
    }else {
        size.width = maxSize.width;
    }
    
    return CGSizeMake(size.width, size.height);
}

//TODO

//
//- (CGRect)autoLayoutWithStyleDict:(NSDictionary*)styleItem
//{
//    CGRect retRect = CGRectZero;
//    
//    NSString *frameStr = [MFHelper getFrameStringWithStyle:styleItem];
//    NSString *layoutKey = [styleItem objectForKey:@"layout"];
//    NSInteger layoutType = (nil == layoutKey)?MFLayoutTypeNone:[MFHelper formatLayoutWithString:layoutKey];
//
//    if (MFLayoutTypeStretch == layoutType) {
//        retRect = [self formatRectWithStyleString:frameStr fit:YES];
//    }else if (MFLayoutTypeAbsolute == layoutType) {
//        retRect = [self formatRectWithStyleString:frameStr fit:NO];
//    }else if (MFLayoutTypeNone == layoutType) {
//        retRect = [MFHelper formatRectWithString:frameStr];
//    }
//
//    return retRect;
//}
//
//- (CGSize)sizeofCellHeaderViewWithDataString:(NSString*)dataString
//{
//    CGSize maxSize = CGSizeMake(250+self.compensateWidth, 1000);
//    CGSize size = [MFHelper sizeWithFont:dataString font:[UIFont systemFontOfSize:cellHeaderFontSize] size:maxSize];
//    size.width += 3*tipsspace;
//    size.height += tipsspace;
//    return size;
//}
//
//- (CGSize)sizeofCellFooterViewWithDataString:(NSString*)dataString
//{
//    CGSize maxSize = CGSizeMake(250+self.compensateWidth, 100);
//    CGSize size = [MFHelper sizeWithFont:dataString font:[UIFont systemFontOfSize:cellFooterFontSize] size:maxSize];
//    size.width += 3*tipsspace;
//    size.height += tipsspace;
//    return size;
//}
//
//- (NSDictionary*)sizeofCell:(NSString*)cellId dataDict:(NSDictionary*)dataDict cellDict:(NSDictionary*)cellDict
//{
//    MFStrategyCenter * strategyCenter = [MFStrategyCenter sharedMFStrategyCenter];
//    NSMutableDictionary *sumRectDictionary = [[NSMutableDictionary alloc] init];
//    NSInteger subHeight = 0;
//    //参数获取
//    NSDictionary *viewItems = [cellDict objectForKey:KEY_NODE_VIEWS];
//    NSDictionary *propertieItems = [cellDict objectForKey:KEY_NODE_PROPERTIES];
//    NSString  *viewFrameString = [propertieItems objectForKey:KEYWORD_FRAME];
//    //注册画布尺寸
//    [self canvasSizeWithStyleString:viewFrameString];
//    CGSize pageSize = [self autoLayoutWithStyleDict:propertieItems].size;
//    NSString *key = nil;
//    for (int i = 1; i <= [[viewItems allKeys] count]; i++) {
//        key = [NSString stringWithFormat:@"%d",i];
//        CGRect widgetFrame = CGRectZero;
//        CGSize realSize = CGSizeZero;
//        NSDictionary *dataItems = [strategyCenter itemWithID:key subItemID:KEY_NODE_DATA source:viewItems];
//        NSDictionary *layoutItem = [strategyCenter itemWithID:key subItemID:KEY_NODE_UI source:viewItems];
//        NSString *type = [[layoutItem objectForKey:KEYWORD_TYPE] lowercaseString];
//        widgetFrame = [self autoLayoutWithStyleDict:layoutItem];
//
//        widgetFrame.origin.y += subHeight;
//        if ([MFScriptHelper isKindOfLabel:type]) {
//            NSString *amlMultiLineStr = [layoutItem objectForKey:KEYWORD_NUMBEROFLINES];
//            if ([MFScriptHelper supportMultiLine:amlMultiLineStr]) {
//                NSDictionary *data = [dataDict objectForKey:KEYWORD_DS_DATA];
//                NSString *dataSource = [data objectForKey:[dataItems objectForKey:KEYWORD_DATASOURCEKEY]];
//                //emoji格式化
//                //TODO dataSource = [dataSource ubb2unified];
//                realSize = [MFScriptHelper sizeOfLabelWithDataSource:layoutItem dataSource:dataSource];
//            }
//        }else if ([MFScriptHelper isKindOfImage:type]) {
//            realSize = [self imageSizeWithDataInfo:dataDict dataItems:dataItems];
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
//        [sumRectDictionary setObject:[NSValue valueWithCGRect:widgetFrame] forKey:key];
//    }
//    
//    CGSize fitSize = [self fitCellSize:sumRectDictionary maxSize:pageSize];
//  
//    NSDictionary * retDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                    [NSNumber numberWithInteger:fitSize.height],KEY_WIDGET_HEIGHT,
//                                    [NSNumber numberWithInteger:fitSize.width],KEY_WIDGET_WIDTH,
//                                    sumRectDictionary,KEY_WIDGET_SIZE,nil];
//
//    return   retDictionary;
//}
@end
