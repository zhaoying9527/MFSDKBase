//
//  CTLable.h
//  CTLable
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//

/**
 *  基础服务库
 */

#import <UIKit/UIKit.h>
#import "CTLableDefine.h"

typedef enum {
    CTLabelLinkDetectNone    = 0,
    CTLabelLinkDetectURL     = 1 << 0,
    CTLabelLinkDetectMobile  = 1 << 1
}CTLabelLinkDetectType;

@interface CTLabel : UIView
@property (nonatomic,weak)    id<CTAttributedLabelDelegate> delegate;
@property (nonatomic,strong)    UIFont *font;                   //字体
@property (nonatomic,strong)    UIColor *textColor;             //文字颜色
@property (nonatomic,strong)    UIColor *highlightColor;        //链接点击时背景高亮色
@property (nonatomic,strong)    UIColor *linkColor;             //链接色
@property (nonatomic,assign)    BOOL    autoDetectLinks;        //自动检测
@property (nonatomic,assign)    NSInteger   numberOfLines;      //行数
@property (nonatomic,assign)    CTTextAlignment textAlignment;  //文字排版样式
@property (nonatomic,assign)    CTLineBreakMode lineBreakMode;  //LineBreakMode
@property (nonatomic,assign)    CGFloat lineSpacing;            //行间距
@property (nonatomic,assign)    CGFloat paragraphSpacing;       //段间距
@property (nonatomic,assign)    CTLabelLinkDetectType detectLinkType;
@property (nonatomic,strong)    NSMutableAttributedString *attributedString;
#pragma mark - 基础设置
//普通文本
- (void)setText:(NSString *)text;
- (void)appendText: (NSString *)text;

//属性文本
- (void)setAttributedText:(NSAttributedString *)attributedText;
- (void)appendAttributedText: (NSAttributedString *)attributedText;

//图片
- (void)appendImage: (UIImage *)image;
- (void)appendImage: (UIImage *)image
            maxSize: (CGSize)maxSize;
- (void)appendImage: (UIImage *)image
            maxSize: (CGSize)maxSize
             margin: (UIEdgeInsets)margin;
- (void)appendImage: (UIImage *)image
            maxSize: (CGSize)maxSize
             margin: (UIEdgeInsets)margin
          alignment: (CTImageAlignment)alignment;

//UI控件
- (void)appendView: (UIView *)view;
- (void)appendView: (UIView *)view
            margin: (UIEdgeInsets)margin;
- (void)appendView: (UIView *)view
            margin: (UIEdgeInsets)margin
         alignment: (CTImageAlignment)alignment;

//添加自定义链接
- (void)addCustomLink: (id)linkData
             forRange: (NSRange)range
            underLine: (BOOL)line;
- (void)addCustomLink: (id)linkData
             forRange: (NSRange)range
            linkColor: (UIColor *)color
            underLine: (BOOL)line;



//大小
- (CGSize)sizeThatFits:(CGSize)size;

//设置全局的自定义Link检测Block(详见CTLabelURL)
+ (void)setCustomDetectMethod:(CTCustomDetectLinkBlock)block;

@end
