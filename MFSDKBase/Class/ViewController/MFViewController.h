#import <UIKit/UIKit.h>

@protocol MFViewControllerDelegate<NSObject, UIScrollViewDelegate>
- (void)prepareData:(NSDictionary*)params;
@end

@interface MFViewController : UIViewController
@property (nonatomic,weak)id<MFViewControllerDelegate> delegate;

- (id)initWithScriptName:(NSString *)scriptName;
@end
