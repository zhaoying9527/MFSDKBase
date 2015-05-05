//
//  MFAssetViewController.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/22.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFPhotoPickerController.h"
#import "MFPhotoPreviewViewController.h"
#import "MFPhoto.h"
#import "MFBadgeButton.h"
#import "UIView+Sizes.h"

#define kAssetThumbnailLength 60.0f
//#define kThumbnailLength  [[UIScreen mainScreen] bounds].size.width/4.0-2//78.0f
//#define kThumbnailSize CGSizeMake(kThumbnailLength, kThumbnailLength)
//#define kPopoverContentSize [[UIScreen mainScreen] bounds].size

#pragma mark -

@interface NSDate (TimeInterval)

+ (NSDateComponents*)componetsWithTimeInterval:(NSTimeInterval)timeInterval;
+ (NSString*)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval;

@end

@implementation NSDate (TimeInterval)

+ (NSDateComponents*)componetsWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSCalendar* calendar = [NSCalendar currentCalendar];

    NSDate* date1 = [[NSDate alloc] init];
    NSDate* date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date1];

    unsigned int unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;

    return [calendar components:unitFlags
                       fromDate:date1
                         toDate:date2
                        options:0];
}

+ (NSString*)timeDescriptionOfTimeInterval:(NSTimeInterval)timeInterval
{
    NSDateComponents* components = [self.class componetsWithTimeInterval:timeInterval];
    NSInteger roundedSeconds = lround(timeInterval - (components.hour * 60) - (components.minute * 60 * 60));

    if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ld:%02ld:%02ld", (long)components.hour, (long)components.minute, (long)roundedSeconds];
    }

    else {
        return [NSString stringWithFormat:@"%ld:%02ld", (long)components.minute, (long)roundedSeconds];
    }
}

@end

#pragma mark - MFPickerToolBar
@interface MFPickerToolBar ()
@property (nonatomic, strong) UIButton* previewButton;
@property (nonatomic, strong) UIButton* sendButton;
@property (nonatomic, strong) MFBadgeButton* badgeBtn;
@end

@implementation MFPickerToolBar
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }

    return self;
}

- (void)setBadgeNumber:(NSInteger)number
{
    [self.badgeBtn setBadgeNumber:number];
}

- (void)setDisableState:(BOOL)state
{
    if (state) {
        self.userInteractionEnabled = NO;
        self.sendButton.alpha = 0.35;
        self.previewButton.alpha = 0.35;
    }
    else {
        self.sendButton.alpha = 1.0;
        self.previewButton.alpha = 1.0;
        self.userInteractionEnabled = YES;
    }
}

- (void)setupUI
{
    CGRect rect = self.bounds;
    rect.size.height = 0.5;
    UILabel* line = [[UILabel alloc] initWithFrame:rect];
    line.alpha = 0.75;
    line.opaque = YES;
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];

    self.backgroundColor = [UIColor whiteColor];
    self.sendButton = [[UIButton alloc] init];
    self.sendButton.frame = CGRectMake(self.bounds.size.width - 60, 0, 60, self.bounds.size.height);
    [self.sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.sendButton setTitleColor:BLUETEXTCOLOR forState:UIControlStateNormal];
    [self addSubview:self.sendButton];
    [self.sendButton addTarget:self action:@selector(onSendButtonClick) forControlEvents:UIControlEventTouchUpInside];

    self.previewButton = [[UIButton alloc] init];
    self.previewButton.frame = CGRectMake(0, 0, 60, self.bounds.size.height);
    [self.previewButton setTitle:@"预览" forState:UIControlStateNormal];
    [self.previewButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.previewButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:self.previewButton];
    [self.previewButton addTarget:self action:@selector(onPreviewClick) forControlEvents:UIControlEventTouchUpInside];

    CGSize badgeSize = [MFBadgeButton badgeSize];
    self.badgeBtn = [[MFBadgeButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - badgeSize.width - 50,
                                                             (self.bounds.size.height - badgeSize.height) / 2,
                                                             badgeSize.width,
                                                             badgeSize.height)];
    [self addSubview:self.badgeBtn];
}

- (void)onSendButtonClick
{
    if ([self.delegate respondsToSelector:@selector(onSendButtonClick)]) {
        [self.delegate onSendButtonClick];
    }
}

- (void)onPreviewClick
{
    if ([self.delegate respondsToSelector:@selector(onPreviewButtonClick)]) {
        [self.delegate onPreviewButtonClick];
    }
}
@end

#pragma mark - MFPhotoPickerController

@interface MFPhotoPickerController ()

@property (nonatomic, copy) NSArray* indexPathsForSelectedItems;

@end

#pragma mark - MFVideoTitleView

@implementation MFVideoTitleView

