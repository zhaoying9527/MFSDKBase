//
//  MFHelper.m

#import "MFHelper.h"
#import "MFDefine.h"
#import "MFImageView.h"
#import "MFLayoutCenter.h"
#import "MFResourceCenter.h"

@implementation MFHelper

+ (float) getOsVersion {
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version ;
}

+ (CGSize)screenXY
{
    return [[UIScreen mainScreen] bounds].size;
}

+ (UIColor *)colorWithString:(NSString *)stringToConvert
{
    NSString *cString = [stringToConvert lowercaseString];
    if ([cString hasPrefix:@"rgb"]) {
        NSString *trimString = [cString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"rgb()"]];
        return [self colorWithOctString:trimString];
    } else if([cString hasPrefix:@"0X"] || [cString hasPrefix:@"#"]) {
        return [self colorWithHexString:cString];
    }

    UIColor *color = [UIColor clearColor];
    NSDictionary *colorMap = @{@"grey":[UIColor grayColor],
                               @"gray":[UIColor grayColor],
                               @"darkgray":[UIColor darkGrayColor],
                               @"lightgray":[UIColor lightGrayColor],
                               @"black":[UIColor blackColor],
                               @"white":[UIColor whiteColor],
                               @"red":[UIColor redColor],
                               @"blue":[UIColor blueColor],
                               @"green":[UIColor greenColor],
                               @"yellow":[UIColor yellowColor],
                               @"brown":[UIColor brownColor],
                               @"orange":[UIColor orangeColor]};
    if (colorMap[cString]) {
        color = colorMap[cString];
    }
    return color;
}

+ (UIColor *)colorWithOctString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    NSArray * components = [cString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"(,)"]];
    if ([components count] < 3) return [UIColor clearColor];

    NSString *rString = components[0];
    NSString *gString = components[1];
    NSString *bString = components[2];

    return [UIColor colorWithRed:((float) [rString integerValue] / 255.0f)
                           green:((float) [gString integerValue] / 255.0f)
                            blue:((float) [bString integerValue] / 255.0f)
                           alpha:1.0f];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (UIImage*)stretchableBannerCellImage:(UIImage*)image
{
    UIImage *retImage = image;
    //拉伸图片
    CGFloat capWidth = 5;//(int)image.size.width / 2;
    CGFloat capHeight = 5;//(int)image.size.height / 2;
    retImage = [image stretchableImageWithLeftCapWidth:capWidth topCapHeight:capHeight];
    return retImage;
}

+ (UIImage*)stretchableCellImage:(UIImage*)image
{
    UIImage *retImage = image;
    //拉伸图片
    CGFloat capWidth = (int)image.size.width / 2;
    CGFloat capHeight = (int)image.size.height / 2;
    retImage = [image stretchableImageWithLeftCapWidth:capWidth topCapHeight:capHeight];
    return retImage;
}

+ (UIImage *)resizeableLeftBgImage:(UIImage *)image
{
    if (nil == image) {
        return nil;
    }
    int capTop = (int)3 * image.size.height / 4;
    
    UIImage * retImage = [image stretchableImageWithLeftCapWidth:12 topCapHeight:capTop];
    return retImage;
}


+ (UIImage *)resizeableRightBgImage:(UIImage *)image
{
    if (nil == image) {
        return nil;
    }
    int capTop = (int)3 * image.size.height / 4;
    
    UIImage * retImage = [image stretchableImageWithLeftCapWidth:10 topCapHeight:capTop];
    return retImage;
}

