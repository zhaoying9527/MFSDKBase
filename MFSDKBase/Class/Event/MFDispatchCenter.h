//
//  MFActionManager.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFActionManager : NSObject
- (void)executeAction:(NSDictionary*)actionNode;
- (void)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType;
@end
