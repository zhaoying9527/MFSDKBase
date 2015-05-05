//
//  MFCheckbox.h
//  ZYQAssetPickerControllerDemo
//
//  Created by 赵嬴 on 15/4/23.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFPhoto.h"

@class MFCheckbox;
@protocol MFCheckboxDelegate <NSObject>
- (void)onCheckState:(MFCheckbox*)sender;
@end

@interface MFCheckbox : UIView
@property (nonatomic, weak) id<MFCheckboxDelegate> delegate;
@property (nonatomic, assign) BOOL checked;
+ (CGSize)checkSize;
- (void)setChecked:(BOOL)checked animated:(BOOL)amiated;
@end
