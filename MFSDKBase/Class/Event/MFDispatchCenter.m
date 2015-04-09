//
//  MFDispatchCenter.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDispatchCenter.h"
#import "MFCorePlugInService.h"
#import "MFBridge.h"

@interface MFDispatchCenter ()
@property (nonatomic, strong) MFBridge *bridge;
@end

@implementation MFDispatchCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFDispatchCenter)
-(instancetype)init
{
    if (self = [super init]) {
        self.bridge = [[MFBridge alloc] init];
    }
    return self;
}

- (void)executeAction:(NSDictionary*)actionNode
{

}

- (id)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType
{
    //bridge
    return [self.bridge executeScript:scriptNode scriptType:scriptType];
}
@end
