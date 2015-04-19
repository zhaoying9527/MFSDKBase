//
//  MFLayoutCenter.h

#import <UIKit/UIKit.h>
#import "MFDefine.h"
#import "MFSDK.h"

@class MFDOM;
@interface MFLayoutCenter : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(MFLayoutCenter)
- (NSInteger)round:(CGFloat)floatVal;
- (CGRect)roundWithRect:(CGRect)rect;

- (NSDictionary*)sizeOfHeadDom:(MFDOM*)dom superDomFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource;
- (NSDictionary*)sizeOfBodyDom:(MFDOM*)dom superDomFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource;
- (NSDictionary*)sizeOfFootDom:(MFDOM*)dom superDomFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource;

- (void)layout:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo;
- (void)sideSubViews:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo withAlignmentType:(MFAlignmentType)alignType;
- (void)reverseSubViews:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo;
@end
