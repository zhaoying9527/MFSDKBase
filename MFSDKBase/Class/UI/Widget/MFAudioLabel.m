//
//  MFAudioLabel.m
//  mQuickSDK
//
//  Created by 赵嬴 on 15/4/4.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFAudioLabel.h"
#import "MFImageView.h"
#import "MFDefine.h"
#import "MFResourceCenter.h"
#import "MFHelper.h"
#import "MFSceneFactory.h"
#import "UIView+Sizes.h"
#import "NSObject+DOM.h"

#define CTVW_dot_image          @"MFSDK.bundle/HC_dot.png"
#define CTVM_dot_image_frame    CGRectMake(0,0,)
#define SPACE                   6
#define BADGEWH                 10
#define TIMELBW                 30

@interface MFAudioLabel ()
@property (nonatomic,strong)NSMutableArray *voiceImageArray;
@property (nonatomic,strong)NSMutableArray *voiceRImageArray;
@property (nonatomic,strong)MFImageView *playImageView;
//TODO
//@property (nonatomic,strong)APChatMedia * voiceObj;
@property (nonatomic,strong)UIImageView * badgeView;
@property (nonatomic,strong)UILabel *timeLineLabel;
@property (nonatomic,assign)CGSize voiceBGImageSize;
@property (nonatomic,assign)BOOL isPlaying;

- (void)initResource;
- (void)createTimeLineLabel;
- (void)createPlayImageView;
- (void)stopAnimating;
- (void)playAnimating;
@end

@implementation MFAudioLabel
- (id)init
{
    self = [super init];
    if (self) {
        self.side = YES;
        self.exclusiveTouch = YES;

        [self initResource];
        [self createPlayImageView];
        [self createTimeLineLabel];
        [self stopAnimating];
        [self setAlignmentType:MFAlignmentTypeLeft];
        [self setTimeLine:nil];
        
    }
    return self;
}

- (void)initResource
{
    self.mediaState = [[NSMutableDictionary alloc] init];
    self.voiceImageArray = [[NSMutableArray alloc] init];
    self.voiceRImageArray = [[NSMutableArray alloc] init];
    for (int i = 2; i <= 4; i++) {
        NSString *voiceImagePath = [NSString stringWithFormat:@"voice_%d.png",i];
        NSString *voiceRImagePath = [NSString stringWithFormat:@"voice_r_%d.png",i];
        UIImage *voiceImage = [MFResourceCenter imageNamed:voiceImagePath];
        UIImage *voiceRImage = [MFResourceCenter imageNamed:voiceRImagePath];
        if (nil != voiceImage) {
            [self.voiceImageArray addObject:voiceImage];
        }
        if (nil != voiceRImage) {
            [self.voiceRImageArray addObject:voiceRImage];
        }
        self.voiceBGImageSize = voiceImage.size;
    }
}

- (void)createTimeLineLabel
{
    self.timeLineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.timeLineLabel.opaque = YES;
    self.timeLineLabel.font = [UIFont boldSystemFontOfSize:16];
    self.timeLineLabel.backgroundColor = [UIColor clearColor];
    self.timeLineLabel.textColor = [MFHelper colorWithHexString:@"#999999"];
    [self addSubview:self.timeLineLabel];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutTimeLineLabelAndBobo];
    [self layoutBadgeView];
    
    //特殊逻辑处理
    if (self.timeLineLabel.text == nil || [self.timeLineLabel.text length] <= 0) {
        self.timeLineLabel.hidden = YES;
        CGRect timeLineRect = self.timeLineLabel.frame;
        CGRect badgeRect = self.badgeView.frame;
        badgeRect.origin.x = timeLineRect.origin.x+SPACE+3;
        self.badgeView.frame = badgeRect;
    }else {
        self.timeLineLabel.hidden = NO;
    }
}

- (void)layoutTimeLineLabelAndBobo
{
    //bobo
    int xPosition =  (self.bounds.size.height - self.voiceBGImageSize.height)/2;
    self.playImageView.frame = CGRectMake(SPACE,xPosition,
                                          self.voiceBGImageSize.width,
                                          self.voiceBGImageSize.height);
    //timeline
    xPosition = self.playImageView.frame.origin.x+self.playImageView.frame.size.width;
    self.timeLineLabel.frame = CGRectMake(xPosition+2, (self.frame.size.height-TIMELBW)/2, TIMELBW,TIMELBW);
    
    
    if (MFAlignmentTypeRight == self.alignmentType) {
        CGRect tlRect = self.timeLineLabel.frame;
        tlRect.origin.x -= SPACE;
        self.timeLineLabel.frame = tlRect;
        CGRect bbRect = self.playImageView.frame;
        bbRect.origin.x -= SPACE;
        self.playImageView.frame = bbRect;
    }else {
        if (!self.canStretch) {
            CGRect bbRect = self.playImageView.frame;
            bbRect.origin.x -= SPACE;
            self.playImageView.frame = bbRect;
            
            xPosition = bbRect.origin.x + bbRect.size.width;
            self.timeLineLabel.frame = CGRectMake(xPosition+2, (self.frame.size.height-TIMELBW)/2, TIMELBW,TIMELBW);
        }
    }
}

