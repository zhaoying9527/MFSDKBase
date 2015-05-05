//
//  CTLableURL.h
//  CTLable
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//

/**
 *  点击 Link 规则过滤
 */

#import <Foundation/Foundation.h>
#import "CTLableDefine.h"
#import "CTLabel.h"


@interface CTLabelURL : NSObject

@property (nonatomic,strong)    id      linkData;              //信息透传
@property (nonatomic,assign)    NSRange range;                 //link区域
@property (nonatomic,assign)    BOOL underLineForLink;         //下划线开关
@property (nonatomic,strong)    UIColor *color;                //链接颜色
@property (nonatomic,strong)    UIColor *underLineColor;       //下划线颜色
@property (nonatomic,strong)    UIColor *highlightColor;       //按住高亮背景色

+ (CTLabelURL *)urlWithLinkData: (id)linkData
                          range: (NSRange)range
                          color: (UIColor *)color
               underLineForLink: (BOOL)underLineForLink;

+ (NSArray *)detectLinks: (NSString *)plainText linkType:(CTLabelLinkDetectType)linkType;

+ (void)setCustomDetectMethod:(CTCustomDetectLinkBlock)block;

@end
