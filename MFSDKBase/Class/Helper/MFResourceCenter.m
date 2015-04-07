//
//  MFResourceCenter.m

#import "MFResourceCenter.h"
#import "MFDefine.h"
#import "MFHelper.h"
#import "MFStrategyCenter.h"

@interface MFResourceCenter()
@property (nonatomic,strong)NSDictionary *resMapDict;
@property (nonatomic,strong)NSMutableDictionary *resImageDict;
@end

@implementation MFResourceCenter
SYNTHESIZE_SINGLETON_FOR_CLASS(MFResourceCenter)
- (void)dealloc
{
    
}
- (void)removeAll
{
    self.resImageDict = nil;
    self.resMapDict = nil;
}

- (UIImage*)bannerImage
{
    NSString *key = @"defaultbanner";
    UIImage *image = [self cacheImageWithId:key];
    if (nil == image) {
        image = [MFHelper stretchableBannerCellImage:[MFResourceCenter imageNamed:@"bannerImage.png"]];
        [self cacheImage:image key:key];
    }
    return image;
}

+ (UIImage*)imageNamed:(NSString*)imagePath
{
    NSString *imagePathString = [NSString stringWithFormat:@"%@/%@",[MFHelper getBundleName],imagePath];
    return [UIImage imageNamed:imagePathString];
}

- (UIImage*)cacheImageWithId:(NSString*)imageId
{
   return  [self.resImageDict objectForKey:imageId];
}

- (void)cacheImage:(UIImage*)image key:(NSString*)key
{
    if (nil == self.resImageDict) {
        self.resImageDict = [[NSMutableDictionary alloc] init];
    }
    
    if (nil != image && nil != key) {
       [self.resImageDict setObject:image forKey:key];
    }
}

- (UIImage*)imageWithId:(NSString*)imageId
{
    if (nil == self.resMapDict) {
        self.resMapDict = [[MFStrategyCenter sharedMFStrategyCenter] sourceWithID:@"MFResMap"];
    }
  
    NSString *imagePath = [self.resMapDict objectForKey:imageId];
    if (nil == imagePath) {
        imagePath = imageId;
    }

    return [UIImage imageNamed:imagePath];;
}
@end
