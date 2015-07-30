//
//  MFEmojiView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFEmojiView.h"
#import "MFResourceCenter.h"
#import "NSObject+VirtualNode.h"
#import "MFHelper.h"
#import "MFScript.h"
//TODO
//#import "APChatResourceManager.h"
//#import "APChatMediaManager.h"
//#import "APChatEmotion+Play.h"

@interface MFEmojiView () <UIGestureRecognizerDelegate>
//TODO
//@property (nonatomic, strong) APChatEmotion * chatEmotion;
@end

@implementation MFEmojiView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.side = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)dealloc
{
//TODO
//    [self.chatEmotion stopPlay];
}

- (void)setTouchEnabled:(BOOL)touchEnabled
{
    _touchEnabled = touchEnabled;
    self.userInteractionEnabled = touchEnabled;
}

#pragma mark --
#pragma mark touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    NSUInteger taps = [touch tapCount];
    if (taps == 1) {
        [super touchesCancelled:touches withEvent:event];
        [self handleSingleFingerEvent];
        return;
    }
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}

- (void)handleSingleFingerEvent
{
//TODO
//    if (self.chatEmotion) {
//        self.chatEmotion.hasGrayBg = NO;
//        [self.chatEmotion playWithinView:nil];
//    }
}

- (void)setEmoji:(NSDictionary*)emoji
{
    _emoji = emoji;
//TODO
//    if ([_emoji isKindOfClass:[NSDictionary class]]) {
//        UIImage *bannerImage = [[PKResourceCenter sharedPKResourceCenter] bannerImage];
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
    self.side = (_alignmentType != MFAlignmentTypeNone && self.side) ? YES : NO;
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