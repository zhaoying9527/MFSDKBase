//
//  MFChatImageView.h
//  CommonDemo
//
//  Created by 佳佑 on 15/3/31.
//  Copyright (c) 2015年 shawn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFImageView.h"

typedef enum {
    MFChatImageViewReceiver = 0,
    MFChatImageViewSender = 1,
}MFChatImageViewType;

@interface MFChatImageView : MFImageView
@property (nonatomic, unsafe_unretained) MFChatImageViewType chatType;
@end