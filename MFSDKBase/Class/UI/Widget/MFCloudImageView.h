//
//  MFCloudImageView.h
//  SocialSDK
//
//  Created by chicp on 15-4-10.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#define kMaxCompressWH  120
#define kMinCompressWH  80
#define kMinScale       0.382

#import "MFChatImageView.h"

@interface MFCloudImageView : MFChatImageView
@property (nonatomic, strong) NSString *imageUrl;
@end
