#import <UIKit/UIKit.h>

@interface MFViewController : UIViewController
- (id)initWithSceneName:(NSString *)sceneName;
- (void)setupDataSource:(NSDictionary*)data;
@end
