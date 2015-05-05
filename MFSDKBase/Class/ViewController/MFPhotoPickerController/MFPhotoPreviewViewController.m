//
//  MFPhotoPreviewViewController.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/22.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFPhotoPreviewViewController.h"
#import "MFPhotoCell.h"
#import "MFPhoto.h"
#import "MFBadgeButton.h"
#import "MFCheckbox.h"
#import "MFRadiobox.h"
#import "MFHelper.h"
#import "UIImage+Scale.h"

#define TOOLBAR_HEIGHT 45

#pragma mark
#pragma mark MFPhotoToolBar
@interface MFPhotoToolBar () <MFRadioboxDelegate>
@property (nonatomic, strong) MFRadiobox* radioBox;
@property (nonatomic, strong) MFBadgeButton* badgeButton;
@property (nonatomic, strong) UIButton* finishButton;
@property (nonatomic, strong) NSMutableDictionary* cacheDictionary;

@end

@implementation MFPhotoToolBar
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }

    return self;
}

- (void)setupUI
{
    UIImageView* BGImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [BGImageView setImage:MFSDKImage(@"basePhotoPicker/TabbarBkg.png")];
    [self addSubview:BGImageView];

    if (nil == self.finishButton) {
        self.finishButton = [[UIButton alloc] init];
        self.finishButton.frame = CGRectMake(self.bounds.size.width - 60, 0, 60, self.bounds.size.height);
        [self.finishButton setTitle:@"发送" forState:UIControlStateNormal];
        [self.finishButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [self.finishButton setTitleColor:BLUETEXTCOLOR forState:UIControlStateNormal];
        [self addSubview:self.finishButton];
        [self.finishButton addTarget:self action:@selector(onFinish) forControlEvents:UIControlEventTouchUpInside];
    }

    if (nil == self.radioBox) {

        self.radioBox = [[MFRadiobox alloc] initWithFrame:CGRectZero];
        self.radioBox.text = @"原图";
        self.radioBox.delegate = self;
        [self addSubview:self.radioBox];
        CGSize radioBoxSize = [self.radioBox radioBoxSize];
        self.radioBox.frame = CGRectMake(16, 0, radioBoxSize.width, self.frame.size.height);
    }
    if (nil == self.badgeButton) {
        self.badgeButton = [[MFBadgeButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 90, 0, 50, self.bounds.size.height)];
        [self addSubview:self.badgeButton];
    }
}

- (void)onFinish
{
    if ([self.delegate respondsToSelector:@selector(onFinishButtonClick:)]) {
        [self.delegate onFinishButtonClick:self];
    }
}

- (void)onRadioState:(MFRadiobox*)sender
{
    if (sender.checked) {
        long long size = [[self.asset defaultRepresentation] size];
        CGFloat fsize = size / 1000.0 / 1000.0;
        sender.text = [NSString stringWithFormat:@"原图(%.2fM)", fsize];
    }
    else {
        sender.text = @"原图";
    }

    sender.frame = [sender radioBoxRect];
}

- (void)disable
{
    self.radioBox.alpha = 0.75;
    self.radioBox.userInteractionEnabled = NO;
    self.finishButton.alpha = 0.75;
    self.radioBox.userInteractionEnabled = NO;
}

- (void)enable
{
    self.radioBox.alpha = 1.0;
    self.radioBox.userInteractionEnabled = YES;
    self.finishButton.alpha = 1.0;
    self.radioBox.userInteractionEnabled = YES;
}

@end

#pragma mark
#pragma mark MFPhotoPreviewViewController
@interface MFPhotoPreviewViewController () <UICollectionViewDataSource,
    UICollectionViewDelegate,
    MFCheckboxDelegate,
    MFPhotoToolBarDelegate,
    MFPhotoCellDelegate>
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* assets;
@property (nonatomic, assign) NSMutableArray* selectedAssets;
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, strong) MFPhotoToolBar* toolBar;
@property (nonatomic, strong) MFCheckbox* checkButton;
//TODO
//@property (nonatomic, strong) APToastView* toast;
@property (nonatomic, assign) BOOL sending;
@end

@implementation MFPhotoPreviewViewController
- (id)initWithAssets:(NSArray*)assets atIndex:(NSInteger)index selectedAssets:(NSMutableArray*)selectedAssets
{
    self = [super initWithNibName:nil bundle:nil];
    if ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.selectedAssets = selectedAssets;
    self.assets = assets;
    self.photoIndex = index;
    self.sending = NO;
    return self;
}

- (void)startToastWithText:(NSString*)text
{
//TODO
//    self.toast = [APToastView presentToastWithin:self.view withIcon:APToastIconLoading text:text];
}

- (void)endToast
{
//TODO
//    [self.toast dismissToast];
}

