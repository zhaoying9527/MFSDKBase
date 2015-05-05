//
//  MFPhotoPreviewViewController.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/22.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@class MFPhotoToolBar;
@protocol MFPhotoToolBarDelegate <NSObject>
- (void)onFinishButtonClick:(MFPhotoToolBar*)sender;
@end

@interface MFPhotoToolBar : UIView
@property (nonatomic, weak) id<MFPhotoToolBarDelegate> delegate;
@property (nonatomic, weak) ALAsset* asset;
- (void)disable;
- (void)enable;
@end

@class MFPhotoPreviewViewController;
@protocol MFPhotoPreviewViewControllerDelegate <NSObject>
- (void)didFinishPreviewViewWithImageInfo:(NSArray*)imageInfo photoIndex:(NSInteger)photoIndex theOriginal:(BOOL)theOriginal;
@end

@interface MFPhotoPreviewViewController : UIViewController
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;
@property (nonatomic, weak) id<MFPhotoPreviewViewControllerDelegate> delegate;
- (id)initWithAssets:(NSArray*)assets atIndex:(NSInteger)index selectedAssets:(NSMutableArray*)selectedAssets;
@end