- (void)drawRect:(CGRect)rect
{
    CGFloat colors[] = {
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.8,
        0.0, 0.0, 0.0, 1.0
    };

    CGFloat locations[] = { 0.0, 0.75, 1.0 };

    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, locations, 2);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGFloat height = rect.size.height;
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), height);
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation);

    CGSize titleSize = [self.text sizeWithFont:self.font];
    [self.textColor set];
    [self.text drawAtPoint:CGPointMake(rect.size.width - titleSize.width - 2, (height - 12) / 2)
                  forWidth:kThumbnailLength
                  withFont:self.font
                  fontSize:12
             lineBreakMode:NSLineBreakByTruncatingTail
        baselineAdjustment:UIBaselineAdjustmentAlignCenters];

    UIImage* videoIcon = [UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MFSDK.bundle/basePhotoPicker/AssetsPickerVideo@2x.png"]];

    [videoIcon drawAtPoint:CGPointMake(2, (height - videoIcon.size.height) / 2)];
    CFRelease(gradient);
    CFRelease(baseSpace);
}

@end

#pragma mark - MFTapAssetView

@interface MFTapAssetView ()

@property (nonatomic, retain) UIImageView* selectView;

@end

@implementation MFTapAssetView
static UIImage* uncheckedIcon;
static UIImage* checkedIcon;
static UIColor* selectedColor;
static UIColor* disabledColor;

+ (void)initialize
{
    uncheckedIcon = MFSDKImage(@"basePhotoPicker/unselected.png");
    checkedIcon = MFSDKImage(@"basePhotoPicker/selected.png");
    selectedColor = nil; //[UIColor colorWithWhite:1 alpha:0.3];
    disabledColor = nil; //[UIColor colorWithWhite:1 alpha:0.9];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _selectView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width - checkedIcon.size.width - 2, /*frame.size.height-checkedIcon.size.height*/ 2, checkedIcon.size.width, checkedIcon.size.height)];
        [self addSubview:_selectView];
    }
    return self;
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (_disabled) {
        return;
    }
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shouldTap)]) {
        if (![_delegate shouldTap] && !_selected) {
            return;
        }
    }

    UITouch* touch = [touches anyObject];
    NSInteger padding = 10;
    CGRect selectViewTouchRect = CGRectMake(_selectView.frame.origin.x - padding,
        _selectView.frame.origin.y,
        _selectView.frame.size.width + padding,
        _selectView.frame.size.height + padding);
    if (CGRectContainsPoint(selectViewTouchRect, [touch locationInView:self])) {
        if ((_selected = !_selected)) {
            [self check:YES withAnimated:YES];
        }
        else {
            [self check:NO withAnimated:NO];
        }
        if (_delegate != nil && [_delegate respondsToSelector:@selector(touchSelect:)]) {
            [_delegate touchSelect:_selected];
        }
    }
    else {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(touchDetailView)]) {
            [_delegate touchDetailView];
        }
    }
}

- (void)check:(BOOL)on withAnimated:(BOOL)animated
{
    if (on) {
        self.backgroundColor = selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
        [_selectView setImage:uncheckedIcon];
    }
    if (animated) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15
                delay:0.0
                options:UIViewAnimationOptionCurveEaseIn
                animations:^{
                    _selectView.transform = CGAffineTransformMakeScale(0.6, 0.6);
                }
                completion:^(BOOL finished) {
                    [UIView animateWithDuration:0.35
                        delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            _selectView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                        }
                        completion:^(BOOL finished){

                        }];

                }];
        });
    }
}

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    if (_disabled) {
        self.backgroundColor = disabledColor;
    }
    else {
        self.backgroundColor = [UIColor clearColor];
    }
}

- (void)setSelected:(BOOL)selected
{
    if (_disabled) {
        self.backgroundColor = disabledColor;
        [_selectView setImage:uncheckedIcon];
        return;
    }

    _selected = selected;
    if (_selected) {
        self.backgroundColor = selectedColor;
        [_selectView setImage:checkedIcon];
    }
    else {
        self.backgroundColor = [UIColor clearColor];
        [_selectView setImage:uncheckedIcon];
    }
}

@end

#pragma mark - MFAssetView

@interface MFAssetView () <MFTapAssetViewDelegate>

@property (nonatomic, strong) ALAsset* asset;

@property (nonatomic, weak) id<MFAssetViewDelegate> delegate;

@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) MFVideoTitleView* videoTitle;
@property (nonatomic, retain) MFTapAssetView* tapAssetView;

@end

@implementation MFAssetView

static UIFont* titleFont = nil;

static CGFloat titleHeight;
static UIColor* titleColor;

