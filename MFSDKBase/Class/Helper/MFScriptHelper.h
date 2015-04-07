//
//  MFScriptHelper.h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MFScriptHelper : NSObject
+ (BOOL)isKindOfLabel:(NSString*)labelString;
+ (BOOL)isKindOfImage:(NSString*)imageString;
+ (BOOL)supportMultiLine:(NSString*)string;
+ (CGSize)sizeOfLabelWithDataSource:(NSDictionary*)layoutInfo dataSource:(NSString*)dataSource parentFrame:(CGRect)parentFrame;
@end
