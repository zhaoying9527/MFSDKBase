//
//  MFPhotoCell.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/22.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MFPhotoCell;
@protocol MFPhotoCellDelegate <NSObject>
- (void)singleTapPhotoCell:(MFPhotoCell*)sender;
@end

@interface MFPhotoCell : UICollectionViewCell
@property (nonatomic, strong) UIImage* photo;
@property (nonatomic, weak) id<MFPhotoCellDelegate> delegate;
@end