//计算图片尺寸的自动缩放
+(CGRect) rectSizeWithImage:(CGRect)aInRect aImageSize:(CGSize)aImageSize
{
    CGRect newRect;
    double dWidth = aInRect.size.width;
    double dHeight = aInRect.size.height;
    double dAspectRatio = dWidth/dHeight;
    
    double dImageWidth = aImageSize.width;
    double dImageHeight = aImageSize.height;
    double dImageAspectRatio = dImageWidth/dImageHeight;
    
    if (dImageAspectRatio >= dAspectRatio){
        
        int nNewHeight = (int)(dWidth/dImageWidth*dImageHeight);
        int nCenteringFactor = (aInRect.size.height - nNewHeight) / 2;
        newRect = CGRectMake(0, nCenteringFactor, (int)dWidth, nNewHeight);
        
    }else if (dImageAspectRatio < dAspectRatio){
        
        int nNewWidth = (int)(dHeight/dImageHeight*dImageWidth);
        int nCenteringFactor = (aInRect.size.width - nNewWidth) / 2;
        newRect = CGRectMake(nCenteringFactor, 0, nNewWidth,(int)(dHeight));
        
    }
    return newRect;
}

+ (UIImage*)transStyleImageWithName:(NSString*)imageName
{
    return [[MFResourceCenter sharedMFResourceCenter] imageWithId:imageName];
}

+ (UIImage *)styleCenterImageWithId:(NSString*)imageId
{
    UIImage *retImage = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:imageId];
    if (nil == retImage) {
        UIImage * image = [self transStyleImageWithName:imageId];
        retImage = [MFHelper stretchableCellImage:image];
        [[MFResourceCenter sharedMFResourceCenter] cacheImage:retImage key:imageId];
    }
    return retImage;
}

+ (UIImage*)styleLeftImageWithId:(NSString*)imageId
{
    UIImage *retImage = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:imageId];
    if (nil == retImage) {
        UIImage * image = [self transStyleImageWithName:imageId];
        retImage = [MFHelper resizeableLeftBgImage:image];
        [[MFResourceCenter sharedMFResourceCenter] cacheImage:retImage key:imageId];
    }
    return retImage;
}

+ (UIImage*)styleRightImageWithId:(NSString*)imageId
{
    UIImage *retImage = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:imageId];
    if (nil == retImage) {
        UIImage * image = [self transStyleImageWithName:imageId];
        retImage = [MFHelper resizeableRightBgImage:image];
        [[MFResourceCenter sharedMFResourceCenter] cacheImage:retImage key:imageId];
    }
    return retImage;
}

+ (MFImageView*)createImageView
{
    MFImageView *retImageView = [[MFImageView alloc] initWithFrame:CGRectZero];
    retImageView.opaque = YES;
    retImageView.corner = NO;
    return retImageView;
}

+ (CGSize)sizeWithFont:(NSString*)text font:(UIFont*)font size:(CGSize)size
{
    CGSize avaliableSize = [text sizeWithFont:font constrainedToSize:CGSizeMake(size.width, size.height*100)
                                lineBreakMode:NSLineBreakByWordWrapping];
    return avaliableSize;
}

+ (NSString *)getPowerSearchPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [NSString stringWithString:[paths objectAtIndex:0]] ;
}

+ (NSString*)getBundleName
{
    NSString *retPath = [NSString stringWithFormat:@"%@",@"MFSDK.bundle"];
    return  retPath;
}

+ (NSString *)getResourcePath
{
    NSString * resPath = [[NSBundle mainBundle] resourcePath];
    return resPath ;
}

+ (BOOL)deleteExistFile:(NSString *)strFileName
{
    NSFileManager * fileManager = [NSFileManager defaultManager] ;
    
    if ([fileManager isDeletableFileAtPath:strFileName ] == NO) {
        return NO;
    }
    return [fileManager removeItemAtPath:strFileName error: nil];
}

+ (BOOL)copyFile:(NSString*)strSource strDim:(NSString*)strDim
{
    [self deleteExistFile:strDim];
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    
    NSError *error = nil ;
    bool rt = [fileManager copyItemAtPath:strSource toPath:strDim error:&error];
    if (!rt){
        return FALSE ;
    }
    return rt ;
}

+ (BOOL)copyDirectory:(NSString *)source dim:(NSString *)dim
{
    if ([[NSFileManager defaultManager] isReadableFileAtPath:source]) {
        [[NSFileManager defaultManager] copyItemAtPath:source toPath:dim error:nil];
        return YES;
    }
    return NO ;
}

