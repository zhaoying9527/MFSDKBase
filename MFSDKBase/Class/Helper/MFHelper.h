//
//  MFHelper.h
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFDefine.h"

@interface MFHelper : NSObject

+ (float)getOsVersion;
+ (CGSize)screenXY;

+ (UIColor*)colorWithOctString:(NSString *)stringToConvert;
+ (UIColor*)colorWithString:(NSString *)stringToConvert;
+ (UIColor*)colorWithHexString:(NSString *)stringToConvert;

+ (UIImage*)stretchableBannerCellImage:(UIImage*)image;
+ (UIImage*)stretchableCellImage:(UIImage*)image;
+ (UIImage*)resizeableLeftBgImage:(UIImage *)image;
+ (UIImage*)resizeableRightBgImage:(UIImage *)image;
+ (UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size;
+ (CGRect)imageFitRect:(CGRect)aInRect aImageSize:(CGSize)aImageSize;
+ (CGSize)sizeWithFont:(NSString*)text font:(UIFont*)font size:(CGSize)size;

+ (NSString*)getBundleName;
+ (NSString*)getPowerSearchPath;
+ (NSString*)getResourcePath;
+ (BOOL)deleteExistFile:(NSString *)strFileName;
+ (BOOL)copyFile:(NSString*)strSource strDim:(NSString*)strDim;
+ (BOOL)copyDirectory:(NSString *)source dim:(NSString *)dim;
+ (BOOL)isDirectory:(NSString *)strDirectory;
+ (BOOL)isExistDirectory:(NSString *)strDirectory;
+ (BOOL)isExistFile:(NSString *)strFileName;

+ (NSString*)getFrameStringWithCssStyle:(NSDictionary*)styleDict;
+ (CGRect)formatFrameWithString:(NSString*)rectString layoutType:(MFLayoutType)layout superFrame:(CGRect)superFrame;
+ (CGRect)formatRectWithString:(NSString*)rectString;
+ (CGRect)formatRectWithString:(NSString*)rectString superFrame:(CGRect)frame;

+ (MFAlignmentType)formatAlignmentWithString:(NSString*)alignmentString;
+ (NSTextAlignment)formatTextAlignmentWithString:(NSString*)textAlignmentString;
+ (NSNumber*)formatSideWithString:(NSString*)side;
+ (NSNumber*)formatTouchEnableWithString:(NSString*)touchEnable;
+ (NSNumber*)formatVisibilityWithString:(NSString*)visibility;
+ (UIFont*)formatFontWithString:(NSString*)font;
+ (UIImage *)formatImageWithString:(NSString*)imageUrl;
+ (MFLayoutType)formatLayoutWithString:(NSString*)layout;
+ (NSNumber *)formatreverseWithString:(NSString*)reverse;

+ (NSString*)formatDate:(NSDate*)date;
+ (NSString*)formateTimeInterval:(NSTimeInterval)timecontent;
+ (int)dayAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate;
+ (int)yearAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate;

+ (CGRect)fitRect:(CGRect)rect;
+ (CGRect)formatFitRectWithString:(NSString*)rectString;
+ (CGRect)formatAbsoluteRectWithString:(NSString*)amlString;
+ (BOOL)sameRect:(CGRect)rect withRect:(CGRect)withRect;

+ (BOOL)isCompositeTemplate:(NSString*)templateId;
+ (BOOL)isURLString:(NSString*)urlString;
+ (BOOL)isKindOfLabel:(NSString*)labelString;
+ (BOOL)isKindOfTips:(NSString*)string;
+ (BOOL)isKindOfImage:(NSString*)imageString;
+ (BOOL)supportMultiLine:(NSString*)string;

+ (NSInteger)sectionHeight;
+ (NSInteger)cellFooterHeight;
+ (NSInteger)cellHeaderHeight;
+ (BOOL)sizeZero:(CGSize)size;
+ (NSString*)sectionHeaderKey:(NSString*)sourceKey;
+ (NSString*)sectionFooterKey:(NSString*)sourceKey;

+ (BOOL)isAdd:(UIView*)superView subView:(UIView*)subView;
@end
