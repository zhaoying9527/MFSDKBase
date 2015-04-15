//
//  MFDataBinding.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/9.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDataBinding.h"
#import "MFLabel.h"
#import "MFRichLabel.h"
#import "MFImageView.h"
#import "MFButton.h"
#import "MFAudioLabel.h"
#import "MFEmojiView.h"
#import "MFTipsWidget.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "NSObject+DOM.h"
#import "HTMLNode.h"
@implementation MFDataBinding
+ (void)bind:(UIView*)view withDataSource:(NSDictionary*)dataSource
{
    [self bindDataToWidget:view dataSource:dataSource[view.DOM.bindingField]];

    for (UIView *subView in view.subviews) {
        [self bind:subView withDataSource:dataSource];
    }
}

+ (void)bindDataToWidget:(id)widget dataSource:(NSString*)dataSource
{
    if ([widget isKindOfClass:[MFLabel class]]) {
        NSString *defaultText = [((MFLabel*)widget).DOM.htmlNodes getAttributeNamed:@"value"];
        ((MFLabel*)widget).text = dataSource ? dataSource : defaultText;
    }else if ([widget isKindOfClass:[MFRichLabel class]]) {
            NSString *defaultText = [((MFRichLabel*)widget).DOM.htmlNodes getAttributeNamed:@"value"];
            ((MFRichLabel*)widget).text = dataSource ? dataSource : defaultText;
    }else if ([widget isKindOfClass:[MFImageView class]]) {
        NSString *defaultSrc = [((MFImageView*)widget).DOM.htmlNodes getAttributeNamed:@"src"];
        UIImage *defaultImage = [[MFResourceCenter sharedMFResourceCenter] imageWithId:defaultSrc];
        if (!defaultImage) defaultImage = [MFResourceCenter imageNamed:dataSource];
        UIImage *bannderImage = [[MFResourceCenter sharedMFResourceCenter] bannerImage];        
        if ((nil != dataSource && [dataSource length] > 0) || (defaultSrc && defaultSrc.length>0)) {
            if ([MFHelper isURLString:dataSource]) {
                //TODO setImageWithUrl
            } else {
                UIImage *image = [[MFResourceCenter sharedMFResourceCenter] imageWithId:dataSource];
                if (!image) image = [MFResourceCenter imageNamed:dataSource];
                ((MFImageView*)widget).image = image ? image : defaultImage;
            }
        }
    }else if ([widget isKindOfClass:[MFButton class]]) {
        ((MFButton*)widget).text = dataSource;
    }else if ([widget isKindOfClass:[MFTipsWidget class]]) {
        ((MFTipsWidget*)widget).text = dataSource;
    }else if ([widget isKindOfClass:[MFAudioLabel class]]) {
        MFAudioLabel * voice = (MFAudioLabel*)widget;
        voice.timeLine = @"7";
        voice.voiceUrl = @"xxx";
        voice.hidden = NO;
        
//        PKVoiceWidget * voice = (PKVoiceWidget*)widget;
//        NSDictionary * mediaState =  [dataSource dictionaryForKey:@"mediaState"];
        
//        voice.clientMsgID = [dataSource stringForKey:@"clientMsgID"];
//        if (mediaState) {
//            voice.mediaState = [[NSMutableDictionary alloc] initWithDictionary:mediaState];;
//        }
//        NSString *voiceUrl = nil;
//        id voiceObj = [dataSource objectForKey:[plistSource objectForKey:KEYWORD_DATASOURCEKEY]];
//        if ([voiceObj isKindOfClass:[NSDictionary class]]) {
//            voiceUrl = [voiceObj objectForKey:@"v"];
//            voice.timeLine = [NSString stringWithFormat:@"%d",[[voiceObj objectForKey:@"l"] intValue]];
//        }else {
//            voiceUrl = voiceObj;
//            voice.timeLine = [NSString stringWithFormat:@"%d",[[dataSource objectForKey:@"l"] intValue]];
//        }
//        
//        //强行以系统时长为准
//        CGFloat tl = [APChatMediaManager timeLineForUrl:voiceUrl];
//        if ((nil == voice.timeLine || [voice.timeLine length] <= 0 || [voice.timeLine intValue] <= 0) && tl > 0.0f) {
//            voice.timeLine = [NSString stringWithFormat:@"%d",(int)tl];
//        }
//        
//        
//        if (nil != voiceUrl && [voiceUrl length] > 0) {
//            voice.voiceUrl = voiceUrl;
//            voice.hidden = NO;
//        }else {
//            voice.hidden = YES;
//        }
    }else if([widget isKindOfClass:[MFEmojiView class]]) {
        MFEmojiView * emojiView = (MFEmojiView*)widget;
        [emojiView setEmoji:nil];
//        NSDictionary *emoji = [dataSource objectForKey:[plistSource objectForKey:KEYWORD_DATASOURCEKEY]];
//        if (nil != emoji) {
//            [emojiView setEmoji:emoji];
//        }
    }
}
@end
