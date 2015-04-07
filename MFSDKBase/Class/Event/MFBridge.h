//  MFBridge.h
//  MFSDKBase
//
//  Created by 李春荣 on 15/3/24.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFBridge : NSObject
- (void)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType;
@end