+ (void)initialize
{
    titleFont = [UIFont systemFontOfSize:12];
    titleHeight = 20.0f;
    titleColor = [UIColor whiteColor];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.opaque = YES;
        self.isAccessibilityElement = YES;
        self.accessibilityTraits = UIAccessibilityTraitImage;

        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kThumbnailSize.width, kThumbnailSize.height)];
        [self addSubview:_imageView];

        _videoTitle = [[MFVideoTitleView alloc] initWithFrame:CGRectMake(0, kThumbnailSize.height - 20, kThumbnailSize.width, titleHeight)];
        _videoTitle.hidden = YES;
        _videoTitle.font = titleFont;
        _videoTitle.textColor = titleColor;
        _videoTitle.textAlignment = NSTextAlignmentRight;
        _videoTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_videoTitle];

        _tapAssetView = [[MFTapAssetView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _tapAssetView.delegate = self;
        [self addSubview:_tapAssetView];
    }

    return self;
}

- (void)bind:(ALAsset*)asset selectionFilter:(NSPredicate*)selectionFilter isSeleced:(BOOL)isSeleced
{
    self.asset = asset;

    [_imageView setImage:[UIImage imageWithCGImage:asset.thumbnail]];

    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
        _videoTitle.hidden = NO;
        _videoTitle.text = [NSDate timeDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDuration] doubleValue]];
    }
    else {
        _videoTitle.hidden = YES;
    }

    _tapAssetView.disabled = ![selectionFilter evaluateWithObject:asset];

    _tapAssetView.selected = isSeleced;
}

#pragma mark - MFTapAssetView Delegate

- (BOOL)shouldTap
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shouldSelectAsset:)]) {
        return [_delegate shouldSelectAsset:_asset];
    }
    return YES;
}

- (void)touchSelect:(BOOL)select
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tapSelectHandle:asset:)]) {
        [_delegate tapSelectHandle:select asset:_asset];
    }
}

- (void)touchDetailView
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(tapSelectHandle:asset:)]) {
        [_delegate tapDetailHandle:_asset];
    }
}
@end

#pragma mark - MFAssetViewCell

@interface MFAssetViewCell () <MFAssetViewDelegate>

@end

@class MFAssetViewController;

@implementation MFAssetViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    return self;
}

- (void)bind:(NSArray*)assets selectionFilter:(NSPredicate*)selectionFilter minimumInteritemSpacing:(float)minimumInteritemSpacing minimumLineSpacing:(float)minimumLineSpacing columns:(int)columns assetViewX:(float)assetViewX
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.contentView.subviews.count < assets.count) {
            for (int i = 0; i < assets.count; i++) {
                if (i > ((NSInteger)self.contentView.subviews.count - 1)) {
                    MFAssetView* assetView = [[MFAssetView alloc] initWithFrame:CGRectMake(assetViewX + (kThumbnailSize.width + minimumInteritemSpacing) * i, minimumLineSpacing - 1, kThumbnailSize.width, kThumbnailSize.height)];
                    [assetView bind:assets[i] selectionFilter:selectionFilter isSeleced:[((MFAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i]]];
                    assetView.delegate = self;
                    [self.contentView addSubview:assetView];
                }
                else {
                    ((MFAssetView*)self.contentView.subviews[i]).frame = CGRectMake(assetViewX + (kThumbnailSize.width + minimumInteritemSpacing) * (i), minimumLineSpacing - 1, kThumbnailSize.width, kThumbnailSize.height);
                    [(MFAssetView*)self.contentView.subviews[i] bind:assets[i] selectionFilter:selectionFilter isSeleced:[((MFAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i]]];
                }
            }
        }
        else {
            for (NSUInteger i = self.contentView.subviews.count; i > 0; i--) {
                if (i > assets.count) {
                    [((MFAssetView*)self.contentView.subviews[i - 1])removeFromSuperview];
                }
                else {
                    ((MFAssetView*)self.contentView.subviews[i - 1]).frame = CGRectMake(assetViewX + (kThumbnailSize.width + minimumInteritemSpacing) * (i - 1), minimumLineSpacing - 1, kThumbnailSize.width, kThumbnailSize.height);
                    [(MFAssetView*)self.contentView.subviews[i - 1] bind:assets[i - 1] selectionFilter:selectionFilter isSeleced:[((MFAssetViewController*)_delegate).indexPathsForSelectedItems containsObject:assets[i - 1]]];
                }
            }
        }
    });
}

#pragma mark - MFAssetView Delegate

- (BOOL)shouldSelectAsset:(ALAsset*)asset
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(shouldSelectAsset:)]) {
        return [_delegate shouldSelectAsset:asset];
    }
    return YES;
}

