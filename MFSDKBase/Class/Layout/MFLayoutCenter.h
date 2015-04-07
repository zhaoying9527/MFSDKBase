//
//  MFLayoutCenter.h

#import <UIKit/UIKit.h>
#import "MFDefine.h"

@class HTMLNode;

@interface MFLayoutCenter : NSObject
@property (nonatomic,assign)CGSize screenXY;
@property (nonatomic,assign)CGFloat factor;
@property (nonatomic,assign)CGSize  canvasSize;
@property (nonatomic,assign)NSInteger compensateWidth;

SYNTHESIZE_SINGLETON_FOR_HEADER(MFLayoutCenter)
- (NSDictionary*)getLayoutInfoForPage:(HTMLNode*)pageNode
                           templateId:(NSString *)templateId
                            styleDict:(NSDictionary*)styleDict
                             dataDict:(NSDictionary*)dataDict
                          dataBinding:(NSDictionary*)dataBindingDict
                      parentViewFrame:(CGRect)parentViewFrame
                        retWidgetInfo:(NSMutableDictionary *)widgetInfo;
- (CGRect)absoluteRect:(CGRect)rect;
- (CGRect)stretchRect:(CGRect)rect;
- (NSInteger)round:(CGFloat)floatVal;
- (void)removeAll;
@end
