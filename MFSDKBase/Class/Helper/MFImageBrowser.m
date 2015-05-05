//
//  MFImageBrowser.m
//  MFSDK
//
//  Created by chicp on 15-3-31.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFImageBrowser.h"
#import "MFCloudImageView.h"
//TODO
//static BOOL isShow;

__weak UIView* cImageView = nil;

@implementation MFImageBrowser
+ (UIImage*)captureImageWithView:(UIView*)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)showImage:(MFCloudImageView*)avatarImageView delegate:(__weak id<UIScrollViewDelegate>)delegate
{
//TODO
//    UIImage* image = avatarImageView.image;
//    if (image == nil) {
//        return;
//    }
//    UIWindow* window = DTContextGet().window;
//    
//    UIScrollView *backgroundView = [[UIScrollView alloc] initWithFrame:window.bounds];
//    CGRect frame = [MFImageBrowser getMergeFrame:image inView:backgroundView];
//    
//    backgroundView.contentSize = frame.size;
//    backgroundView.maximumZoomScale = 2.0;
//    backgroundView.minimumZoomScale = 1;
//    backgroundView.delegate = delegate;
//    
//    cImageView = avatarImageView;
//    CGRect oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
//    backgroundView.backgroundColor = [UIColor blackColor];
//    backgroundView.alpha = 0;
//    UIImageView* imageView = [[UIImageView alloc] initWithFrame:oldframe];
//    imageView.image = avatarImageView.image; //image;
//    imageView.tag = 101;
//    imageView.image = image;
//    [backgroundView addSubview:imageView];
//    [window addSubview:backgroundView];
//    
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
//    [backgroundView addGestureRecognizer:tap];
//    [UIView animateWithDuration:0.3
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         imageView.frame = frame;
//                         backgroundView.alpha = 1;
//                     }
//                     completion:^(BOOL finished){
//                     }];
//    
//    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    activityView.center = window.center;
//    [backgroundView addSubview:activityView];
//    [activityView startAnimating];
//
//    backgroundView.scrollEnabled = NO;
//    MFCloudImageView* cloudImageView = [[MFCloudImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    [cloudImageView setImageWithURL:[NSURL URLWithString:avatarImageView.imageUrl]
//              placeholderImage:nil
//                    fitImageSize:CGSizeMake(0, 0)
//                     completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType) {
//                         backgroundView.scrollEnabled = YES;
//                         if(image){
//                             CGRect newFrame = [MFImageBrowser getMergeFrame:image inView:backgroundView];
//                             [UIView animateWithDuration:0.2
//                                                   delay:0.0
//                                                 options:UIViewAnimationOptionCurveEaseOut
//                                              animations:^{
//                                                  imageView.frame = newFrame;
//                                                  imageView.image = image;
//                                              }
//                                              completion:^(BOOL finished){
//                                                  
//                                              }];
//                         }
//                         [activityView stopAnimating];
//                     }];
}

+ (CGRect)getMergeFrame:(UIImage *)image inView:(UIView *)backgroundView{
    CGRect frame;
    CGFloat tempO = image.size.width / image.size.height;
    
    CGFloat tempS = backgroundView.bounds.size.width / backgroundView.bounds.size.height;
    if (tempO >= tempS) {
        //按宽缩放
//        if (image.size.width > backgroundView.frame.size.width) {
            frame = CGRectMake(0, (backgroundView.bounds.size.height - image.size.height * backgroundView.bounds.size.width / image.size.width) / 2, backgroundView.bounds.size.width, image.size.height * backgroundView.bounds.size.width / image.size.width);
//        }
//        else {
//            frame = CGRectMake((backgroundView.frame.size.width - image.size.width) / 2.0, (backgroundView.frame.size.height - image.size.height) / 2.0, image.size.width, image.size.height);
//        }
    }
    else {
        //按高缩放
//        if (image.size.height > backgroundView.frame.size.height) {
            frame = CGRectMake((backgroundView.frame.size.width - (image.size.width * backgroundView.frame.size.height / image.size.height)) / 2.0, 0, image.size.width * backgroundView.frame.size.height / image.size.height, backgroundView.frame.size.height);
//        }
//        else {
//            frame = CGRectMake((backgroundView.frame.size.width - image.size.width) / 2.0, (backgroundView.frame.size.height - image.size.height) / 2.0, image.size.width, image.size.height);
//        }
    }
    return frame;
}

+ (void)hideImage:(UITapGestureRecognizer*)tap
{
//    isShow = YES;
//    CGRect oldframe = [cImageView convertRect:cImageView.bounds toView:DTContextGet().window];
//    UIImage *captureImage =  [MFImageBrowser captureImageWithView:cImageView];
//    UIScrollView* backgroundView = (UIScrollView*)tap.view;
//    backgroundView.contentSize = backgroundView.frame.size;
//    UIImageView* imageView = (UIImageView*)[tap.view viewWithTag:101];
//    [UIView animateWithDuration:0.3
//        delay:0.0
//        options:UIViewAnimationOptionCurveEaseOut
//        animations:^{
//            imageView.frame = oldframe;
//            backgroundView.backgroundColor = [UIColor clearColor];
//            [UIView animateWithDuration:0.0
//                                  delay:0.0
//                                options:UIViewAnimationOptionCurveEaseIn
//                             animations:^{
//                                 imageView.image = captureImage;
//                             }completion:^(BOOL finished) {
//                               
//                             }];
//        }
//        completion:^(BOOL finished) {
//            [backgroundView removeFromSuperview];
//            cImageView = nil;
//        }];
//    backgroundView.delegate = nil;
}

+ (void)positionControl:(UIScrollView*)scrollView
{
    CGFloat xcenter = scrollView.center.x, ycenter = scrollView.center.y;
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width / 2 : xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height / 2 : ycenter;
    [[scrollView viewWithTag:101] setCenter:CGPointMake(xcenter, ycenter)];
}
@end