- (void)tapSelectHandle:(BOOL)select asset:(ALAsset*)asset
{
    if (select) {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectAsset:)]) {
            [_delegate didSelectAsset:asset];
        }
    }
    else {
        if (_delegate != nil && [_delegate respondsToSelector:@selector(didDeselectAsset:)]) {
            [_delegate didDeselectAsset:asset];
        }
    }
}

- (void)tapDetailHandle:(ALAsset*)asset
{
    if (_delegate != nil && [_delegate respondsToSelector:@selector(didSelectAssetForDetail:)]) {
        [_delegate didSelectAssetForDetail:asset];
    }
}
@end

#pragma mark - MFAssetViewController

@interface MFAssetViewController () <MFAssetViewCellDelegate, MFPickerToolBarDelegate, MFPhotoPreviewViewControllerDelegate> {
    int columns;

    float minimumInteritemSpacing;
    float minimumLineSpacing;

    BOOL unFirst;
}

@property (nonatomic, strong) NSMutableArray* assets;
@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;
@property (nonatomic, strong) MFPickerToolBar* toolBar;
@property (nonatomic, assign) BOOL theOriginalMode;
@property (nonatomic, assign) NSInteger currentPreviewPhotoIndex;
//TODO
//@property (nonatomic, strong) APToastView* toast;
@property (nonatomic, assign) BOOL sending;
@end

#define kAssetViewCellIdentifier @"AssetViewCellIdentifier"

@implementation MFAssetViewController

- (id)init
{
    self = [super init];

    [self setupViews];

    [self setupButtons];

    _indexPathsForSelectedItems = [[NSMutableArray alloc] init];

    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 2.0, 0, 2.0);

        minimumInteritemSpacing = 3;
        minimumLineSpacing = 3;
    }
    else {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);

        minimumInteritemSpacing = 2;
        minimumLineSpacing = 2;
    }

    if (self) {
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
            [self setEdgesForExtendedLayout:UIRectEdgeAll];

        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
    }

    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.sending = NO;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)reloadData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        self.toolBar.badgeNumber = _indexPathsForSelectedItems.count;
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!unFirst) {
        columns = floor(self.view.frame.size.width / (kThumbnailSize.width + minimumInteritemSpacing));

        [self setupAssets];

        unFirst = YES;
    }

    [self reloadData];
}
#pragma mark - MFPickerTool delegate
- (void)onSendButtonClick
{
    //缩略图页面发送
    self.theOriginalMode = NO;
    [self finishPickingPhotos];
}

- (void)onPreviewButtonClick
{
    MFPhotoPreviewViewController* vc = [[MFPhotoPreviewViewController alloc] initWithAssets:_indexPathsForSelectedItems
                                                                                    atIndex:0
                                                                             selectedAssets:_indexPathsForSelectedItems];
    vc.maximumNumberOfSelection = self.maximumNumberOfSelection;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 预览界面回调
- (void)didFinishPreviewViewWithImageInfo:(NSArray*)imageInfo photoIndex:(NSInteger)photoIndex theOriginal:(BOOL)theOriginal
{
    self.currentPreviewPhotoIndex = photoIndex;
    self.theOriginalMode = theOriginal;
    [self finishPickingPhotos];
}
#pragma mark - Rotation

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);

        minimumInteritemSpacing = 3;
        minimumLineSpacing = 3;
    }
    else {
        self.tableView.contentInset = UIEdgeInsetsMake(9.0, 0, 0, 0);

        minimumInteritemSpacing = 2;
        minimumLineSpacing = 2;
    }

    columns = floor(self.view.frame.size.width / (kThumbnailSize.width + minimumInteritemSpacing));

    [self.tableView reloadData];
}

#pragma mark - Setup

- (void)setupViews
{
    if (nil == self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.tableView];
    }

    if (nil == self.toolBar) {
        CGRect rect = self.view.bounds;
        rect.origin.y = rect.size.height - 44;
        rect.size.height = 44;
        self.toolBar = [[MFPickerToolBar alloc] initWithFrame:rect];
        self.toolBar.delegate = self;
        [self.view addSubview:self.toolBar];
    }

    self.toolBar.disableState = YES;
}

- (void)setupButtons
{
    self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(onCancelPickingAssets:)];
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

- (void)setupAssets
{
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.numberOfPhotos = 0;
    self.numberOfVideos = 0;

    if (!self.assets)
        self.assets = [[NSMutableArray alloc] init];
    else
        [self.assets removeAllObjects];

    ALAssetsGroupEnumerationResultsBlock resultsBlock = ^(ALAsset* asset, NSUInteger index, BOOL* stop) {

        if (asset) {
            [self.assets addObject:asset];

            NSString* type = [asset valueForProperty:ALAssetPropertyType];

            if ([type isEqual:ALAssetTypePhoto])
                self.numberOfPhotos++;
            if ([type isEqual:ALAssetTypeVideo])
                self.numberOfVideos++;
        }
        else if (self.assets.count > 0) {
            [self.tableView reloadData];

            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ceil(self.assets.count * 1.0 / columns) inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }

        [self endToast];
    };

    [self.assetsGroup enumerateAssetsUsingBlock:resultsBlock];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    return NO;
}

