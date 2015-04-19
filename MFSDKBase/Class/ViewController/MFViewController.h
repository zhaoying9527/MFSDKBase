#import <UIKit/UIKit.h>

@interface MFViewController : UIViewController
- (id)initWithScriptName:(NSString *)scriptName;
- (void)setupDataSource:(NSDictionary*)params;
@end
