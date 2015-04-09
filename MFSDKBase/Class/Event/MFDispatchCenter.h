//
//  MFDispatchCenter.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFSDK.h"

@interface MFDispatchCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFDispatchCenter)
- (void)executeAction:(NSDictionary*)actionNode;
- (id)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType;
@end
