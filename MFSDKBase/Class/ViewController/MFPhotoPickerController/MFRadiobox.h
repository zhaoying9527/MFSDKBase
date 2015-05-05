//
//  MFRadiobox.h
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/24.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MFRadiobox;
@protocol MFRadioboxDelegate <NSObject>
- (void)onRadioState:(MFRadiobox*)sender;
@end

@interface MFRadiobox : UIView
@property (nonatomic, weak) id<MFRadioboxDelegate> delegate;
@property (nonatomic, strong) NSString* text;
@property (nonatomic, assign) BOOL checked;
- (CGSize)radioBoxSize;
- (CGRect)radioBoxRect;
- (void)setChecked:(BOOL)checked animated:(BOOL)amiated;
@end
