//
//  MFResourceCenter.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MFDefine.h"

@interface MFResourceCenter : NSObject
SYNTHESIZE_SINGLETON_FOR_HEADER(MFResourceCenter)
+ (UIImage*)imageNamed:(NSString*)imagePath;
- (void)removeAll;
- (UIImage*)bannerImage;
- (UIImage*)imageWithId:(NSString*)imageId;
- (UIImage*)cacheImageWithId:(NSString*)imageId;
- (void)cacheImage:(UIImage*)image key:(NSString*)key;
@end
