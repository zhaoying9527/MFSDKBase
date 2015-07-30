//
//  HTMLParsers.m
//  StackOverflow
//
//  Created by Ben Reeves on 09/03/2010.
//  Copyright 2010 Ben Reeves. All rights reserved.
//

#import "HTMLParsers.h"

static const NSInteger MaxEncodingStringLength = 256;

@implementation HTMLParsers

-(HTMLNode*)doc
{
	if (_doc == NULL)
		return NULL;
	
	return [[[HTMLNode alloc] initWithXMLNode:(xmlNode*)_doc] autorelease];
}

-(HTMLNode*)html
{
	if (_doc == NULL)
		return NULL;
	
	return [[self doc] findChildTag:@"html"];
}

-(HTMLNode*)head
{
	if (_doc == NULL)
		return NULL;

	return [[self doc] findChildTag:@"head"];
}

-(HTMLNode*)body
{
	if (_doc == NULL)
		return NULL;
	
	return [[self doc] findChildTag:@"body"];
}

-(instancetype)initWithString:(NSString*)string error:(NSError**)error
{ 
	if (self = [super init])
	{
		_doc = NULL;
		
		if ([string length] > 0)
		{
			CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
			CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);

            char buffer[MaxEncodingStringLength];
            const char *enc = CFStringGetCStringPtr(cfencstr, 0);
            if (enc == NULL && [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
                if (CFStringGetCString(cfencstr, buffer, MaxEncodingStringLength, 0)) {
                    enc = buffer;
                }
            }

			// _doc = htmlParseDoc((xmlChar*)[string UTF8String], enc);
			int optionsHtml = HTML_PARSE_RECOVER;
			optionsHtml = optionsHtml | HTML_PARSE_NOERROR; //Uncomment this to see HTML errors
			optionsHtml = optionsHtml | HTML_PARSE_NOWARNING;
			_doc = htmlReadDoc ((xmlChar*)[string UTF8String], NULL, enc, optionsHtml);
		}
		else 
		{
			if (error) {
				*error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
			}
		}
	}
	
	return self;
}

-(instancetype)initWithData:(NSData*)data error:(NSError**)error
{
	if (self = [super init])
	{
		_doc = NULL;

		if (data)
		{
			CFStringEncoding cfenc = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
			CFStringRef cfencstr = CFStringConvertEncodingToIANACharSetName(cfenc);

            char buffer[MaxEncodingStringLength];
            const char *enc = CFStringGetCStringPtr(cfencstr, 0);
            if (enc == NULL && [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
                if (CFStringGetCString(cfencstr, buffer, MaxEncodingStringLength, 0)) {
                    enc = buffer;
                }
            }

			//_doc = htmlParseDoc((xmlChar*)[data bytes], enc);
			
			_doc = htmlReadDoc((xmlChar*)[data bytes],
							 "",
							enc,
							XML_PARSE_NOERROR | XML_PARSE_NOWARNING);
		}
		else
		{
			if (error) 
			{
				*error = [NSError errorWithDomain:@"HTMLParserdomain" code:1 userInfo:nil];
			}

		}
	}
	
	return self;
}

-(instancetype)initWithContentsOfURL:(NSURL*)url error:(NSError**)error
{
	
	NSData * _data = [[NSData alloc] initWithContentsOfURL:url options:0 error:error];

	if (_data == nil || *error)
	{
		[_data release];
		return nil;
	}
	
	self = [self initWithData:_data error:error];
	
	[_data release];
	
	return self;
}


-(void)dealloc
{
	if (_doc)
	{
		xmlFreeDoc(_doc);
	}
	
	[super dealloc];
}

@end