+ (BOOL)isDirectory:(NSString *)strDirectory
{
    BOOL flag = NO;
    NSFileManager *fileManager = [ NSFileManager defaultManager ] ;
    [fileManager fileExistsAtPath:strDirectory isDirectory:&flag ] ;
    return flag ;
}

+ (BOOL)isExistDirectory:(NSString *) strDirectory
{
    BOOL flag = YES;
    NSFileManager *fileManager = [ NSFileManager defaultManager ] ;
    return [fileManager fileExistsAtPath:strDirectory isDirectory:&flag ] ;
}

+ (BOOL)isExistFile:(NSString *) strFileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager] ;
    
    if ([fileManager fileExistsAtPath:strFileName ] == NO) {
        return NO;
    }else{
        return YES;
    }
}

+ (NSString*)formateTimeInterval:(NSTimeInterval)timecontent
{
    NSDateFormatter* formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm"];
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:timecontent];
    NSString * time = [formatter stringFromDate:timeDate];
    return time;
}

+ (NSString*)getFrameStringWithCssStyle:(NSDictionary*)styleDict
{
    NSString *left = [styleDict objectForKey:KEY_WIDGET_LEFT] ? [styleDict objectForKey:KEY_WIDGET_LEFT] : @"0";
    NSString *top = [styleDict objectForKey:KEY_WIDGET_TOP] ? [styleDict objectForKey:KEY_WIDGET_TOP] : @"0";
    NSString *width = [styleDict objectForKey:KEY_WIDGET_WIDTH] ? [styleDict objectForKey:KEY_WIDGET_WIDTH] : @"0";
    NSString *height = [styleDict objectForKey:KEY_WIDGET_HEIGHT] ? [styleDict objectForKey:KEY_WIDGET_HEIGHT] : @"0";
    
    NSString *frameString = [NSString stringWithFormat:@"%@,%@,%@,%@",left,top,width,height];
    return frameString;
}

+ (CGRect)formatFrameWithString:(NSString*)rectString superFrame:(CGRect)superFrame
{
    CGRect retRect = [self formatRectWithString:rectString superFrame:superFrame];
    return retRect;
}

+ (BOOL)autoWidthTypeWithCssStyle:(NSDictionary*)styleDict
{
    BOOL autoWidth = NO;
    NSString *width = [styleDict objectForKey:KEY_WIDGET_WIDTH] ? [styleDict objectForKey:KEY_WIDGET_WIDTH] : @"0";
    if (width && [[width lowercaseString] isEqualToString:@"auto"]) {
        autoWidth = YES;
    }
    return autoWidth;
}

+ (BOOL)autoHeightTypeWithCssStyle:(NSDictionary*)styleDict
{
    BOOL autoHeight = NO;
    NSString *height = [styleDict objectForKey:KEY_WIDGET_HEIGHT] ? [styleDict objectForKey:KEY_WIDGET_HEIGHT] : @"0";
    if (height && [[height lowercaseString] isEqualToString:@"auto"]) {
        autoHeight = YES;
    }
    return NO;
}

+ (CGRect)formatRectWithString:(NSString*)rectString superFrame:(CGRect)superFrame
{
    CGRect retRect = CGRectMake(0, 0, 0, 0);
    NSArray *rectArray = [rectString componentsSeparatedByString:@","];

    if ([rectArray count] == 4) {

        BOOL relativeLeft = [[rectArray objectAtIndex:0] hasSuffix:@"%"];
        BOOL relativeTop = [[rectArray objectAtIndex:1] hasSuffix:@"%"];
        BOOL relativeWidth = [[rectArray objectAtIndex:2] hasSuffix:@"%"];
        BOOL relativeHeight = [[rectArray objectAtIndex:3] hasSuffix:@"%"];

        CGFloat left = [[rectArray objectAtIndex:0] floatValue];
        CGFloat top = [[rectArray objectAtIndex:1] floatValue];
        CGFloat width = [[rectArray objectAtIndex:2] floatValue];
        CGFloat height = [[rectArray objectAtIndex:3] floatValue];
        
        left = relativeLeft ? left*superFrame.size.width/100 : left;
        top = relativeTop ? top*superFrame.size.height/100 : top;
        width = relativeWidth ? width*superFrame.size.width/100 : width;
        height = relativeHeight ? height*superFrame.size.height/100 : height;

        retRect = CGRectMake(left, top, width, height);
    }
    return retRect;
}

