//
//  MFDataBinding.m
//
//  Created by 李春荣 on 15/3/23.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDataBinding.h"
#import "MFDefine.h"
#import "MFHelper.h"
#import "MFLabel.h"
#import "MFImageView.h"
#import "MFRichLabel.h"
#import "MFEmojiView.h"
#import "MFVoiceLabel.h"
#import "MFResourceCenter.h"
#import "UIView+UUID.h"

@implementation MFDataBinding

+ (void)bindingWidget:(UIView *)widget withDataSource:(NSDictionary *)data dataBinding:(NSDictionary *)dataBinding
{
    if (!(widget && data && dataBinding)) {
        return;
    }

    if ([widget isKindOfClass:[MFLabel class]]) {
        [self bindingToLabel:widget dataSource:data dataBinding:dataBinding];
    } else if ([widget isKindOfClass:[MFRichLabel class]]) {
        [self bindingToRichLabel:widget dataSource:data dataBinding:dataBinding];
    } else if ([widget isKindOfClass:[MFEmojiView class]]) {
        [self bindingToEmoji:widget dataSource:data dataBinding:dataBinding];
    } else if ([widget isKindOfClass:[MFImageView class]]) {
        [self bindingToImageView:widget dataSource:data dataBinding:dataBinding];
    } else if ([widget isKindOfClass:[MFVoiceLabel class]]) {
        [self bindingToVoice:widget dataSource:data dataBinding:dataBinding];
    }
}

+ (void)bindingToLabel:(UIView*)widget dataSource:(NSDictionary*)dataSource dataBinding:(NSDictionary*)dataBinding
{
    NSString *dataKey = [dataBinding objectForKey:KEYWORD_DATASOURCEKEY];
    NSString *dataString = [dataSource objectForKey:dataKey];
    
    UILabel *widgetLabel = (MFLabel*)widget;
    if (dataKey && dataString) {
        widgetLabel.text = dataString;
    }
}

+ (void)bindingToRichLabel:(UIView*)widget dataSource:(NSDictionary*)dataSource dataBinding:(NSDictionary*)dataBinding
{
    NSString *dataKey = [dataBinding objectForKey:KEYWORD_DATASOURCEKEY];
    NSString *dataString = [dataSource objectForKey:dataKey];

    MFRichLabel *richLabel = (MFRichLabel*)widget;
    if (dataString.length > 0) {
        dataString = dataString;
//TODO        dataString = [dataString containsEmoji] ? [dataString ubb2unified]: dataString;
    }
//    richLabel.rawString = dataString;
//    richLabel.formatString = dataString;
    
}

+ (void)bindingToEmoji:(UIView*)widget dataSource:(NSDictionary*)dataSource dataBinding:(NSDictionary*)dataBinding
{
    NSString *dataKey = [dataBinding objectForKey:KEYWORD_DATASOURCEKEY];
    NSDictionary *emoji = [dataSource objectForKey:dataKey];

//    MFEmojiView *emojiView = (MFEmojiView*)widget;
//    if (nil != emoji) {
//        [emojiView setEmoji:emoji];
//    }
}

+ (void)bindingToImageView:(UIView*)widget dataSource:(NSDictionary*)dataSource dataBinding:(NSDictionary*)dataBinding
{
    NSString *dataKey = [dataBinding objectForKey:KEYWORD_DATASOURCEKEY];
    NSString *imageUrl = [dataSource objectForKey:dataKey];

    MFImageView *imageView = (MFImageView*)widget;
    if (imageUrl && [imageUrl length] > 0) {
        if ([MFHelper isURLString:imageUrl]) {
            //TODO;
        } else {
            UIImage *image = [MFResourceCenter imageNamed:imageUrl];
//            UIImage *image = [[MFResourceCenter sharedMFResourceCenter] imageWithId:imageUrl];
            [imageView setImage:image];
        }
    }
}

+ (void)bindingToVoice:(UIView*)widget dataSource:(NSDictionary*)dataSource dataBinding:(NSDictionary*)dataBinding
{
//    NSDictionary *bindingdict = [dataBinding objectForKey:[widget UUID]];
//    NSString *dataKey = [bindingdict objectForKey:KEYWORD_DATASOURCEKEY];
//    NSDictionary * mediaState =  [dataSource dictionaryForKey:dataKey];
    
//TODO
//    MFVoiceWidget * voice = (MFVoiceWidget*)widget;
//    NSDictionary * mediaState =  [dataSource dictionaryForKey:@"mediaState"];
//    
//    voice.clientMsgID = [dataSource stringForKey:@"clientMsgID"];
//    if (mediaState) {
//        voice.mediaState = [[NSMutableDictionary alloc] initWithDictionary:mediaState];;
//    }
//    NSString *voiceUrl = nil;
//    id voiceObj = [dataSource objectForKey:[plistSource objectForKey:KEYWORD_DATASOURCEKEY]];
//    if ([voiceObj isKindOfClass:[NSDictionary class]]) {
//        voiceUrl = [voiceObj objectForKey:@"voice"];
//        voice.timeLine = [NSString stringWithFormat:@"%d",[[voiceObj objectForKey:@"timeLength"] intValue]];
//    }else {
//        voiceUrl = voiceObj;
//        voice.timeLine = [NSString stringWithFormat:@"%d",[[dataSource objectForKey:@"timeLength"] intValue]];
//    }
//    
//    //强行以系统时长为准
//    CGFloat tl = [APChatMediaManager timeLineForUrl:voiceUrl];
//    if ((nil == voice.timeLine || [voice.timeLine length] <= 0 || [voice.timeLine intValue] <= 0) && tl > 0.0f) {
//        voice.timeLine = [NSString stringWithFormat:@"%d",(int)tl];
//    }
//    
//    
//    if (nil != voiceUrl && [voiceUrl length] > 0) {
//        voice.voiceUrl = voiceUrl;
//        voice.hidden = NO;
//    }else {
//        voice.hidden = YES;
//    }
}

@end