#pragma mark - UITableView DataSource
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{

    if (indexPath.row == ceil(self.assets.count * 1.0 / columns)) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cellFooter"];

        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellFooter"];
            cell.opaque = YES;
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor blackColor];
            cell.backgroundColor = [UIColor clearColor];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        NSString* title;

        if (_numberOfVideos == 0) {
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片", nil), (long)_numberOfPhotos];
        }
        else if (_numberOfPhotos == 0) {
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 部视频", nil), (long)_numberOfVideos];
        }
        else {
            title = [NSString stringWithFormat:NSLocalizedString(@"%ld 张照片, %ld 部视频", nil), (long)_numberOfPhotos, (long)_numberOfVideos];
        }

        cell.textLabel.text = title;
        return cell;
    }
    else {

        static NSString* CellIdentifier = kAssetViewCellIdentifier;
        MFPhotoPickerController* picker = (MFPhotoPickerController*)self.navigationController;

        MFAssetViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MFAssetViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        cell.delegate = self;

        NSMutableArray* tempAssets = [[NSMutableArray alloc] init];
        for (int i = 0; i < columns; i++) {
            if ((indexPath.row * columns + i) < self.assets.count) {
                [tempAssets addObject:[self.assets objectAtIndex:indexPath.row * columns + i]];
            }
        }

        [cell bind:tempAssets selectionFilter:picker.selectionFilter minimumInteritemSpacing:minimumInteritemSpacing minimumLineSpacing:minimumLineSpacing columns:columns assetViewX:(self.tableView.frame.size.width - kThumbnailSize.width * tempAssets.count - minimumInteritemSpacing * (tempAssets.count - 1)) / 2];
        return cell;
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil(self.assets.count * 1.0 / columns) + 1;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == ceil(self.assets.count * 1.0 / columns)) {
        return 44;
    }
    return kThumbnailSize.height + minimumLineSpacing;
}

#pragma mark - MFAssetViewCell Delegate

- (BOOL)shouldSelectAsset:(ALAsset*)asset
{
    MFPhotoPickerController* vc = (MFPhotoPickerController*)self.navigationController;
    BOOL selectable = [vc.selectionFilter evaluateWithObject:asset];
    if (_indexPathsForSelectedItems.count >= vc.maximumNumberOfSelection) {
        if (vc.delegate != nil && [vc.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)]) {
            [vc.delegate assetPickerControllerDidMaximum:vc];
        }
    }

    return (selectable && _indexPathsForSelectedItems.count < vc.maximumNumberOfSelection);
}

- (NSUInteger)getAssetIndex:(ALAsset*)asset
{
    NSInteger retIndex = 0;
    for (int i = 0; i < self.assets.count; i++) {
        if (self.assets[i] == asset) {
            retIndex = i;
            break;
        }
    }
    return retIndex;
}

- (void)checkDisableState
{
    if (_indexPathsForSelectedItems.count > 0) {
        self.toolBar.disableState = NO;
    }
    else {
        self.toolBar.disableState = YES;
    }
}

- (void)updateBadgeNumbers
{
    self.toolBar.badgeNumber = _indexPathsForSelectedItems.count;
}

- (void)didSelectAssetForDetail:(ALAsset*)asset
{
    self.currentPreviewPhotoIndex = [self getAssetIndex:asset];
    MFPhotoPreviewViewController* vc = [[MFPhotoPreviewViewController alloc] initWithAssets:self.assets
                                                                                    atIndex:self.currentPreviewPhotoIndex
                                                                             selectedAssets:_indexPathsForSelectedItems];
    vc.maximumNumberOfSelection = self.maximumNumberOfSelection;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didSelectAsset:(ALAsset*)asset
{
 
    [_indexPathsForSelectedItems addObject:asset];

    MFPhotoPickerController* vc = (MFPhotoPickerController*)self.navigationController;
    vc.indexPathsForSelectedItems = _indexPathsForSelectedItems;

    if (vc.delegate != nil && [vc.delegate respondsToSelector:@selector(assetPickerController:didSelectAsset:)])
        [vc.delegate assetPickerController:vc didSelectAsset:asset];

    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];

    [self checkDisableState];
    [self updateBadgeNumbers];
}

