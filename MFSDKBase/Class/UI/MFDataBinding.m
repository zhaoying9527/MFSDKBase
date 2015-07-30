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
#import "MFChatImageView.h"
#import "MFCloudImageView.h"
#import "MFButton.h"
#import "MFAudioLabel.h"
#import "MFEmojiView.h"
#import "MFGIFView.h"
#import "MFEmojiLabel.h"
#import "MFTipsWidget.h"
#import "MFHelper.h"
#import "MFResourceCenter.h"
#import "NSObject+VirtualNode.h"
#import "HTMLNode.h"
@implementation MFDataBinding
+ (void)bind:(UIView*)view withDataSource:(NSDictionary*)dataSource
{
    [self bindDataToWidget:view dataSource:dataSource bindingField:view.virtualNode.dom.bindingField];

    for (UIView *subView in view.subviews) {
        [self bind:subView withDataSource:dataSource];
    }
}

+ (void)bindDataToWidget:(id)widget dataSource:(NSDictionary*)dataSource bindingField:(NSString*)bindingField
{
    NSDictionary *dataDict = dataSource;
    NSString *dataObj = dataDict[bindingField];

    if ([widget isKindOfClass:[MFLabel class]]) {
        NSString *defaultText = [((MFLabel*)widget).virtualNode.dom.htmlNodes getAttributeNamed:@"value"];
        ((MFLabel*)widget).text = dataObj ? dataObj : defaultText;
    }else if ([widget isKindOfClass:[MFRichLabel class]]) {
        NSString *defaultText = [((MFRichLabel*)widget).virtualNode.dom.htmlNodes getAttributeNamed:@"value"];
        ((MFRichLabel*)widget).text = dataObj ? dataObj : defaultText;
    }else if ([widget isKindOfClass:[MFImageView class]] || [widget isKindOfClass:[MFCloudImageView class]]) {
        MFImageView *imageView = (MFImageView*)widget;
        NSString *defaultSrc = [((MFImageView*)widget).virtualNode.dom.htmlNodes getAttributeNamed:@"src"];
        if (nil != dataObj && [dataObj length] > 0) {
            UIImage *image = [[MFResourceCenter sharedMFResourceCenter] imageWithId:dataObj];
            if (!image) image = [MFResourceCenter imageNamed:dataObj];
            if(image) {
                [imageView setImage:image];
            }else {
                UIImage *bannderImage = [[MFResourceCenter sharedMFResourceCenter] bannerImage];
                imageView.image = bannderImage;
//TODO
//                [imageView setImageWithURL:[NSURL URLWithString:dataObj] placeholderImage:bannderImage
//                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                 }];
            }
        }else if (defaultSrc && defaultSrc.length>0) {
            UIImage *defaultImage = [[MFResourceCenter sharedMFResourceCenter] imageWithId:defaultSrc];
            if (!defaultImage) defaultImage = [MFResourceCenter imageNamed:dataObj];
            if(defaultImage) {
                [imageView setImage:defaultImage];
            }else {
                UIImage *bannderImage = [[MFResourceCenter sharedMFResourceCenter] bannerImage];
                imageView.image = bannderImage;
//TODO
//                [imageView setImageWithURL:[NSURL URLWithString:defaultSrc] placeholderImage:bannderImage
//                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                 }];
            }
        }
    }else if ([widget isKindOfClass:[MFChatImageView class]]) {
        MFChatImageView *imageView = (MFChatImageView*)widget;
        NSString *defaultSrc = [((MFChatImageView*)widget).virtualNode.dom.htmlNodes getAttributeNamed:@"src"];
        UIImage *defaultImage = [[MFResourceCenter sharedMFResourceCenter] imageWithId:defaultSrc];
        if (!defaultImage) defaultImage = [MFResourceCenter imageNamed:dataObj];
        UIImage *bannderImage = [[MFResourceCenter sharedMFResourceCenter] bannerImage];
        if ((nil != dataObj && [dataObj length] > 0) || (defaultSrc && defaultSrc.length>0)) {
            if ([MFHelper isURLString:dataObj]) {
                  imageView.image = bannderImage;
//TODO
//                [(MFChatImageView*)widget setImageWithURL:[NSURL URLWithString:dataObj] placeholderImage:bannderImage
//                                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//                                                }];
            } else {
                UIImage *image = [[MFResourceCenter sharedMFResourceCenter] imageWithId:dataObj];
                if (!image) image = [MFResourceCenter imageNamed:dataObj];
                ((MFChatImageView*)widget).image = image ? image : defaultImage;
            }
        }
    }else if ([widget isKindOfClass:[MFButton class]]) {
        ((MFButton*)widget).text = dataObj;
    }else if ([widget isKindOfClass:[MFTipsWidget class]]) {
        ((MFTipsWidget*)widget).text = dataSource[bindingField];
    }else if ([widget isKindOfClass:[MFAudioLabel class]]) {
        MFAudioLabel * voice = (MFAudioLabel*)widget;
        voice.timeLine = dataSource[@"l"];
        voice.voiceUrl = @"xxx";
        voice.hidden = NO;
    }else if([widget isKindOfClass:[MFEmojiView class]]) {
        MFEmojiView * emojiView = (MFEmojiView*)widget;
        NSDictionary *emoji = [dataDict objectForKey:bindingField];
        if (nil != emoji) {
            [emojiView setEmoji:emoji];
        }
    }else if ([widget isKindOfClass:[MFEmojiLabel class]]){
        MFEmojiLabel *emojiLabel = (MFEmojiLabel*)widget;
//TODO
//        if (dataObj.length > 0) {
//            dataObj = [dataObj containsEmoji] ? [dataObj ubb2unified]: dataObj;
//        }
        [emojiLabel setCTText:dataObj emojiMap:nil];
    }else if ([widget isKindOfClass:[MFGIFView class]]) {
        MFGIFView *gifView = (MFGIFView*)widget;
        if (nil != dataSource) {
            gifView.gif = dataSource;
        }
    }
}
@end
