//
//  MFCloudImageView.m
//  SocialSDK
//
//  Created by chicp on 15-4-10.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFCloudImageView.h"
//TODO
//#import "UIImageView+MD5Manager.h"
//#import "CTImageBrowser.h"
#import "MFDefine.h"
#import "NSObject+VirtualNode.h"

@interface MFCloudImageView()<UIScrollViewDelegate>

@end

@implementation MFCloudImageView
- (id)init
{
    self = [super init];
    
//TODO
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(needRefreshProgressUpdate:)
//                                                 name:kNotificationCloudImageProgressUpdate
//                                               object:nil];
    
    return self;
}

- (void)needRefreshProgressUpdate:(NSNotification *)notify
{
    /*
     
     double percentage = [[notify.userInfo objectForKey:@"percentage"]
     doubleValue];
     long long partialBytes = [[notify.userInfo objectForKey:@"percentage"]
     longLongValue];
     long long totalBytes = [[notify.userInfo objectForKey:@"totalBytes"]
     longLongValue];
     NSString *realId = [notify.userInfo objectForKey:@"realId"];
     NSString *imageUrl = [notify.userInfo objectForKey:@"uri"];
     
     */
}

//TODO
//设置 cluodID
//- (void)setImageWithURL:(NSURL *)url
//       placeholderImage:(UIImage *)placeholder
//           fitImageSize:(CGSize)fitImageSize
//              completed:(SDWebImageCompletedBlock)completedBlock {
//    _imageUrl = url.absoluteString;
//    if (nil == _imageUrl) {
//        self.image = placeholder;
//    } else {
//        [[APImageManager manager] setChatCompressPara:kMaxCompressWH
//                                           MinFrameWH:kMinCompressWH
//                                             MinScale:kMinScale];
//        
//        [self setImageWithChatIdentifer:url.absoluteString
//                       placeholderImage:placeholder
//                           fitImageSize:fitImageSize
//                             completion:^(UIImage *image, NSError *error) {
//                                 if (completedBlock) {
//                                     completedBlock(image, error, SDImageCacheTypeNone);
//                                 }
//                                 // NSLog(@"view:%@,imageSize:%@",wSelf,
//                                 // NSStringFromCGSize(image.size));
//                             }];
//    }
//}

- (CGFloat)getCurrectProgress{
    return 0.0;
}

- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender {
    if (sender.numberOfTapsRequired == 1) {
        // todo...
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"k_NOT_WILL_SHOW_PREVIEWPICK"
         object:self.imageUrl];
//TODO
//        [CTImageBrowser showImage:self delegate:self];
    }
}

#pragma mark - delegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:101];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//TODO
//    [CTImageBrowser positionControl:scrollView];;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
