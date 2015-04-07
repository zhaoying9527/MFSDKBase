//
//  MFUIFactory.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFUIFactory.h"
#import "HTMLNode.h"
#import "MFHelper.h"
#import "MFAMLScript.h"
#import "MFLabel.h"
#import "MFImageView.h"
#import "MFEmojiView.h"
#import "UIView+UUID.h"
#import "MFLayoutCenter.h"
#import "UIView+Actions.h"

@implementation MFUIFactory
+ (id)createUiWithPage:(HTMLNode*)node style:(NSDictionary*)cssDict
{
    MFAMLScript *script = [MFAMLScript sharedMFAMLScript];
    if (!node || ![script supportHtmlTag:node.tagName]) {
        return nil;
    }
    
    UIView *widget = [[MFAMLScript sharedMFAMLScript] allocObject:node.tagName];
    NSString *uuid = [node getAttributeNamed:@"id"];
    [widget setUUID:uuid];
    if([script bindObject:widget]) {
        [script batchExecution:cssDict];
    }
    
    if ([widget respondsToSelector:@selector(setOpaque:)]) {
        [widget setOpaque:YES];
    }
    if ([widget respondsToSelector:@selector(setAlpha:)]) {
        [widget setAlpha:1.0];
    }
    
    return widget;
}

+ (BOOL)addActionForWidget:(UIView*)widget withPage:(HTMLNode*)node;
{
    MFAMLScript *script = [MFAMLScript sharedMFAMLScript];
    if (!node || ![script supportHtmlTag:node.tagName]) {
        return NO;
    }
    
    NSArray *attributes = [node getAttributes];
    NSString *actionRegix = @"on.*=(.*)\\((.*)\\)";
    NSString *realAttribute = @"";
    BOOL hasAction = NO;
    for (realAttribute in attributes) {
        if ([realAttribute rangeOfString:actionRegix options:NSRegularExpressionSearch].length > 0) {
            hasAction = YES;
            break;
        }
    }
    if (!hasAction) {
        return NO;
    }
    
    NSArray * components = [realAttribute componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"="]];
    if (components.count < 2) {
        return NO;
    }
    
    NSString *actionName = components[0];
    NSString *actionFunction = components[1];
    [widget setAction:actionName function:actionFunction];
    
    return hasAction;
}

@end
