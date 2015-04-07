//
//  RuntimeClass.h
//

#import <Foundation/Foundation.h>
#import "MFDefine.h"

@interface MFAMLScript : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFAMLScript)
- (BOOL)bindObject:(id)object;
- (void)batchExecution:(NSDictionary *)scriptDict;
- (id)valueFormat:(NSString *)propertyValue withPropertyName:(NSString *)propertyName;
- (BOOL)supportHtmlTag:(NSString *)htmlTag;
- (id)allocObject:(NSString*)amlScript;
- (BOOL)setProperty:(id)objC popertyName:(NSString*)popertyName withObject:(id)withObject;
- (id)getProperty:(id)objC popertyName:(NSString*)popertyName;

@end
