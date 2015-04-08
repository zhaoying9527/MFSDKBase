//
//  MFScriptHelper.m
//

#import "MFScriptHelper.h"
#import "MFHelper.h"
#import "MFDefine.h"
@implementation MFScriptHelper
+ (CGSize)sizeOfLabelWithDataSource:(NSDictionary*)layoutInfo dataSource:(NSString*)dataSource parentFrame:(CGRect)parentFrame
{
    NSString *fontString = [layoutInfo objectForKey:@"font"];
    UIFont *font = [MFHelper formatFontWithString:fontString];

    NSString *layoutKey = [layoutInfo objectForKey:@"layout"];
    NSInteger layoutType = (nil == layoutKey) ? MFLayoutTypeNone:[MFHelper formatLayoutWithString:layoutKey];

    CGRect frame;
    NSString *frameString = [MFHelper getFrameStringWithStyle:layoutInfo];
    if (MFLayoutTypeNone == layoutType) {
        frame = [MFHelper formatRectWithString:frameString parentFrame:parentFrame];
    }else if (MFLayoutTypeAbsolute == layoutType) {
        frame = [MFHelper formatAbsoluteRectWithString:frameString];
    }else if (MFLayoutTypeStretch == layoutType) {
        frame = [MFHelper formatFitRectWithString:frameString];
    }

    return [MFHelper sizeWithFont:dataSource font:font size:frame.size];
}

+ (BOOL)supportMultiLine:(NSString*)string
{
    NSInteger numberOfLines = [string integerValue];
    if (numberOfLines==0) {
        return YES;
    }
    return NO;
}

+ (BOOL)isKindOfLabel:(NSString*)labelString
{
    BOOL retCode = NO;
    NSString *lowLabelString = [labelString lowercaseString];
    if ([lowLabelString isEqualToString:@"label"]
        || [lowLabelString isEqualToString:@"richlabel"]) {
        retCode = YES;
    }
    return retCode;
}
            
+ (BOOL)isKindOfImage:(NSString*)imageString
{
    BOOL retCode = NO;
    NSString *lowImageString = [imageString lowercaseString];
    if ([lowImageString isEqualToString:@"img"] || [lowImageString isEqualToString:@"emoji"]) {
        retCode = YES;
    }
    return retCode;
}
@end
