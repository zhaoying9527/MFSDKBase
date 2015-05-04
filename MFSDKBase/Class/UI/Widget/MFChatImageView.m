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
        self.backgroundColor = [UIColor clearColor];
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
                                          withPath:[[NSBundle mainBundle] pathForResource:@"SocialSDK.bundle/HiChatSDK/ReceiverImageNodeMask@2x" ofType:@"png"]];
    
    self.self.senderMaskImage = [self loadImageWithId:@"SenderImageNodeMask"
                                             withPath:[[NSBundle mainBundle] pathForResource:@"SocialSDK.bundle/HiChatSDK/SenderImageNodeMask@2x" ofType:@"png"]];
    
    self.self.receiverBorderImage = [self loadImageWithId:@"ReceiverImageNodeBorder"
                                                 withPath:[[NSBundle mainBundle] pathForResource:@"SocialSDK.bundle/HiChatSDK/ReceiverImageNodeBorder@2x" ofType:@"png"]];
    
    self.self.senderBorderImage = [self loadImageWithId:@"SenderImageNodeBorder"
                                               withPath:[[NSBundle mainBundle] pathForResource:@"SocialSDK.bundle/HiChatSDK/SenderImageNodeBorder@2x" ofType:@"png"]];
    
    if (nil == self.borderView) {
        UIImageView *borderView = [[UIImageView alloc] initWithFrame:self.bounds];
        borderView.opaque = YES;
        borderView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:borderView];
        self.borderView = borderView;
    }
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.borderView.frame = self.frame;
    [self refreshMask];
}

- (void)setChatType:(MFChatImageViewType)chatType
{
    _chatType = chatType;
}

- (void)setImage:(UIImage *)image
{
    [super setImage:image];
    
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
