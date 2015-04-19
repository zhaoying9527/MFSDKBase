//
//  MFStrategyCenter.h


#import <Foundation/Foundation.h>
#import "MFDefine.h"

@interface MFStrategyCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFStrategyCenter)
- (void)removeAll;
- (NSDictionary*)sourceWithID:(NSString*)strategyID;
@end
