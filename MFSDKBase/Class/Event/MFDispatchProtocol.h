//
//  MFDispatchProtocol.h
//  MFSDKBase
//
//  Created by 李春荣 on 15/4/17.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#ifndef MFSDKBase_MFDispatchProtocol_h
#define MFSDKBase_MFDispatchProtocol_h
#import <Foundation/Foundation.h>

@protocol MFDispatchProtocol <NSObject>
@optional
- (void)dispatchWithTarget:(id)target params:(NSDictionary*)params;
@end

#endif
