//
//  MFCloudImageView.m
//  SocialSDK
//
//  Created by chicp on 15-4-10.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFCloudImageView.h"
//#import "UIImageView+MD5Manager.h"
//#import "CTImageBrowser.h"
#import "MFDefine.h"
#import "NSObject+DOM.h"

@interface MFCloudImageView()<UIScrollViewDelegate>

@end

@implementation MFCloudImageView
- (id)init
{
    self = [super init];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(needRefreshProgressUpdate:)
//                                                 name:kNotificationCloudImageProgressUpdate
//                                               object:nil];
    
    return self;
}

- (void)needRefreshProgressUpdate:(NSNotification *)notify
{
}

//设置 cluodID
//- (void)setImageWithURL:(NSURL *)url
//       placeholderImage:(UIImage *)placeholder
//              completed:(SDWebImageCompletedBlock)completedBlock{
//    
//    [[APImageManager manager] setChatCompressPara:kMaxCompressWH
//                                       MinFrameWH:kMinCompressWH
//                                         MinScale:kMinScale];
//
//    _imageUrl = url.absoluteString;
//    __weak typeof (self) wSelf = self;
//    [self setImageWithChatIdentifer:url.absoluteString
//                   placeholderImage:placeholder
//                         completion:^(UIImage *image, NSError *error) {
//                             if(completedBlock){
//                                 completedBlock(image,error,SDImageCacheTypeNone);
//                             }
//                             NSLog(@"view:%@,imageSize:%@",wSelf, NSStringFromCGSize(image.size));
//                         }];
//}

- (CGFloat)getCurrectProgress{
    return 0.0;
}

- (void)handleSingleFingerEvent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"k_NOT_WILL_SHOW_PREVIEWPICK"
                                                        object:self.imageUrl];
//    [CTImageBrowser showImage:self delegate:self];
}

#pragma mark - delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:101];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    [CTImageBrowser positionControl:scrollView];;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
