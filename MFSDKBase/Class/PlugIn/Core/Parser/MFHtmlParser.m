//
//  MFHtmlParser.m
//  MFuickSDK
//
//  Created by 赵嬴 on 15/4/2.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFHtmlParser.h"

@interface MFHtmlParser()
@property (nonatomic,strong)HTMLParser *parser;
@property (nonatomic,copy)NSString *htmlText;
@end
@implementation MFHtmlParser
- (BOOL)loadText:(NSString*)text
{
    
    if (nil != text) {
        NSError* error = nil;
        self.htmlText = text;
        self.parser = [[HTMLParser alloc] initWithString:self.htmlText error:&error];
        return YES;
    }
    return NO;
}

- (id)parse
{
    return self;
}

- (HTMLNode*)doc
{
   return [self.parser doc];
}

- (HTMLNode*)body
{
   return [self.parser body];
}

- (HTMLNode*)html
{
   return [self.parser html];
}

- (HTMLNode*)head
{
    return [self.parser head];
}

- (NSArray*)bodyList
{
    return [[self.parser body] children];
}
@end
