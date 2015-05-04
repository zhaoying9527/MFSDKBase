//
//  MFHtmlParser.h
//  MFuickSDK
//
//  Created by 赵嬴 on 15/4/2.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFParser.h"
#import "HTMLParsers.h"
@interface MFHtmlParser : MFParser
//Returns the doc tag
- (HTMLNode*)doc;

//Returns the body tag
- (HTMLNode*)body;

//Returns the html tag
- (HTMLNode*)html;

//Returns the head tag
- (HTMLNode*)head;

//Returns nodes of body
- (NSArray*)bodyEntity;

//Returns HTMLParsers
- (id)parser;
@end
