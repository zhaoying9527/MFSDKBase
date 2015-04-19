//
//  MFCell.h
//
//

#import <UIKit/UIKit.h>

@class HTMLNode;
@interface MFCell : UITableViewCell

/**
 *  计算高度
 *  @param scene         cell所在场景
 *  @param index         cell对应数据索引
 *  @return              cell高度
 */
+ (CGFloat)cellHeightWithScene:(MFScene*)scene withIndex:(NSInteger)index;

/**
 *  创建视图结构
 *  @param scene         cell所在场景
 *  @param tId           cell对应模版ID
 */
- (void)setupUIWithScene:(MFScene*)scene withTemplateId:(NSString*)tId;

/**
 *  页面布局
 *  @param scene         cell所在场景
 *  @param index         cell对应数据索引
 *  @param alignType     cell左、中、右显示位置
 */
- (void)layoutWithScene:(MFScene*)scene withIndex:(NSInteger)index withAlignmentType:(MFAlignmentType)alignType;

/**
 *  数据绑定
 *  @param scene         cell所在场景
 *  @param index         cell对应数据索引
 */
- (void)bindDataWithScene:(MFScene*)scene withIndex:(NSInteger)index;

@end
