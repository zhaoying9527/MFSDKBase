//
//  MFChatImageView.m
//  SocialSDK
//
//  Created by 佳佑 on 15/3/31.
//  Copyright (c) 2015年 shawn. All rights reserved.
//

#import "MFChatImageView.h"
#import <CoreImage/CoreImage.h>
#import <CoreGraphics/CoreGraphics.h>
#import "MFImageView.h"
#import "MFDefine.h"
@interface MFChatImageView ()
@property (nonatomic, strong) UIImageView *borderView;
@property (nonatomic, strong) UIImage *receiverMaskImage;
@property (nonatomic, strong) UIImage *receiverBorderImage;
@property (nonatomic, strong) UIImage *senderMaskImage;
@property (nonatomic, strong) UIImage *senderBorderImage;
@end

@implementation MFChatImageView

inline static CGRect CGRectCenterRectForResizableImage(UIImage *image)
{
    return CGRectMake(image.capInsets.left/image.size.width, image.capInsets.top/image.size.height,
                      (image.size.width-image.capInsets.right-image.capInsets.left)/image.size.width,
                      (image.size.height-image.capInsets.bottom-image.capInsets.top)/image.size.height);
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor clearColor];
        self.chatType = MFChatImageViewReceiver;
        [self setupMaskInfo];
    }
    return self;
}

- (UIImage*)loadImageWithId:(NSString*)imageId withPath:(NSString*)path
{
    UIImage *retImage = [[MFResourceCenter sharedMFResourceCenter] cacheImageWithId:imageId];
    if (nil == retImage) {
        retImage = [UIImage imageWithContentsOfFile:path];
        if (nil != retImage) {
            if ([imageId isEqualToString:@"ReceiverImageNodeMask"]) {
                retImage = [retImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 30, 10, 20)];
            }
            if ([imageId isEqualToString:@"SenderImageNodeMask"]) {
                retImage = [retImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 10, 30)];
            }
            if ([imageId isEqualToString:@"ReceiverImageNodeBorder"]) {
                retImage = [retImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 30, 10, 20)];
            }
            if ([imageId isEqualToString:@"SenderImageNodeBorder"]) {
                retImage = [retImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 20, 10, 30)];
            }
        }
        [[MFResourceCenter sharedMFResourceCenter] cacheImage:retImage key:imageId];
    }
    
    return retImage;
}

- (void)setupMaskInfo
{
    self.receiverMaskImage = [self loadImageWithId:@"ReceiverImageNodeMask"
                                          withPath:[[NSBundle mainBundle] pathForResource:@"MFSDK.bundle/ReceiverImageNodeMask@2x" ofType:@"png"]];
    
    self.senderMaskImage = [self loadImageWithId:@"SenderImageNodeMask"
                                             withPath:[[NSBundle mainBundle] pathForResource:@"MFSDK.bundle/SenderImageNodeMask@2x" ofType:@"png"]];
    
    self.receiverBorderImage = [self loadImageWithId:@"ReceiverImageNodeBorder"
                                                 withPath:[[NSBundle mainBundle] pathForResource:@"MFSDK.bundle/ReceiverImageNodeBorder@2x" ofType:@"png"]];
    
    self.senderBorderImage = [self loadImageWithId:@"SenderImageNodeBorder"
                                               withPath:[[NSBundle mainBundle] pathForResource:@"MFSDK.bundle/SenderImageNodeBorder@2x" ofType:@"png"]];
    
    if (nil == self.borderView) {
        UIImageView *borderView = [[UIImageView alloc] initWithFrame:self.bounds];
        borderView.opaque = YES;
        borderView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:borderView];
        self.borderView = borderView;
    }
    
}

- (void)refreshMask
{
    UIImage *maskImage = self.chatType == MFChatImageViewReceiver ? self.receiverMaskImage : self.senderMaskImage;
    
    CGRect imageRect = CGRectCenterRectForResizableImage(maskImage);
    
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.contents = (id)(maskImage.CGImage);
    maskLayer.contentsScale = [UIScreen mainScreen].scale;
    maskLayer.contentsCenter = imageRect;
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
}
- (void)refreshBorder
{
    self.borderView.image = self.chatType == MFChatImageViewReceiver ? self.receiverBorderImage : self.senderBorderImage;
}


- (void)setChatType:(MFChatImageViewType)chatType
{
    _chatType = chatType;
}


//TODO
//- (void)setImage:(UIImage*)image
//{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        UIImage* fitImage = image;
//        fitImage = [PKHelper resizeImageWithSize:image size:self.frame.size];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [super setImage:fitImage];
//        });
//    });
////    dispatch_async(dispatch_get_main_queue(), ^{
////        CGFloat scale = [UIScreen mainScreen].scale;
////        UIImage* fitImage = image;
////        if (image.size.width > self.frame.size.width * scale) {
////            fitImage = [PKHelper resizeImageWithSize:image size:self.frame.size];
////        }
////
////        [super setImage:fitImage];
////    });
//}

- (void)alignHandling
{
    if (MFAlignmentTypeLeft == self.alignmentType) {
        self.chatType = MFChatImageViewReceiver;
    }else {
        self.chatType = MFChatImageViewSender;
    }
    
    [self refreshMask];
    [self refreshBorder];
}

@end