+ (CGRect)formatRectWithString:(NSString*)rectString
{
    CGRect retRect = CGRectMake(0, 0, 0, 0);
    NSArray *rectArray = [rectString componentsSeparatedByString:@","];
    if ([rectArray count] == 4) {
        CGFloat x = [[rectArray objectAtIndex:0] floatValue];
        CGFloat y = [[rectArray objectAtIndex:1] floatValue];
        CGFloat w = [[rectArray objectAtIndex:2] floatValue];
        CGFloat h = [[rectArray objectAtIndex:3] floatValue];
        retRect = CGRectMake(x, y, w, h);
    }
    return retRect;
}

+ (MFAlignmentType)formatAlignmentWithString:(NSString*)alignmentString
{
    MFAlignmentType retTextAlignment = MFAlignmentTypeLeft;
    NSString * tas = [alignmentString lowercaseString];
    if ([tas isEqualToString:@"left"]) {
        retTextAlignment = MFAlignmentTypeLeft;
    }
    else if ([tas isEqualToString:@"center"]) {
        retTextAlignment = MFAlignmentTypeCenter;
    }
    else if ([tas isEqualToString:@"right"]) {
        retTextAlignment = MFAlignmentTypeRight;
    }
    else if ([tas isEqualToString:@"none"]) {
        retTextAlignment = MFAlignmentTypeNone;
    }
    return retTextAlignment;
}

+ (NSTextAlignment)formatTextAlignmentWithString:(NSString*)textAlignmentString
{
    NSTextAlignment retTextAlignment = NSTextAlignmentLeft;
    NSString * tas = [textAlignmentString lowercaseString];
    if ([tas isEqualToString:@"left"]) {
        retTextAlignment = NSTextAlignmentLeft;
    }
    else if ([tas isEqualToString:@"center"]) {
        retTextAlignment = NSTextAlignmentCenter;
    }
    else if ([tas isEqualToString:@"right"]) {
        retTextAlignment = NSTextAlignmentRight;
    }
    return retTextAlignment;
}

+ (NSNumber *)formatTouchEnableWithString:(NSString*)touchEnable
{
    BOOL retTouchEnable = NO;
    NSString * tas = [touchEnable lowercaseString];
    if ([tas isEqualToString:@"yes"]) {
        retTouchEnable = YES;
    }
    else if ([tas isEqualToString:@"no"]) {
        retTouchEnable = NO;
    }
    return [NSNumber numberWithBool:retTouchEnable];
}

+ (NSNumber *)formatVisibilityWithString:(NSString*)visibility
{
    BOOL retVisibility = NO;
    NSString * tas = [visibility lowercaseString];
    if ([tas isEqualToString:@"visible"]) {
        retVisibility = YES;
    }
    else if ([tas isEqualToString:@"hidden"]) {
        retVisibility = NO;
    }
    return [NSNumber numberWithBool:retVisibility];
}

+ (UIFont *)formatFontWithString:(NSString*)font
{
    UIFont *retFont = nil;
    NSArray *rectArray = [font componentsSeparatedByString:@" "];
    if ([rectArray count] == 2) {
        NSString * fontWeightStr = [rectArray objectAtIndex:0];
        NSString * fontSizeStr = [rectArray objectAtIndex:1];
        BOOL fontWeight = [[fontWeightStr lowercaseString] isEqualToString:@"bold"] ? YES : NO;
        NSInteger fontSize = [fontSizeStr intValue];
        retFont = fontWeight ? [UIFont boldSystemFontOfSize:fontSize] : [UIFont systemFontOfSize:fontSize];
    }
    return retFont;
}

