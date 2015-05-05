//
//  MFHelper.h
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFDefine.h"

@class MFImageView;
@interface MFHelper : NSObject

+ (float)getOsVersion;
+ (CGSize)screenXY;

+ (UIColor*)colorWithString:(NSString *)stringToConvert;
+ (UIColor*)colorWithOctString:(NSString *)stringToConvert;
+ (UIColor*)colorWithHexString:(NSString *)stringToConvert;

+ (UIImage*)stretchableBannerCellImage:(UIImage*)image;
+ (UIImage*)stretchableCellImage:(UIImage*)image;
+ (UIImage*)resizeableLeftBgImage:(UIImage *)image;
+ (UIImage*)resizeableRightBgImage:(UIImage *)image;
+ (UIImage*)transStyleImageWithName:(NSString*)imageName;
+ (UIImage *)styleCenterImageWithId:(NSString*)imageId;
+ (UIImage*)styleLeftImageWithId:(NSString*)imageId;
+ (UIImage*)styleRightImageWithId:(NSString*)imageId;
+ (UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size;
+ (CGRect)imageFitRect:(CGRect)aInRect aImageSize:(CGSize)aImageSize;
+ (MFImageView*)createImageView;
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
+ (CGRect)formatFrameWithString:(NSString*)rectString superFrame:(CGRect)superFrame;
+ (CGRect)formatRectWithString:(NSString*)rectString;
+ (CGRect)formatRectWithString:(NSString*)rectString superFrame:(CGRect)frame;
+ (CGFloat)maxWidthWithCssStyle:(NSDictionary*)styleDict superFrame:(CGRect)superFrame;
+ (CGFloat)maxHeightWithCssStyle:(NSDictionary*)styleDict superFrame:(CGRect)superFrame;
+ (BOOL)autoWidthTypeWithCssStyle:(NSDictionary*)styleDict;
+ (BOOL)autoHeightTypeWithCssStyle:(NSDictionary*)styleDict;

+ (MFAlignmentType)formatAlignmentWithString:(NSString*)alignmentString;
+ (NSTextAlignment)formatTextAlignmentWithString:(NSString*)textAlignmentString;
+ (NSNumber*)formatTouchEnableWithString:(NSString*)touchEnable;
+ (NSNumber*)formatVisibilityWithString:(NSString*)visibility;
+ (UIFont*)formatFontWithString:(NSString*)font;
+ (UIImage *)formatImageWithString:(NSString*)imageUrl;
+ (NSNumber *)formatReverseWithString:(NSString*)reverse;
+ (BOOL)sameRect:(CGRect)rect withRect:(CGRect)withRect;

+ (NSString*)formatDate:(NSDate*)date;
+ (NSString*)formateTimeInterval:(NSTimeInterval)timecontent;
+ (int)dayAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate;
+ (int)yearAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate;

+ (BOOL)isCompositeTemplate:(NSString*)templateId;
+ (BOOL)isURLString:(NSString*)urlString;
+ (BOOL)isLocalResourceUrl:(NSString*)urlString;
+ (BOOL)isKindOfLabel:(NSString*)labelString;
+ (BOOL)isKindOfTips:(NSString*)string;
+ (BOOL)isKindOfImage:(NSString*)imageString;
+ (BOOL)isKindOfAudio:(NSString*)audioString;
+ (BOOL)supportMultiLine:(NSString*)string;

+ (NSInteger)sectionHeight;
+ (NSInteger)cellFooterHeight;
+ (NSInteger)cellHeaderHeight;
+ (NSString*)sectionHeaderKey:(NSString*)sourceKey;
+ (NSString*)sectionFooterKey:(NSString*)sourceKey;
+ (BOOL)sizeZero:(CGSize)size;
@end
