//
//  MFStrategyCenter.h


#import <Foundation/Foundation.h>
#import "MFDefine.h"

@interface MFStrategyCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFStrategyCenter)
- (NSDictionary*)sourceWithID:(NSString*)strategyID;
@end