- (void)onFinishButtonClick:(MFPhotoToolBar*)sender;
{
    if (!self.sending) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startToastWithText:@"正在处理 ..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self.delegate respondsToSelector:@selector(didFinishPreviewViewWithImageInfo:photoIndex:theOriginal:)]) {
                    self.sending = YES;
                    [self.delegate didFinishPreviewViewWithImageInfo:nil photoIndex:self.photoIndex theOriginal:_checkButton.checked];
                }
            });
        });
    }
}

- (void)onCheckState:(MFCheckbox*)sender
{

        dispatch_async(dispatch_get_main_queue(), ^{
            MFCheckbox* check = (MFCheckbox*)sender;
            if (!check.checked) {
                ALAsset* aset = self.assets[self.photoIndex];
                for (ALAsset* _aset in self.selectedAssets) {
                    if (_aset == aset) {
                        [self.selectedAssets removeObject:aset];
                        break;
                    }
                }
            }
            else {
                if (self.selectedAssets.count >= self.maximumNumberOfSelection) {
                    sender.checked = NO;
//TODO
//                    NSString *text = [NSString stringWithFormat:@"最多只能选择%zi张照片",self.maximumNumberOfSelection];
//
//                    APAlertView *detailAlert = [[APAlertView alloc] initWithTitle:nil
//                                                                          message:text
//                                                                         delegate:self
//                                                                cancelButtonTitle:nil
//                                                                otherButtonTitles:@"确定", nil];
//                    [detailAlert show];
                }else {
                    ALAsset* aset = self.assets[self.photoIndex];
                    [self.selectedAssets addObject:aset];
                }
            }

            self.toolBar.badgeButton.badgeNumber = self.selectedAssets.count;
        });
    
}

- (UICollectionViewFlowLayout*)defaultViewLayout
{
    UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kDeviceWidth, KDeviceHeight);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    return layout;
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    return self;
}

- (void)setupUI
{
    [self setupCollectionView];

    if (nil == self.toolBar) {
        CGRect rect = self.view.bounds;
        rect.origin.y = rect.size.height - TOOLBAR_HEIGHT;
        rect.size.height = TOOLBAR_HEIGHT;
        self.toolBar = [[MFPhotoToolBar alloc] initWithFrame:rect];
        self.toolBar.delegate = self;
        [self.view addSubview:self.toolBar];
        [self.toolBar.badgeButton setBadgeNumber:self.selectedAssets.count];
        [self.toolBar enable];
    }

    if (nil == self.checkButton) {
        CGSize size = [MFCheckbox checkSize];
        self.checkButton = [[MFCheckbox alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        self.checkButton.delegate = self;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.checkButton];
    }
}

- (void)setupCollectionView
{
    if (nil == self.collectionView) {
        UICollectionViewFlowLayout* flowLayout = [self defaultViewLayout];
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:flowLayout];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:self.collectionView];
    }

    [self.collectionView setPagingEnabled:YES];
    [self.collectionView registerClass:[MFPhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    [self.collectionView setFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight)];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.photoIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
}

#pragma mark - UICollectionViewDatasource
- (void)collectionView:(UICollectionView*)collectionView willDisplayCell:(UICollectionViewCell*)cell forItemAtIndexPath:(NSIndexPath*)indexPath
{
}

- (NSInteger)collectionView:(UICollectionView*)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath*)indexPath
{
    MFPhotoCell* cell = (MFPhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell"
                                                                                forIndexPath:indexPath];
    cell.delegate = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ALAsset* asset = self.assets[indexPath.row];
        UIImage* image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell setPhoto:image];

            for (ALAsset* _asset in self.selectedAssets) {
                if (_asset == asset) { //打勾
                    self.checkButton.checked = YES;
                    break;
                }
                else {
                    self.checkButton.checked = NO;
                }
            }

            self.toolBar.asset = asset;
            self.photoIndex = indexPath.row;
            [self.toolBar onRadioState:self.toolBar.radioBox];
        });
    });

    return cell;
}

- (void)collectionView:(UICollectionView*)collectionView didSelectItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"selected: %zd", indexPath.row);
}

#pragma mark MFPhotoCell Delegate
- (void)singleTapPhotoCell:(MFPhotoCell*)sender
{
    if (self.navigationController.navigationBarHidden) {
        [self exitFullScreenMode];
    }
    else {
        [self enterFullScreenMode];
    }
}
#pragma mark Show/Hide NavBar
- (void)enterFullScreenMode
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //隐藏tabbar
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                     animations:^{
                         CGRect rect = self.view.bounds;
                         rect.origin.y = rect.size.height;
                         rect.size.height = 45;
                         [self.toolBar setFrame:rect];
                     }];
}

- (void)exitFullScreenMode
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //隐藏tabbar
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration
                     animations:^{
                         CGRect rect = self.view.bounds;
                         rect.origin.y = rect.size.height - 45;
                         rect.size.height = 45;
                         [self.toolBar setFrame:rect];
                     }];
}
@end
