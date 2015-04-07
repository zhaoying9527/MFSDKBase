//
//  MFStrategyCenter.m

#import "MFStrategyCenter.h"
#import "MFHelper.h"

@interface MFStrategyCenter()
@end

@implementation MFStrategyCenter

SYNTHESIZE_SINGLETON_FOR_CLASS(MFStrategyCenter)
- (void)removeAll
{
}

- (id)init
{
    self = [super init];
    return self;
}

- (NSDictionary*)sourceWithID:(NSString*)sourceID
{
    NSString *strFilePath = [[NSString alloc] initWithFormat:@"%@/%@/%@.plist",[MFHelper getResourcePath],[MFHelper getBundleName],sourceID];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:strFilePath];
    return dict;
}

- (NSDictionary*)itemWithID:(NSString*)itemID subItemID:(NSString*)subItemID source:(NSDictionary*)source
{
    return [[source objectForKey:itemID] objectForKey:subItemID];
}

@end
