#import <UIKit/UIKit.h>

@interface MFViewController : UIViewController
- (id)initWithScriptName:(NSString *)scriptName;
- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSDictionary*prepareLayoutDict,NSInteger prepareHeight))callback;
@end
