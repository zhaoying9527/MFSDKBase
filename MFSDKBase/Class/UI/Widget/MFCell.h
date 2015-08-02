//
//  MFCell.h
//
//

#import <UIKit/UIKit.h>
#import "MFDefine.h"

@class HTMLNode;
@class MFScene;
@class MFCell;

@protocol MFCellDelegate <NSObject>
- (void)didClickCTCell:(MFCell*)cell;
@end

@interface MFCell : UITableViewCell
@property (nonatomic, copy) NSString *tId;
@property (nonatomic, strong)NSDictionary *dataItem;
@property (nonatomic, weak)id<MFCellDelegate> delegate;

/**
 *  特殊业务逻辑处理
 */
- (void)specialHandling;

@end
