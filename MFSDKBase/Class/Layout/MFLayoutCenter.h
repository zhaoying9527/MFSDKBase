//
//  MFLayoutCenter.h

#import <UIKit/UIKit.h>
#import "MFDefine.h"
#import "MFSDK.h"

@class MFDOM;
@class MFVirtualNode;
@interface MFLayoutCenter : NSObject

SYNTHESIZE_SINGLETON_FOR_HEADER(MFLayoutCenter)

/**
 *  计算头部Node布局信息
 *  @param node          虚拟view Node节点
 *  @param superFrame    父节点frame
 *  @param dataSource    数据信息
 *  @return              布局信息
 */
- (NSDictionary*)sizeOfHeadNode:(MFVirtualNode*)node superFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource;

/**
 *  计算正文Dom布局信息
 *  @param node          虚拟view Node节点
 *  @param superFrame    父节点frame
 *  @param dataSource    数据信息
 *  @return              布局信息
 */
- (NSDictionary*)sizeOfBodyNode:(MFVirtualNode*)node superFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource;

/**
 *  计算尾部Dom布局信息
 *  @param node          虚拟view Node节点
 *  @param superFrame    父节点frame
 *  @param dataSource    数据信息
 *  @return              布局信息
 */
- (NSDictionary*)sizeOfFootNode:(MFVirtualNode*)node superFrame:(CGRect)superFrame dataSource:(NSDictionary*)dataSource;

/**
 *  视图页面布局
 *  @param view          视图
 *  @param sizeInfo      对应布局信息
 */
- (void)layout:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo;
- (void)layout:(UIView*)view;
/**
 *  视图左、中、右位置处理
 *  @param view          视图
 *  @param sizeInfo      对应布局信息
 *  @param alignType     对齐类型
 */
- (void)sideSubViews:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo withAlignmentType:(MFAlignmentType)alignType;
- (void)sideSubViews:(UIView*)view withAlignmentType:(MFAlignmentType)alignType;

/**
 *  视图镜像翻转处理
 *  @param view          视图
 *  @param sizeInfo      对应布局信息
 */
- (void)reverseSubViews:(UIView*)view withSizeInfo:(NSDictionary *)sizeInfo;
- (void)reverseSubViews:(UIView*)view;
@end