- (void)didDeselectAsset:(ALAsset*)asset
{
    [_indexPathsForSelectedItems removeObject:asset];

    MFPhotoPickerController* vc = (MFPhotoPickerController*)self.navigationController;
    vc.indexPathsForSelectedItems = _indexPathsForSelectedItems;

    if (vc.delegate != nil && [vc.delegate respondsToSelector:@selector(assetPickerController:didDeselectAsset:)])
        [vc.delegate assetPickerController:vc didDeselectAsset:asset];

    [self setTitleWithSelectedIndexPaths:_indexPathsForSelectedItems];

    [self checkDisableState];
    [self updateBadgeNumbers];
}

#pragma mark - Title

- (void)setTitleWithSelectedIndexPaths:(NSArray*)indexPaths
{
    // Reset title to group name
    if (indexPaths.count == 0) {
        self.title = @"照片"; //[self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
        return;
    }

    BOOL photosSelected = NO;
    BOOL videoSelected = NO;

    for (int i = 0; i < indexPaths.count; i++) {
        ALAsset* asset = indexPaths[i];

        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto])
            photosSelected = YES;

        if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
            videoSelected = YES;

        if (photosSelected && videoSelected)
            break;
    }
    /*
    NSString *format;
    
    if (photosSelected && videoSelected)
        format = NSLocalizedString(@"已选择 %ld 个项目", nil);
    
    else if (photosSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 张照片", nil) : NSLocalizedString(@"已选择 %ld 张照片 ", nil);
    
    else if (videoSelected)
        format = (indexPaths.count > 1) ? NSLocalizedString(@"已选择 %ld 部视频", nil) : NSLocalizedString(@"已选择 %ld 部视频 ", nil);
    */
    self.title = @"照片"; //[NSString stringWithFormat:format, (long)indexPaths.count];
}

#pragma mark - Actions
- (void)finishPickingPhotos
{
    MFPhotoPickerController* picker = (MFPhotoPickerController*)self.navigationController;

    if (_indexPathsForSelectedItems.count < picker.minimumNumberOfSelection) {
        if (picker.delegate != nil && [picker.delegate respondsToSelector:@selector(assetPickerControllerDidMaximum:)]) {
            [picker.delegate assetPickerControllerDidMaximum:picker];
        }
    }

    /*
     if ([picker.delegate respondsToSelector:@selector(assetPickerController:didFinishPickingAssets:)])
     [picker.delegate assetPickerController:picker didFinishPickingAssets:_indexPathsForSelectedItems];
    */
    
    if (!self.sending) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self startToastWithText:@"正在处理 ..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_indexPathsForSelectedItems.count == 0) {
                    ALAsset* aset = [self.assets objectAtIndex:self.currentPreviewPhotoIndex];
                    if (nil != aset) {
                        [_indexPathsForSelectedItems addObject:aset];
                    }
                }
                
                if ([picker.delegate respondsToSelector:@selector(didFinishPickingMediaWithImageInfo:imageInfo:theOiginal:)]) {
                    self.sending = YES;
                    [picker.delegate didFinishPickingMediaWithImageInfo:picker imageInfo:_indexPathsForSelectedItems theOiginal:self.theOriginalMode];
                }
            });
        });
    }
}

- (void)onCancelPickingAssets:(id)sender
{
    MFPhotoPickerController* picker = (MFPhotoPickerController*)self.navigationController;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([picker.delegate respondsToSelector:@selector(assetPickerControllerDidCancel:)]) {
            [picker.delegate assetPickerControllerDidCancel:picker];
        }

        if (picker.isFinishDismissViewController) {
            [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
        }
    });
}

- (void)finishPickingAssets:(id)sender
{
    [self finishPickingPhotos];
}

@end

#pragma mark - MFAssetGroupViewCell

@interface MFAssetGroupViewCell ()

@property (nonatomic, strong) ALAssetsGroup* assetsGroup;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *memoLabel;
@end

@implementation MFAssetGroupViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
 
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{

    self.opaque = YES;
    
    if (nil == self.photoImageView) {
        self.photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.photoImageView.opaque = YES;
        [self addSubview:self.photoImageView];
    }
    
    if (nil == self.titleLabel) {
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.opaque = YES;
        [self addSubview:self.titleLabel];
    }
    
    if (nil == self.memoLabel) {
        self.memoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.memoLabel.font = [UIFont systemFontOfSize:17];
        self.memoLabel.textColor = [UIColor lightGrayColor];
        self.memoLabel.opaque = YES;
        [self addSubview:self.memoLabel];
    }
}


