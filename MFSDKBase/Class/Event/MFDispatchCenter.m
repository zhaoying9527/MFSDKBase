//
//  MFDispatchCenter.m
//  MFSDKBase
//
//  Created by 赵嬴 on 15/4/5.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import "MFDispatchCenter.h"
#import "MFCorePlugInService.h"
#import "MFViewController.h"
#import "MFBridge.h"
#import "MFScript.h"

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

- (BOOL)executeNativeAction:(NSDictionary*)actionNode
{
    BOOL handledByNative = NO;
    id objectRef = actionNode[kMFTargetKey];
    UIViewController *delegateVC = ((UIView*)objectRef).viewController;
    if ([delegateVC isKindOfClass:[MFViewController class]]
        && [delegateVC respondsToSelector:@selector(handleNativeEvent:target:)]) {
        handledByNative = [(MFViewController*)delegateVC handleNativeEvent:actionNode target:objectRef];
    }
    return handledByNative;
}

- (id)executeScript:(NSDictionary*)scriptNode scriptType:(NSInteger)scriptType
{
    return [self.bridge executeScript:scriptNode scriptType:scriptType];
}
@end

