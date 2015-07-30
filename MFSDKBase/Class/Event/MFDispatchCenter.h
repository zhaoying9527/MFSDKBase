//
//  MFDispatchCenter.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFDefine.h"

@protocol MFEventProtcol <NSObject>
- (BOOL)handleNativeEvent:(NSDictionary *)eventInfo target:(id)sender;
@end

@interface MFDispatchCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFDispatchCenter)
- (BOOL)executeNativeAction:(NSDictionary*)actionNode;
- (id)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType;
@end
