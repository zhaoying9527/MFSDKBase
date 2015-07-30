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
@property (nonatomic, strong)NSDictionary *dataItem;
@property (nonatomic, weak)id<MFCellDelegate> delegate;

/**
 *  计算高度
 *  @param scene         cell所在场景
 *  @param data          cell对应数据
 *  @return              cell高度
 */
+ (CGFloat)cellHeightWithScene:(MFScene*)scene withData:(NSDictionary*)data withIndex:(NSInteger)index;

/**
 *  创建视图结构
 *  @param scene         cell所在场景
 *  @param tId           cell对应模版ID
 */
- (void)setupUIWithScene:(MFScene*)scene withTemplateId:(NSString*)tId withIndex:(NSInteger)index;

/**
 *  页面布局
 *  @param scene         cell所在场景
 *  @param data          cell对应数据
 */
- (void)layoutWithScene:(MFScene*)scene withData:(NSDictionary*)data withIndex:(NSInteger)index;

/**
 *  数据绑定
 *  @param scene         cell所在场景
 *  @param data          cell对应数据
 */
- (void)bindDataWithScene:(MFScene*)scene withData:(NSDictionary*)data withIndex:(NSInteger)index;

/**
 *  特殊业务逻辑处理
 *  @param data          cell对应数据
 */
- (void)specialHandlingWithData:(NSDictionary*)data;

@end
