//
//  MFActionManager.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDispatchCenter.h"
#import "MFCorePlugInService.h"
#import "MFBridge.h"

@interface MFActionManager ()
@property (nonatomic, strong) MFBridge *bridge;
@end

@implementation MFActionManager
SYNTHESIZE_SINGLETON_FOR_CLASS(MFActionManager)
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

- (void)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType
{
    //bridge
    [self.bridge executeScript:scriptNode scriptType:scriptType];
}
@end
