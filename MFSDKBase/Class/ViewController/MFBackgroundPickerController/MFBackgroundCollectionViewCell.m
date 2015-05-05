//
//  MFBackgroundCollectionViewCell.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/27.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFBackgroundCollectionViewCell.h"
#define delayInSeconds 0.25
@interface MFBackgroundCollectionViewCell ()
@property (nonatomic, strong) UIActivityIndicatorView* activityIndicator;
@property (nonatomic, strong) UILabel* flowLayer;
@property (nonatomic, strong) UILabel* overLayer;
@end

@implementation MFBackgroundCollectionViewCell
- (BOOL)needsDoloadOriginalImage
{
    BOOL retCode = NO;
//TODO
//    NSString* cacheKey = [[SDWebImageManager sharedManager] cacheKeyForURL:self.originalImageUrl];
//    UIImage* image = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:cacheKey];
//    if (!image) {
//        retCode = YES;
//    }

    return retCode;
}

- (void)setShowDownloadLayer:(BOOL)showLayer
{
    _showDownloadLayer = showLayer;
    if (showLayer) {
        if (nil == self.flowLayer) {
            CGRect rect = self.bounds;
            rect.origin.y = self.bounds.size.height - 20;
            rect.size.height = 20; //self.bounds.size.height/2;
            self.flowLayer = [[UILabel alloc] initWithFrame:rect];
            self.flowLayer.backgroundColor = [UIColor whiteColor];
            self.flowLayer.textAlignment = NSTextAlignmentCenter;
            self.flowLayer.textColor = [UIColor darkGrayColor];
            self.flowLayer.font = [UIFont boldSystemFontOfSize:13];
            self.flowLayer.layer.masksToBounds = YES;
            self.flowLayer.layer.cornerRadius = 6.0;
            self.flowLayer.alpha = 0.75;
            self.flowLayer.text = @"下载";
            [self addSubview:self.flowLayer];
        }

        if (nil == self.overLayer) {
            CGRect rect = self.bounds;
            rect.origin.y = self.bounds.size.height - 20;
            rect.size.width = 0;
            rect.size.height = 20;
            self.overLayer = [[UILabel alloc] initWithFrame:rect];
            self.overLayer.backgroundColor = [UIColor greenColor];
            self.overLayer.textAlignment = NSTextAlignmentCenter;
            self.overLayer.textColor = [UIColor darkGrayColor];
            self.overLayer.font = [UIFont boldSystemFontOfSize:13];
            self.overLayer.layer.masksToBounds = YES;
            self.overLayer.layer.cornerRadius = 6.0;
            self.overLayer.alpha = 0.75;
            [self addSubview:self.overLayer];
        }
        self.overLayer.hidden = NO;
        self.flowLayer.hidden = NO;
    }
    else {
        self.overLayer.hidden = YES;
        self.flowLayer.hidden = YES;
    }
}

- (void)doloadOriginalImage:(NSURL*)originalImageUrl
                   compelet:(void (^)(BOOL success, UIImage* image))completion
{
//TODO
//    [[SDWebImageManager sharedManager] downloadWithURL:originalImageUrl
//        options:SDWebImageRetryFailed
//        progress:^(NSUInteger receivedSize, long long expectedSize) {
//            if (!self.activityIndicator) {
//                [self.imageView addSubview:self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
//                self.activityIndicator.frame = self.flowLayer.frame;
//                self.activityIndicator.center = self.flowLayer.center;
//                self.flowLayer.text = @"";
//                [self.self.activityIndicator startAnimating];
//            }
//        }
//        completed:^(UIImage* image, NSError* error, SDImageCacheType cacheType, BOOL finished) {
//            [[SDImageCache sharedImageCache] storeImage:image forKey:[self.originalImageUrl absoluteString] toDisk:YES];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.activityIndicator removeFromSuperview];
//                self.activityIndicator = nil;
//
//                if (image) {
//                    completion(YES, image);
//                }
//                else {
//                    completion(NO, nil);
//                }
//            });
//        }];
}

@end
