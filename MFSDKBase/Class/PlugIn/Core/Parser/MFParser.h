//
//  MFParser.h
//  MFuickSDK
//
//  Created by 赵嬴 on 15/4/2.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MFPlugIn.h"
@interface MFParser : MFPlugIn
- (BOOL)loadText:(NSString*)text;
- (id)parse;
@end