- (void)layoutBadgeView
{
    //badge
    CGRect rect = self.badgeView.frame;
    if (self.canStretch) {
        rect.origin.x = self.bounds.size.width - SPACE;
    }else {
        rect.origin.x = self.timeLineLabel.origin.x+self.timeLineLabel.size.width+4;
    }
    rect.origin.y = (self.bounds.size.height - BADGEWH)/2;
    rect.size.width = BADGEWH;
    rect.size.height = BADGEWH;
    self.badgeView.frame = rect;
}

- (void)setLayout:(NSString*)layout
{
    _layout = layout;
    
    if ([layout isEqualToString:@"stretch"]) {
        self.canStretch = YES;
    }else {
        self.canStretch = NO;
    }
}

- (void)createPlayImageView
{
    self.playImageView = [MFHelper createImageView];
    self.playImageView.opaque = YES;
    [self addSubview:self.playImageView];
}

- (CGFloat)voiceFactor
{
    CGFloat min = (MFAlignmentTypeLeft == self.alignmentType)?0.35:0.35;
    CGFloat max = 1.0;
    CGFloat duration = [self.timeLine floatValue];
    CGFloat pos = duration/30.0;
    CGFloat ret = min + pos;
    if (ret <= min) {
        ret = min;
    }else if (ret >= max) {
        ret = max;
    }
    return ret;
}

- (void)setTimeLine:(NSString *)timeLine
{
    _timeLine = timeLine;
    if (timeLine != nil || [timeLine length] > 0) {
        if ([timeLine floatValue] <= 0.0f) {
            self.timeLineLabel.text = nil;
        }else {
            self.timeLineLabel.text = [NSString stringWithFormat:@"%@\'\'",timeLine];
            self.timeLineLabel.hidden = NO;
        }
    }
}

- (void)setFont:(UIFont*)font
{
    _font = font;
    self.timeLineLabel.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.timeLineLabel.textColor = textColor;
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    self.side = (_alignmentType != MFAlignmentTypeNone && self.side) ? YES : NO;

    if (self.side) {
        if (MFAlignmentTypeLeft == self.alignmentType) {
            self.transform = CGAffineTransformMakeScale(1, 1);
            self.badgeView.transform =  CGAffineTransformMakeScale(1, 1);
            self.timeLineLabel.transform = CGAffineTransformMakeScale(1, 1);
            self.timeLineLabel.textColor = self.textColor;
            self.timeLineLabel.textAlignment = NSTextAlignmentLeft;
            self.playImageView.transform = CGAffineTransformMakeScale(1, 1);
        }else if (MFAlignmentTypeRight == self.alignmentType) {
            self.transform = CGAffineTransformMakeScale(-1, 1);
            self.badgeView.transform =  CGAffineTransformMakeScale(-1, 1);
            self.timeLineLabel.transform = CGAffineTransformMakeScale(-1, 1);
            self.timeLineLabel.textColor = self.highlightedTextColor;
            self.timeLineLabel.textAlignment = NSTextAlignmentRight;
            //self.playImageView.transform = CGAffineTransformMakeScale(-1, 1);
        }

        [self stopAnimating];
    }
}

- (void)alignHandling
{
    if (MFAlignmentTypeRight == self.alignmentType) {
        if (nil != self.highlightedTextColor && self.side) {
            self.timeLineLabel.textColor = self.highlightedTextColor;
        }else {
            self.timeLineLabel.textColor = self.textColor;
        }
    }else {
        self.timeLineLabel.textColor = self.textColor;
    }
}

- (void)reverseHandling;
{
    CGRect rawRect = self.frame;
    UIView *superView = self.superview;
    
    CGRect rect = rawRect;
    rect.origin.x = superView.frame.size.width - rect.origin.x - rect.size.width;
    if (![MFHelper sameRect:rawRect withRect:rect]) {
        self.frame = rect;
    }
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
    if (self.isPlaying) {
        [self pauseAudio];
    }else {
        [self playAudio];
    }
}


- (void)setVoiceUrl:(NSString *)voiceUrl
{
//TODO
//    _voiceUrl = voiceUrl;
//    __weak MFAudioLabel * weakSelf = self;
//    [APChatMediaManager voiceForUrl:voiceUrl media:self.voiceObj callback:^(APChatMedia * media) {
//        [weakSelf setVoiceObj:media];
//        [weakSelf reloadMediaState];
//    }];
    [self reloadMediaState];
}

