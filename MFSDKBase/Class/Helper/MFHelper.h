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
+ (CGSize)sizeWithFont:(NSString*)text font:(UIFont*)font size:(CGSize)size;
+ (NSString*)getPowerSearchPath;
+ (NSString*)getResourcePath;
+ (BOOL)deleteExistFile:(NSString *)strFileName;
+ (BOOL)copyFile:(NSString*)strSource strDim:(NSString*)strDim;
+ (BOOL)copyDirectory:(NSString *)source dim:(NSString *)dim;
+ (BOOL)isDirectory:(NSString *)strDirectory;
+ (BOOL)isExistDirectory:(NSString *)strDirectory;
+ (BOOL)isExistFile:(NSString *)strFileName;

+ (UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size;
+ (CGRect)imageFitRect:(CGRect)aInRect aImageSize:(CGSize)aImageSize;
+ (NSString*)getBundleName;
+ (NSString*)getFrameStringWithStyle:(NSDictionary*)styleDict;
+ (CGRect)formatRectWithString:(NSString*)rectString;
+ (CGRect)formatRectWithString:(NSString*)rectString parentFrame:(CGRect)frame;

+ (MFAlignmentType)formatAlignmentWithString:(NSString*)alignmentString;
+ (NSTextAlignment)formatTextAlignmentWithString:(NSString*)textAlignmentString;
+ (NSNumber*)formatSideWithString:(NSString*)side;
+ (NSNumber*)formatTouchEnableWithString:(NSString*)touchEnable;
+ (NSNumber*)formatVisibilityWithString:(NSString*)visibility;
+ (UIFont*)formatFontWithString:(NSString*)font;
+ (MFLayoutType)formatLayoutWithString:(NSString*)layout;
+ (NSString*)formatDate:(NSDate*)date;
+ (NSString*)formateTimeInterval:(NSTimeInterval)timecontent;
+ (CGRect)fitRect:(CGRect)rect;
+ (CGRect)formatFitRectWithString:(NSString*)rectString;
+ (CGRect)formatAbsoluteRectWithString:(NSString*)amlString;
+ (BOOL)sameRect:(CGRect)rect withRect:(CGRect)withRect;
+ (BOOL)isCompositeTemplate:(NSString*)templateId;
+ (BOOL)isURLString:(NSString*)urlString;

+ (NSInteger)sectionHeight;
+ (NSInteger)cellFooterHeight;
+ (NSInteger)cellHeaderHeight;
+ (BOOL)sizeZero:(CGSize)size;
+ (NSString*)sectionHeaderKey:(NSString*)sourceKey;
+ (NSString*)sectionFooterKey:(NSString*)sourceKey;
+ (int)dayAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate;
+ (int)yearAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate;
@end