+ (UIImage *)formatImageWithString:(NSString*)imageUrl
{
    NSString *trimUrl = [imageUrl stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"url()"]];
    return [MFResourceCenter imageNamed:trimUrl];
}

+ (MFLayoutType)formatLayoutWithString:(NSString*)layout
{
    MFLayoutType retLayoutType = MFLayoutTypeStretch;
    NSString * tas = [layout lowercaseString];
    if ([tas isEqualToString:@"stretch"]) {
        retLayoutType = MFLayoutTypeStretch;
    }else if ([tas isEqualToString:@"absolute"]) {
        retLayoutType = MFLayoutTypeAbsolute;
    }else if ([tas isEqualToString:@"none"]) {
        retLayoutType = MFLayoutTypeNone;
    }
    return retLayoutType;
}

+ (NSNumber *)formatReverseWithString:(NSString*)reverse
{
    BOOL reverseType = NO;
    NSString * tas = [reverse lowercaseString];
    if ([tas isEqualToString:@"yes"]) {
        reverseType = YES;
    }

    return [NSNumber numberWithBool:reverseType];
}

+ (UIImage*)scaleToSize:(UIImage*)image size:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+ (CGRect)imageFitRect:(CGRect)aInRect aImageSize:(CGSize)aImageSize
{
    CGRect imgFitRect = CGRectMake(0,0,aImageSize.width,aImageSize.height);
    if (aInRect.size.width != aImageSize.width || aInRect.size.height != aImageSize.height){
        imgFitRect = [self rectSizeWithImage:aInRect aImageSize:aImageSize];
    }
    return imgFitRect ;
}

+ (int)dayAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *startDateStr = [dateFormatter stringFromDate:fromeDate];
    NSString *endDateStr = [dateFormatter stringFromDate:toDate];
    
    startDateStr = [startDateStr stringByAppendingString:@" 01:00:00"];
    endDateStr = [endDateStr stringByAppendingString:@" 12:00:00"];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *startDate = [dateFormatter dateFromString:startDateStr];
    NSDate *endDate = [dateFormatter dateFromString:endDateStr];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    int days = (int)[comps day];
    return days;
}

+ (int)yearAfterNumFromeDate:(NSDate *)fromeDate  toDate:(NSDate *)toDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy";
    NSString *startDateStr = [dateFormatter stringFromDate:fromeDate];
    NSString *endDateStr = [dateFormatter stringFromDate:toDate];
    
    startDateStr = [startDateStr stringByAppendingString:@"-12-01 01:00:00"];
    endDateStr = [endDateStr stringByAppendingString:@"-12-02 12:00:00"];
    
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    NSDate *startDate = [dateFormatter dateFromString:startDateStr];
    NSDate *endDate = [dateFormatter dateFromString:endDateStr];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned int unitFlags = NSCalendarUnitYear;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:startDate toDate:endDate options:0];
    int years = (int)[comps year];
    return years;
}

