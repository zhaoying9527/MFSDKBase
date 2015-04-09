//
//  MFCell.h
//
//

#import <UIKit/UIKit.h>

@class HTMLNode;
@interface MFCell : UITableViewCell
@property (nonatomic, copy)NSString *pageID;
@property (nonatomic, assign)NSInteger pageHeight;
@property (nonatomic, assign)NSInteger pageWidth;
@property (nonatomic, assign)BOOL canDelete;

- (void)setupNotify;
- (void)releaseNotify;
- (void)specialHandling;
- (void)setupUI;
- (void)releaseUI;

@end
