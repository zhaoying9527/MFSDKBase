//
//  MFSceneCenter.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFSDK.h"
@interface MFSceneCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFSceneCenter)
- (void)initSceneWithName:(NSString*)sceneName;
@end
