//
//  MFCell.h
//
//

#import <UIKit/UIKit.h>

@class HTMLNode;
@interface MFCell : UITableViewCell
@property (nonatomic, assign) NSIndexPath *indexPath;

- (void)setupNotify;
- (void)releaseNotify;
- (void)setupUI;
- (void)releaseUI;

@end
