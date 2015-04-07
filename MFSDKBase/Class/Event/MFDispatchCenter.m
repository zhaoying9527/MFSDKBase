//
//  MFActionManager.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFActionManager.h"
#import "MFCorePlugInService.h"
#import "MFBridge.h"

@interface MFActionManager ()
@property (nonatomic, strong) MFBridge *bridge;
@end

@implementation MFActionManager
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
