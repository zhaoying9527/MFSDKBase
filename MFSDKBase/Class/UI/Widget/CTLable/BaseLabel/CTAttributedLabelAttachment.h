//
//  CTAttributedLableAttachment.h
//  CTLable
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTLableDefine.h"

void deallocCallback(void* ref);
CGFloat ascentCallback(void *ref);
CGFloat descentCallback(void *ref);
CGFloat widthCallback(void* ref);

@interface CTAttributedLabelAttachment : NSObject

@property (nonatomic,strong)    id                  content;
@property (nonatomic,assign)    UIEdgeInsets        margin;
@property (nonatomic,assign)    CTImageAlignment   alignment;
@property (nonatomic,assign)    CGFloat             fontAscent;
@property (nonatomic,assign)    CGFloat             fontDescent;
@property (nonatomic,assign)    CGSize              maxSize;

- (CGSize)boxSize;
+ (CTAttributedLabelAttachment *)attachmentWith: (id)content
                                          margin: (UIEdgeInsets)margin
                                       alignment: (CTImageAlignment)alignment
                                         maxSize: (CGSize)maxSize;
@end