+ (NSString*)formatDate:(NSDate*)date
{
    if (!date) {
        return @"";
    }
    NSDate * currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeInterval time = [currentDate timeIntervalSinceDate:date];
    BOOL dateLargerThanLocal = (time < 0);
    NSMutableArray * array = [[NSMutableArray alloc] initWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];
    [dateFormatter setWeekdaySymbols:array];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *result = nil;
    NSInteger days = [MFHelper dayAfterNumFromeDate:date toDate:currentDate];
    NSInteger year = [MFHelper yearAfterNumFromeDate:date toDate:currentDate];
    if (dateLargerThanLocal) {
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * currentDateDay = [dateFormatter stringFromDate:currentDate];
        NSString * dateDay = [dateFormatter stringFromDate:date];
        if ([currentDateDay isEqualToString:dateDay]) {
            [dateFormatter setDateFormat:@"HH:mm"];
            result = [dateFormatter stringFromDate:date];
        }
        else {
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * currentYear =  [dateFormatter stringFromDate:currentDate];
            NSString * dateYear = [dateFormatter stringFromDate:date];
            if ([currentYear isEqualToString:dateYear]) {
                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            }
            else {
                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            }
            result = [dateFormatter stringFromDate:date];
        }
    }
    else {
        if (days == 0 ) {
            [dateFormatter setDateFormat:@"MM-dd"];
            NSString * currentDateDay = [dateFormatter stringFromDate:currentDate];
            NSString * dateDay = [dateFormatter stringFromDate:date];
            if ([currentDateDay isEqualToString:dateDay]) {
                [dateFormatter setDateFormat:@"HH:mm"];
                result = [dateFormatter stringFromDate:date];
            }
            else {
                [dateFormatter setDateFormat:@"HH:mm"];
                result = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
            }
        }
        else if (days == 1) {
            [dateFormatter setDateFormat:@"HH:mm"];
            result = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:date]];
        }
        else if (days == 2) {
            [dateFormatter setDateFormat:@"HH:mm"];
            result = [NSString stringWithFormat:@"前天 %@",[dateFormatter stringFromDate:date]];
        }
        else if (days >=3 && days <=4) {
            [dateFormatter setDateFormat:@"EEEE HH:mm"];
            result = [dateFormatter stringFromDate:date];
        }
        else {
            if (year == 0) {
                [dateFormatter setDateFormat:@"MM月dd日 HH:mm"];
            }
            else {
                [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
            }
            result = [dateFormatter stringFromDate:date];
        }
    }
    return result;
}

+ (BOOL)isCompositeTemplate:(NSString*)templateId
{
    BOOL retCode = NO;
    if ([[templateId componentsSeparatedByString:@"-"] count]>1) {
        retCode = YES;
    }
    return retCode;
}

+ (BOOL)sameRect:(CGRect)rect withRect:(CGRect)withRect
{
    if (rect.origin.x == withRect.origin.x &&
        rect.origin.y == withRect.origin.y &&
        rect.size.width == withRect.size.width &&
        rect.size.height == withRect.size.height) {
        return YES;
    }
    return NO;
}

+ (BOOL)isURLString:(NSString*)urlString
{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)supportMultiLine:(NSString*)string
{
    if ([string isEqualToString:@"0"]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isKindOfLabel:(NSString*)labelString
{
    BOOL retCode = NO;
    NSString *lowLabelString = [labelString lowercaseString];
    if ([lowLabelString isEqualToString:@"label"]
        || [lowLabelString isEqualToString:@"slidelabel"]
        || [lowLabelString isEqualToString:@"richlabel"]) {
        retCode = YES;
    }
    return retCode;
}

+ (BOOL)isKindOfTips:(NSString*)string
{
    BOOL retCode = NO;
    NSString *lowerString = [string lowercaseString];
    if ([lowerString isEqualToString:@"head"]
        || [lowerString isEqualToString:@"foot"]) {
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

+ (BOOL)isKindOfAudio:(NSString*)audioString
{
    BOOL retCode = NO;
    NSString *lowAudioString = [audioString lowercaseString];
    if ([lowAudioString isEqualToString:@"audio"]) {
        retCode = YES;
    }
    return retCode;
}

+ (NSInteger)sectionHeight
{
    return sectionCellHeight;
}

+ (NSInteger)cellFooterHeight
{
    return sectionFooterHeight;
}

+ (NSInteger)cellHeaderHeight
{
    return sectionHeaderHeight;
}

+ (BOOL)sizeZero:(CGSize)size
{
    if (size.height !=0 && size.width != 0) {
        return YES;
    }
    return NO;
}

+ (NSString*)sectionHeaderKey:(NSString*)sourceKey
{
    return [NSString stringWithFormat:@"%@_h",sourceKey];
}

+ (NSString*)sectionFooterKey:(NSString*)sourceKey
{
    return [NSString stringWithFormat:@"%@_f",sourceKey];
}

@end
