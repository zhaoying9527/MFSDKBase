//
//  MFWindowsStyleManager.h
//  MFSDKBase
//
//  Created by 赵嬴 on 15/7/30.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MFWindowsStyleManager : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(MFWindowsStyleManager)
- (BOOL)loadWStyleWithName:(NSString*)styleName;
- (id)style;
- (id)css;
- (id)databinding;
- (id)events;
- (NSArray*)bodyEntity;
- (MFCorePlugInService*)pluginService;
@end
