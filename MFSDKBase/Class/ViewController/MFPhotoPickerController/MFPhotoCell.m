//
//  MFPhotoCell.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/22.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFPhotoCell.h"
#import "MFImageBrowser.h"
@interface MFPhotoCell () <UIScrollViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* imageView;
@property (nonatomic, strong) UITapGestureRecognizer* singleTap;
@property (nonatomic, assign) CGFloat currentScale;
@end

@implementation MFPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupImageView];
        [self setTapGestureRecognizer:self.imageView];
        [self setTapGestureRecognizer:self.imageView];
    }
    return self;
}

- (void)setupImageView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.delegate = self;
    self.scrollView.bouncesZoom = YES;
    self.scrollView.minimumZoomScale = 1;
    self.scrollView.maximumZoomScale = 2;
    self.scrollView.contentSize = self.frame.size;
    [self addSubview:self.scrollView];

    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.opaque = YES;
    [self.scrollView addSubview:self.imageView];
}

- (void)setTapGestureRecognizer:(UIView*)view
{
    UITapGestureRecognizer* singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer setNumberOfTapsRequired:1];

    [view addGestureRecognizer:singleTapGestureRecognizer];

    UITapGestureRecognizer* doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [view addGestureRecognizer:doubleTapGestureRecognizer];

    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    view.userInteractionEnabled = YES;
}

- (void)singleTap:(UIGestureRecognizer*)gestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(singleTapPhotoCell:)]) {
        [self.delegate singleTapPhotoCell:self];
    }
}

- (void)doubleTap:(UIGestureRecognizer*)gestureRecognizer
{
    UIScrollView* theScroll = self.scrollView;
    CGFloat maxScale = self.scrollView.maximumZoomScale;
    CGFloat minScale = self.scrollView.minimumZoomScale;

    if (_currentScale == maxScale) {
        _currentScale = minScale;
        [theScroll setZoomScale:_currentScale animated:YES];
        return;
    }
    if (_currentScale == minScale) {
        _currentScale = maxScale;
        [theScroll setZoomScale:_currentScale animated:YES];
        return;
    }

    CGFloat aveScale = minScale + (maxScale - minScale) / 2.0; //中间倍数
    if (_currentScale >= aveScale) {
        _currentScale = maxScale;
        [theScroll setZoomScale:_currentScale animated:YES];
        return;
    }
    if (_currentScale < aveScale) {
        _currentScale = maxScale;
        [theScroll setZoomScale:_currentScale animated:YES];
        return;
    }
}

#pragma mark scollView Delegate
- (void)scrollViewDidZoom:(UIScrollView*)scrollView
{
    [self positionControl:scrollView];
}

- (void)scrollViewDidEndZooming:(UIScrollView*)scrollView withView:(UIView*)view atScale:(CGFloat)scale
{
    _currentScale = scale;
}

- (UIView*)viewForZoomingInScrollView:(UIScrollView*)scrollView
{
    return self.imageView;
}

- (void)positionControl:(UIScrollView*)scrollView
{
    CGFloat xcenter = scrollView.center.x, ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : ycenter;
    [self.imageView setCenter:CGPointMake(xcenter, ycenter)];
}

- (void)layoutImageView
{
    CGSize fitImageSize = CGSizeZero;
    //step 1
    if (self.imageView.image.size.width > self.bounds.size.width) {
        fitImageSize.width = self.bounds.size.width;
        fitImageSize.height = self.bounds.size.width * self.imageView.image.size.height / self.imageView.image.size.width;
    }
    else {
        fitImageSize = self.imageView.image.size;
    }
    //step 2
    if (fitImageSize.height > self.bounds.size.height) {
        self.imageView.frame = CGRectMake(0, 0, fitImageSize.width, fitImageSize.height);
    }
    else {
        self.imageView.frame = CGRectMake(0, (self.bounds.size.height - fitImageSize.height) / 2, fitImageSize.width, fitImageSize.height);
    }
}

- (void)setPhoto:(UIImage*)photo
{
    _photo = photo;
    [self.imageView setImage:_photo];
    [self.scrollView setZoomScale:1.0f animated:NO];
    [self layoutImageView];
}
@end
