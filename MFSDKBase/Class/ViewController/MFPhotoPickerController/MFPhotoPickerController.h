//
//  MFAssetViewController.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/22.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

#pragma mark - MFPhotoPickerController
@class MFPickerToolBar;
@protocol MFPickerToolBarDelegate <NSObject>
- (void)onSendButtonClick;
- (void)onPreviewButtonClick;
@end

@interface MFPickerToolBar : UIView
@property (nonatomic, weak) id<MFPickerToolBarDelegate> delegate;
@property (nonatomic, assign) BOOL disableState;
@property (nonatomic, assign) NSInteger badgeNumber;
@end

@class MFPhotoPickerController;
@protocol MFPhotoPickerControllerDelegate <NSObject>
- (void)didFinishPickingMediaWithImageInfo:(MFPhotoPickerController*)picker
                                 imageInfo:(NSArray*)imageInfo theOiginal:(BOOL)theOiginal;
- (void)assetPickerController:(MFPhotoPickerController*)picker didFinishPickingAssets:(NSArray*)assets;

@optional
- (void)assetPickerControllerDidCancel:(MFPhotoPickerController*)picker;
- (void)assetPickerController:(MFPhotoPickerController*)picker didSelectAsset:(ALAsset*)asset;
- (void)assetPickerController:(MFPhotoPickerController*)picker didDeselectAsset:(ALAsset*)asset;
- (void)assetPickerControllerDidMaximum:(MFPhotoPickerController*)picker;
- (void)assetPickerControllerDidMinimum:(MFPhotoPickerController*)picker;

@end

@interface MFPhotoPickerController : UINavigationController

@property (nonatomic, weak) id<UINavigationControllerDelegate, MFPhotoPickerControllerDelegate> delegate;
@property (nonatomic, strong) ALAssetsFilter* assetsFilter;
@property (nonatomic, copy, readonly) NSArray* indexPathsForSelectedItems;
@property (nonatomic, assign) NSInteger maximumNumberOfSelection;
@property (nonatomic, assign) NSInteger minimumNumberOfSelection;
@property (nonatomic, strong) NSPredicate* selectionFilter;
@property (nonatomic, assign) BOOL showCancelButton;
@property (nonatomic, assign) BOOL showEmptyGroups;
@property (nonatomic, assign) BOOL isFinishDismissViewController;
@end

#pragma mark - MFAssetViewController

@interface MFAssetViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ALAssetsGroup* assetsGroup;
@property (nonatomic, strong) NSMutableArray* indexPathsForSelectedItems;
@property (nonatomic,assign)NSInteger maximumNumberOfSelection;

@end

#pragma mark - MFVideoTitleView

@interface MFVideoTitleView : UILabel

@end

#pragma mark - MFTapAssetView

@protocol MFTapAssetViewDelegate <NSObject>
- (void)touchDetailView;
- (void)touchSelect:(BOOL)select;
- (BOOL)shouldTap;

@end

@interface MFTapAssetView : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, weak) id<MFTapAssetViewDelegate> delegate;

@end

#pragma mark - MFAssetView

@protocol MFAssetViewDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset;
- (void)tapDetailHandle:(ALAsset*)asset;

@end

@interface MFAssetView : UIView

- (void)bind:(ALAsset*)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced;

@end

#pragma mark - MFAssetViewCell

@protocol MFAssetViewCellDelegate;

@interface MFAssetViewCell : UITableViewCell

@property (nonatomic, weak) id<MFAssetViewCellDelegate> delegate;

- (void)bind:(NSArray*)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX;

@end

@protocol MFAssetViewCellDelegate <NSObject>

- (BOOL)shouldSelectAsset:(ALAsset*)asset;
- (void)didSelectAssetForDetail:(ALAsset*)asset;
- (void)didSelectAsset:(ALAsset*)asset;
- (void)didDeselectAsset:(ALAsset*)asset;

@end

#pragma mark - MFAssetGroupViewCell

@interface MFAssetGroupViewCell : UITableViewCell

- (void)bind:(ALAssetsGroup*)assetsGroup;

@end

#pragma mark - MFAssetGroupViewController

@interface MFAssetGroupViewController : UITableViewController

@end
