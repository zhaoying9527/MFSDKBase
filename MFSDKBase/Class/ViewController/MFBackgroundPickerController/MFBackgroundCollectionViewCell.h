//
//  MFBackgroundCollectionViewCell.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/27.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFImageCollectionViewCell.h"

@interface MFBackgroundCollectionViewCell : MFImageCollectionViewCell
@property (nonatomic, strong) NSURL* originalImageUrl;
@property (nonatomic, assign) BOOL showDownloadLayer;
- (BOOL)needsDoloadOriginalImage;
- (void)doloadOriginalImage:(NSURL*)originalImageUrl
                   compelet:(void (^)(BOOL success, UIImage* image))completion;
@end