- (void)bind:(ALAssetsGroup*)assetsGroup
{
    self.assetsGroup = assetsGroup;

    CGImageRef posterImage = assetsGroup.posterImage;
    size_t height = CGImageGetHeight(posterImage);
    float scale = height / kThumbnailLength;

    self.photoImageView.image = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
    self.titleLabel.text = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    self.memoLabel.text = [NSString stringWithFormat:@"(%ld)", (long)[assetsGroup numberOfAssets]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.photoImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font];
    if (titleSize.width > 2*self.frame.size.width/3) {
        titleSize.width = 2*self.frame.size.width/3;
    }
    self.titleLabel.frame = CGRectMake(self.frame.size.height+12, 0, titleSize.width, self.frame.size.height);
    self.memoLabel.frame = CGRectMake(self.titleLabel.frame.origin.x + self.titleLabel.frame.size.width+10, 0, 60, self.height);
}

- (NSString*)accessibilityLabel
{
    NSString* label = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];

    return [label stringByAppendingFormat:NSLocalizedString(@"%ld 张照片", nil), (long)[self.assetsGroup numberOfAssets]];
}

@end

#pragma mark - MFAssetGroupViewController

@interface MFAssetGroupViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) ALAssetsLibrary* assetsLibrary;
@property (nonatomic, strong) NSMutableArray* groups;
//TODO
//@property (nonatomic, strong) APToastView* toast;
@end

@implementation MFAssetGroupViewController

- (id)init
{
    //    if (self = [super initWithStyle:UITableViewStylePlain])
    //    {
    //#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
    //        self.preferredContentSize=kPopoverContentSize;
    //#else
    //        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
    //            [self setContentSizeForViewInPopover:kPopoverContentSize];
    //#endif
    //    }
    //
    self = [super initWithNibName:nil bundle:nil];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupViews];
    [self setupButtons];
    [self localize];
    [self setupGroup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

#pragma mark - Setup

- (void)setupViews
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setupButtons
{
    MFPhotoPickerController* picker = (MFPhotoPickerController*)self.navigationController;

    if (picker.showCancelButton) {
        self.navigationItem.rightBarButtonItem =
            [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"取消", nil)
                                             style:UIBarButtonItemStylePlain
                                            target:self
                                            action:@selector(dismiss:)];
    }
}

- (void)localize
{
    self.title = NSLocalizedString(@"照片", nil);
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

- (void)setupGroup
{
    if (!self.assetsLibrary)
        self.assetsLibrary = [self.class defaultAssetsLibrary];

    if (!self.groups)
        self.groups = [[NSMutableArray alloc] init];
    else
        [self.groups removeAllObjects];

    //转菊花
    //[self startToastWithText:@"正在加载 ..."];
    MFPhotoPickerController* picker = (MFPhotoPickerController*)self.navigationController;
    ALAssetsFilter* assetsFilter = picker.assetsFilter;

    ALAssetsLibraryGroupsEnumerationResultsBlock resultsBlock = ^(ALAssetsGroup* group, BOOL* stop) {

        if (group) {
            [group setAssetsFilter:assetsFilter];
            if (group.numberOfAssets > 0 || picker.showEmptyGroups)
                [self.groups addObject:group];
        }
        else {
            [self reloadData];
            [self endToast];

            if (self.groups.count > 0) {
                if (![self.navigationController.topViewController isKindOfClass:[MFAssetViewController class]]) {
                    MFAssetViewController* vc = [[MFAssetViewController alloc] init];
                    vc.maximumNumberOfSelection = 9;
                    vc.assetsGroup = [self.groups objectAtIndex:0];
                    [self.navigationController pushViewController:vc animated:NO];
                }
            }
        }
    };

    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError* error) {

        [self showNotAllowed];

    };

    // Enumerate Camera roll first
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];

    // Then all other groups
    NSUInteger type = ALAssetsGroupLibrary | ALAssetsGroupAlbum | ALAssetsGroupEvent | ALAssetsGroupFaces | ALAssetsGroupPhotoStream;

    [self.assetsLibrary enumerateGroupsWithTypes:type
                                      usingBlock:resultsBlock
                                    failureBlock:failureBlock];
}

#pragma mark - Reload Data

- (void)reloadData
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if (self.groups.count == 0)
        [self showNoAssets];

    [self.tableView reloadData];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    return NO;
}
#pragma mark - ALAssetsLibrary

+ (ALAssetsLibrary*)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary* library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - Not allowed / No assets