- (void)reloadMediaState
{
//TODO
//    BOOL isRead = ![APUserPreferences boolForKey:[_voiceUrl MD5String] business:@"HiChat_Voice_unread" defaultValue:YES];
//    if (!isRead && MFAlignmentTypeLeft == self.alignmentType) {
//        if (!self.badgeView) {
//            self.badgeView = [[UIImageView alloc] initWithFrame:CGRectZero];
//            UIImage * image = [UIImage imageNamed:CTVW_dot_image];
//            self.badgeView.image = image;
//        }
//        if (!self.badgeView.superview) {
//            [self addSubview:self.badgeView];
//        }
//        self.showBadge = YES;
//    }
//    else {
//        [self.badgeView removeFromSuperview];
//        self.badgeView = nil;
//        if (self.timeLine == nil || [self.timeLine length] <= 0 || [self.timeLine intValue] <= 0) {
//            if (self.voiceObj.duration > 0.0f) {
//                NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
//                fmt.numberStyle = kCFNumberFormatterRoundCeiling;
//                self.timeLine = [fmt stringFromNumber:[NSNumber numberWithFloat:self.voiceObj.duration]];
//            }
//        }
//    }
    
    if (self.isPlaying) {
        [self playAnimating];
    }else {
        [self stopAnimating];
    }
}

-(void)playAudio
{
//TODO
//    if (nil != self.voiceUrl) {
//        __weak MFAudioLabel * wSelf = self;
//        [APChatMediaManager play:self.voiceObj
//                  finishCallback:^(APMMAudioPlayStatus status) {
//                      switch (status) {
//                          case APMMAudioStartDownLoad:{
//                              [wSelf loadBegin];
//                          }
//                              break;
//                          case APMMAudioFinishDownLoad:{
//                              [wSelf loadEnd];
//                          }
//                              break;
//                          case APMMAudioDownLoadFail:{
//                              [wSelf loadEnd];
//                          }
//                              break;
//                          case APMMAudioPlayBegin:{
//                              [wSelf beginPlay];
//                          }
//                              break;
//                          case APMMAudioPlayFinish:{
//                              [wSelf stopPlay];
//                          }
//                              break;
//                          case APMMAudioPlayFail:{
//                              [wSelf stopPlay];
//                          }
//                              break;
//                          case APMMAudioPlayUndefined:{
//                              [wSelf stopPlay];
//                          }
//                              break;
//                          default:{
//                              [wSelf stopPlay];
//                          }
//                              break;
//                      }
//                  }];
//    }
//    [self.mediaState setInteger:1 forKey:@"audioState"];
//    [self postMediaStateChangeNotification];
//    [self reloadMediaState];
}

- (void)loadBegin{
    NSLog(@"++++++Voice URL LoadBegin:%@",self.voiceUrl);
}

- (void)loadEnd{
    NSLog(@"++++++Voice URL LoadEnd:%@",self.voiceUrl);
}

- (void)beginPlay{
    NSLog(@"++++++Voice URL beginPlay:%@",self.voiceUrl);
    self.isPlaying = YES;
    [self playAnimating];
}

- (void)stopPlay{
    NSLog(@"++++++Voice URL endPlay:%@",self.voiceUrl);
    self.isPlaying = NO;
    [self reloadMediaState];
    [self stopAnimating];
}

- (void)postMediaStateChangeNotification
{
//TODO
//    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
//    [dict setObjectOrNil:self.clientMsgID forKey:@"clientMsgID"];
//    [dict setObjectOrNil:self.mediaState forKey:@"mediaState"];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationDidChangeMediaState object:nil userInfo:dict];
}

-(void)pauseAudio
{
//TODO
//    self.isPlaying = NO;
//    [APChatMediaManager stop:self.voiceObj];
//    [self stopAnimating];
//    [self reloadMediaState];
}

- (void)setShowBadge:(BOOL)showBadge
{
    _showBadge = showBadge;
    
    self.badgeView.hidden = !showBadge;
}

#pragma -- audio
- (void)stopBoboImage
{
    UIImage *image = nil;
    if (self.canStretch && MFAlignmentTypeRight == self.alignmentType) {
        image = [MFResourceCenter imageNamed:@"voice_r_0.png"];
    }else {
        image = [MFResourceCenter imageNamed:@"voice_0.png"];
    }
    [self.playImageView setImage:image];
}

- (void)stopAnimating
{
    [self stopBoboImage];
    [self.playImageView stopAnimating];
}

- (void)playAnimating
{
    
    if (![self.playImageView isAnimating]) {
        if (self.canStretch && MFAlignmentTypeRight == self.alignmentType) {
            self.playImageView.animationImages = self.voiceRImageArray;
        }else {
            self.playImageView.animationImages = self.voiceImageArray;
        }
        self.playImageView.animationDuration = 1.0;
        self.playImageView.animationRepeatCount = 0;
        [self.playImageView startAnimating];
        [self addSubview:self.playImageView];
    }
}
@end
