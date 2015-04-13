//
//  MFLayoutCenter.h

#import <UIKit/UIKit.h>
#import "MFDefine.h"
#import "MFSDK.h"

@class MFDOM;
@interface MFLayoutCenter : NSObject
@property (nonatomic,assign)CGSize screenXY;
@property (nonatomic,assign)CGFloat factor;
@property (nonatomic,assign)CGSize canvasSize;
@property (nonatomic,assign)NSInteger compensateWidth;

SYNTHESIZE_SINGLETON_FOR_HEADER(MFLayoutCenter)
- (void)removeAll;
- (CGRect)stretchRect:(CGRect)rect;
- (CGRect)absoluteRect:(CGRect)rect;
- (NSInteger)round:(CGFloat)floatVal;
- (NSDictionary*)sizeOfDom:(MFDOM*)dom superDomFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource;
- (void)layout:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo;
- (void)sideSubViews:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo withAlignmentType:(MFAlignmentType)alignType;
- (void)reverseSubViews:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo;
@end
