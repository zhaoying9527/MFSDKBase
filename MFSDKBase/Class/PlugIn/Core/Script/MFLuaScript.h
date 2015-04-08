//
//  MFLuaCore.h
//  MFuickSDK
//
//  Created by 赵嬴 on 15/4/2.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFScript.h"
@interface MFLuaScript : MFScript
- (BOOL)loadText:(NSString*)text;
- (NSDictionary*)executeScript:(NSDictionary *)scriptNode;
@end