- (void)showNotAllowed
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom];

    self.title = nil;

    UIImageView* padlock = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"MFSDK.bundle/basePhotoPicker/AssetsPickerLocked@2x.png"]]];
    padlock.translatesAutoresizingMaskIntoConstraints = NO;

    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.preferredMaxLayoutWidth = 304.0f;

    UILabel* message = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.preferredMaxLayoutWidth = 304.0f;

    title.text = NSLocalizedString(@"此应用无法使用您的照片或视频。", nil);
    title.font = [UIFont boldSystemFontOfSize:17.0];
    title.textColor = [UIColor colorWithRed:129.0 / 255.0 green:136.0 / 255.0 blue:148.0 / 255.0 alpha:1];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 5;

    message.text = NSLocalizedString(@"你可以在「隐私设置」中启用存取。", nil);
    message.font = [UIFont systemFontOfSize:14.0];
    message.textColor = [UIColor colorWithRed:129.0 / 255.0 green:136.0 / 255.0 blue:148.0 / 255.0 alpha:1];
    message.textAlignment = NSTextAlignmentCenter;
    message.numberOfLines = 5;

    [title sizeToFit];
    [message sizeToFit];

    UIView* centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:padlock];
    [centerView addSubview:title];
    [centerView addSubview:message];

    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(padlock, title, message);

    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:padlock attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:padlock attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[padlock]-[title]-[message]|" options:0 metrics:nil views:viewsDictionary]];

    UIView* backgroundView = [UIView new];
    [backgroundView addSubview:centerView];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

    self.tableView.backgroundView = backgroundView;
}

- (void)showNoAssets
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
        [self setEdgesForExtendedLayout:UIRectEdgeLeft | UIRectEdgeRight | UIRectEdgeBottom];

    UILabel* title = [UILabel new];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.preferredMaxLayoutWidth = 304.0f;
    UILabel* message = [UILabel new];
    message.translatesAutoresizingMaskIntoConstraints = NO;
    message.preferredMaxLayoutWidth = 304.0f;

    title.text = NSLocalizedString(@"没有照片或视频。", nil);
    title.font = [UIFont systemFontOfSize:26.0];
    title.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1];
    title.textAlignment = NSTextAlignmentCenter;
    title.numberOfLines = 5;

    message.text = NSLocalizedString(@"您可以使用 iTunes 将照片和视频\n同步到 iPhone。", nil);
    message.font = [UIFont systemFontOfSize:18.0];
    message.textColor = [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1];
    message.textAlignment = NSTextAlignmentCenter;
    message.numberOfLines = 5;

    [title sizeToFit];
    [message sizeToFit];

    UIView* centerView = [UIView new];
    centerView.translatesAutoresizingMaskIntoConstraints = NO;
    [centerView addSubview:title];
    [centerView addSubview:message];

    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(title, message);

    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:title attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:centerView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraint:[NSLayoutConstraint constraintWithItem:message attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:title attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [centerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[title]-[message]|" options:0 metrics:nil views:viewsDictionary]];

    UIView* backgroundView = [UIView new];
    [backgroundView addSubview:centerView];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [backgroundView addConstraint:[NSLayoutConstraint constraintWithItem:centerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:backgroundView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];

    self.tableView.backgroundView = backgroundView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groups.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* CellIdentifier = @"Cell";

    MFAssetGroupViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MFAssetGroupViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    [cell bind:[self.groups objectAtIndex:indexPath.row]];

    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return kAssetThumbnailLength;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    MFAssetViewController* vc = [[MFAssetViewController alloc] init];
    vc.assetsGroup = [self.groups objectAtIndex:indexPath.row];
    vc.maximumNumberOfSelection = 9;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Actions

- (void)dismiss:(id)sender
{
    MFPhotoPickerController* picker = (MFPhotoPickerController*)self.navigationController;

    if ([picker.delegate respondsToSelector:@selector(assetPickerControllerDidCancel:)])
        [picker.delegate assetPickerControllerDidCancel:picker];

    [picker.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

@end

#pragma mark - MFPhotoPickerController
@interface MFPhotoPickerController ()

@end

@implementation MFPhotoPickerController

- (id)init
{
    MFAssetGroupViewController* groupViewController = [[MFAssetGroupViewController alloc] init];
    if (self = [super initWithRootViewController:groupViewController]) {
        _maximumNumberOfSelection = 9;
        _minimumNumberOfSelection = 0;
        _assetsFilter = [ALAssetsFilter allPhotos];
        _showCancelButton = YES;
        _showEmptyGroups = NO;
        _selectionFilter = [NSPredicate predicateWithValue:YES];
        _isFinishDismissViewController = YES;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_7_0
        self.preferredContentSize = kPopoverContentSize;
#else
        if ([self respondsToSelector:@selector(setContentSizeForViewInPopover:)])
            [self setContentSizeForViewInPopover:kPopoverContentSize];
#endif
        UINavigationBar* navBar = self.navigationBar;
        navBar.tintColor = [UIColor whiteColor];
        // 1.2.设置导航栏背景
        [navBar setBackgroundImage:MFSDKImage(@"basePhotoPicker/TabbarBkg.png") forBarMetrics:UIBarMetricsDefault];
        // 1.3.设置状态栏背景
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        // 1.4.设置导航栏的文字
        [navBar setTitleTextAttributes:@{
            UITextAttributeTextColor : [UIColor whiteColor],
            UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]
        }];
    }

    return self;
}
@end
