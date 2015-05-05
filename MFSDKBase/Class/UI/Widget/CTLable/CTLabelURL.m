//
//  CTLableURL.m
//  CTLable
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//

#import "CTLabelURL.h"

//正则匹配链接
static NSString *urlExpression = @"((([A-Za-z]{3,9}:(?:\\/\\/)?)(?:[\\-;:&=\\+\\$,\\w]+@)?[A-Za-z0-9\\.\\-]+|(?:www\\.|[\\-;:&=\\+\\$,\\w]+@)[A-Za-z0-9\\.\\-]+)((:[0-9]+)?)((?:\\/[\\+~%\\/\\.\\w\\-]*)?\\??(?:[\\-\\+=&;%@\\.\\w]*)#?(?:[\\.\\!\\/\\\\\\w]*))?)";
static NSString *MOBILEExpression = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";

static CTCustomDetectLinkBlock customDetectBlock = nil;

@implementation CTLabelURL

+ (CTLabelURL *)urlWithLinkData: (id)linkData
                          range: (NSRange)range
                          color: (UIColor *)color
               underLineForLink: (BOOL)underLineForLink
{
    CTLabelURL *url  = [[CTLabelURL alloc]init];
    url.linkData = linkData;
    url.range = range;
    url.color = color;
    url.underLineForLink = underLineForLink;
    return url;
}


+ (NSArray *)detectLinks: (NSString *)plainText linkType:(CTLabelLinkDetectType)linkType
{
    //提供一个自定义的解析接口给
    if (customDetectBlock)
    {
        return customDetectBlock(plainText);
    }
    else
    {
        if(linkType == CTLabelLinkDetectNone){
            return nil;
        }
        
        NSMutableArray *links = [NSMutableArray array];
        //url
        if(linkType & CTLabelLinkDetectURL){
            [links addObjectsFromArray:[CTLabelURL detectURL:plainText]];
        }
        
        //mobile
        if(linkType & CTLabelLinkDetectMobile){
            [links addObjectsFromArray:[CTLabelURL detectPhoneNumber:plainText]];
        }
        
        return links;
    }
}

+ (void)setCustomDetectMethod:(CTCustomDetectLinkBlock)block
{
    customDetectBlock = [block copy];
}

+ (NSArray *)detectURL:(NSString *)plainText{
    //信息过滤接口
    NSMutableArray *links = nil;
    if ([plainText length])
    {
        links = [NSMutableArray array];
        NSRegularExpression *urlRegex = [NSRegularExpression regularExpressionWithPattern:urlExpression
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];
        [urlRegex enumerateMatchesInString:plainText
                                   options:0
                                     range:NSMakeRange(0, [plainText length])
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                    NSRange range = result.range;
                                    NSString *text = [plainText substringWithRange:range];
                                    CTLabelURL *link = [CTLabelURL urlWithLinkData:text
                                                                             range:range
                                                                             color:nil
                                                                  underLineForLink:NO];
                                    [links addObject:link];
                                }];
    }
    return links;
}

+ (NSArray *)detectPhoneNumber:(NSString *)plainText{
    //信息过滤接口
    NSMutableArray *links = nil;
    if ([plainText length])
    {
        links = [NSMutableArray array];
        NSRegularExpression *urlRegex = [NSRegularExpression regularExpressionWithPattern:MOBILEExpression
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:nil];
        [urlRegex enumerateMatchesInString:plainText
                                   options:0
                                     range:NSMakeRange(0, [plainText length])
                                usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
                                    NSRange range = result.range;
                                    NSString *text = [plainText substringWithRange:range];
                                    CTLabelURL *link = [CTLabelURL urlWithLinkData:text
                                                                             range:range
                                                                             color:nil
                                                                  underLineForLink:NO];
                                    [links addObject:link];
                                }];
    }
    return links;
}

@end
