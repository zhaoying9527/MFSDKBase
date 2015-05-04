//
//  MFHtmlParser.m
//  MFuickSDK
//
//  Created by 赵嬴 on 15/4/2.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFHtmlParser.h"

@interface MFHtmlParser()
@property (nonatomic,strong)HTMLParsers *parser;
@property (nonatomic,copy)NSString *htmlText;
@end
@implementation MFHtmlParser
- (BOOL)loadText:(NSString*)text
{
    
    if (nil != text) {
        NSError* error = nil;
        self.htmlText = text;
        self.parser = [[HTMLParsers alloc] initWithString:self.htmlText error:&error];
        return YES;
    }
    return NO;
}

- (id)parse
{
    return self;
}

- (id)parser
{
    return _parser;
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

- (NSArray*)bodyEntity
{
    return [[self.parser body] children];
}
@end
