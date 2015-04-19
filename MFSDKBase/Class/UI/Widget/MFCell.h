//
//  MFCell.h
//
//

#import <UIKit/UIKit.h>

@class HTMLNode;
@interface MFCell : UITableViewCell

+ (CGFloat)cellHeightWithScene:(MFScene*)scene withIndex:(NSInteger)index;

- (void)setupUIWithScene:(MFScene*)scene withTemplateId:(NSString*)tId;
- (void)layoutWithScene:(MFScene*)scene withIndex:(NSInteger)index withAlignmentType:(MFAlignmentType)alignType;
- (void)bindDataWithScene:(MFScene*)scene withIndex:(NSInteger)index;

@end
