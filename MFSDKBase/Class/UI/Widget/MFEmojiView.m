//
//  MFEmojiView.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFEmojiView.h"
#import "MFResourceCenter.h"
#import "NSObject+DOM.h"
#import "MFHelper.h"

@interface MFEmojiView ()
@property (nonatomic, strong)NSTimer *longPressTimer;
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
    [self.longPressTimer invalidate];
    self.longPressTimer = nil;
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
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = [NSTimer scheduledTimerWithTimeInterval:kLongPressTimeInterval target:self selector:@selector(handleLongPressEvent) userInfo:nil repeats:NO];
    }else {
        [super touchesBegan:touches withEvent:event];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = nil;
    }else {
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = nil;
        [self handleSingleFingerEvent];
    }else {
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ((self.DOM.eventNodes[kMFOnClickEvent])) {
        [self.longPressTimer invalidate];
        self.longPressTimer = nil;
    } else {
        [super touchesCancelled:touches withEvent:event];
    }
}

- (void)handleSingleFingerEvent
{
    if (self.DOM.eventNodes[kMFOnClickEvent]) {
        id result = [self.DOM triggerEvent:kMFOnClickEvent withParams:@{}];
        NSLog(@"%@",result);
    }else {
        NSDictionary *params = @{kMFDispatcherEventType:kMFOnClickEvent, kMFIndexPath:((MFCell*)self.viewCell).indexPath};
        if ([self.viewController respondsToSelector:@selector(dispatchWithTarget:params:)]) {
            [(id)self.viewController dispatchWithTarget:self params:params];
        }
    }
}

- (void)handleLongPressEvent
{
    if (self.DOM.eventNodes[kMFOnKeyLongPressEvent]) {
        id result = [self.DOM triggerEvent:kMFOnKeyLongPressEvent withParams:@{}];
        NSLog(@"%@",result);
    }else {
        NSDictionary *params = @{kMFDispatcherEventType:kMFOnKeyLongPressEvent, kMFIndexPath:((MFCell*)self.viewCell).indexPath};
        if ([self.viewController respondsToSelector:@selector(dispatchWithTarget:params:)]) {
            [(id)self.viewController dispatchWithTarget:self params:params];
        }
    }
    //    if (sender.numberOfTapsRequired == 1 && self.chatEmotion) {
    //        self.chatEmotion.hasGrayBg = NO;
    //        [self.chatEmotion playWithinView:nil];
    //    }
}

- (void)setEmoji:(NSDictionary*)emoji
{
    UIImage *bannerImage = [MFResourceCenter imageNamed:@"daxiang"];
    [self setImage:bannerImage];

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