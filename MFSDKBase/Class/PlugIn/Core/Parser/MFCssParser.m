//
//  MFCssParser.m
//  MFuickSDK
//
//  Created by 赵嬴 on 15/4/2.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFCssParser.h"
#import "ESCssParser.h"
@interface MFCssParser()
@property (nonatomic,strong) ESCssParser *parser;
@property (nonatomic,copy) NSString *cssText;
@end


@implementation MFCssParser
- (BOOL)loadText:(NSString*)text
{
    if (nil != text) {
        self.cssText = text;
        self.parser = [[ESCssParser alloc] init];
        return YES;
    }
    return NO;
}

- (NSDictionary*)parse
{
    return [self.parser parseText:self.cssText];
}

@end
