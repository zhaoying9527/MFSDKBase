//
//  MFEmojiView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFEmojiView.h"
#import "MFResourceCenter.h"
#import "MFHelper.h"

@interface MFEmojiView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
//@property (nonatomic, strong) APChatEmotion * chatEmotion;
@end

@implementation MFEmojiView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.multipleTouchEnabled = YES;
        [self setupTapGestureRecognizer];
    }
    return self;
}

- (void)dealloc
{
//    [self.chatEmotion stopPlay];
}

- (void)setupTapGestureRecognizer
{
    self.userInteractionEnabled = YES;
    self.singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    self.singleTap.numberOfTouchesRequired = 1;
    self.singleTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:self.singleTap];
}


- (void)handleSingleFingerEvent:(UITapGestureRecognizer *)sender
{
//    if (sender.numberOfTapsRequired == 1 && self.chatEmotion) {
//        self.chatEmotion.hasGrayBg = NO;
//        [self.chatEmotion playWithinView:nil];
//    }
}

- (void)setEmoji:(NSDictionary*)emoji
{
//    _emoji = emoji;
//    if ([_emoji isKindOfClass:[NSDictionary class]]) {
//        UIImage *bannerImage = [[MFResourceCenter sharedMFResourceCenter] bannerImage];
//        NSString *emojiKey = [_emoji objectForKey:@"emoji"];
//        if(emojiKey.length != 0){
//            NSString *orderNo = [_emoji objectForKey:@"orderNo"];
//            __weak MFEmojiView * weakSelf = self;
//            [[APChatResourceManager sharedResourceManager] emotionForEmotionID:emojiKey
//                                                                   tradeNumber:orderNo
//                                                           didDownloadCallback:^(APChatEmotion *emotion)
//             {
//                 if(weakSelf == nil){
//                     return;
//                 }
//                 if(emotion.status == APChatResourceStatusError){
//                     [weakSelf setImage:bannerImage];
//                     return;
//                 }
//                 weakSelf.chatEmotion = emotion;
//                 if (nil != weakSelf.chatEmotion.iconUrl ) {
//                     [weakSelf setImageWithURL:[NSURL URLWithString:weakSelf.chatEmotion.iconUrl]
//                              placeholderImage:bannerImage];
//                 }else {
//                     [weakSelf setImage:bannerImage];
//                 }
//             }];
//        }
//        if (nil != self.chatEmotion.iconUrl ) {
//            [self setImageWithURL:[NSURL URLWithString:self.chatEmotion.iconUrl] placeholderImage:bannerImage];
//        }else {
//            [self setImage:bannerImage];
//        }
//    }
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    
    self.side = (_alignmentType == MFAlignmentTypeNone) ? NO : YES;
}

- (void)alignHandling
{
}

- (void)reverseHandling
{
    CGRect rawRect = self.frame;
    UIView *superView = self.superview;

    CGRect rect = rawRect;
    rect.origin.x = superView.frame.size.width - rect.origin.x - rect.size.width;
    if (![MFHelper sameRect:rawRect withRect:rect]) {
        self.frame = rect;
    }
}
@end