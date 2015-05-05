//
//  NSMutableAttributedString+CT.h
//  CTLable
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTLableDefine.h"

@interface NSMutableAttributedString (CT)

- (void)setTextColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color range:(NSRange)range;

- (void)setFont:(UIFont*)font;
- (void)setFont:(UIFont*)font range:(NSRange)range;

- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier;
- (void)setUnderlineStyle:(CTUnderlineStyle)style
                 modifier:(CTUnderlineStyleModifiers)modifier
                    range:(NSRange)range;

- (void)setUnderlineColor:(UIColor *)color range:(NSRange)range;

@end
