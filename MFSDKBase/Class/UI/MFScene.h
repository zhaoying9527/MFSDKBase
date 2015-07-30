//
//  MFScene.h
//  MFSDK
//
//  Created by 赵嬴 on 15/4/8.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MFDefine.h"

/*
 *  虚拟场景
 */

typedef enum {
    MFDomTypeBody = 0,
    MFDomTypeHead = 1,
    MFDomTypeFoot = 2,
} MFDomType;

typedef NSMutableArray* (^MFDataAdapterBlock)(NSMutableArray *data);

@class MFDOM;
@class MFViewController;
@interface MFScene : NSObject

@property (nonatomic,copy)NSString              *sceneName;         /*场景名*/
@property (nonatomic,strong)NSMutableArray      *dataArray;         /*场景数据*/
@property (nonatomic,strong)NSMutableArray      *virtualNodes;      /*虚拟Node*/
@property (nonatomic,copy)MFDataAdapterBlock    adapterBlock;       /*数据适配*/
@property (nonatomic,strong)NSMutableDictionary *headerLayoutDict;  /*cell头部布局信息*/
@property (nonatomic,strong)NSMutableDictionary *bodyLayoutDict;    /*cell正文布局信息*/
@property (nonatomic,strong)NSMutableDictionary *footerLayoutDict;  /*cell尾部布局信息*/

/**
 *  是否支持特定的模版
 *  @param tId               模版ID
 */
- (BOOL)matchingTemplate:(NSString*)tId;

/**
 *  取模版Id,模版前缀为“tId－”
 *  @param data              数据源
 *  @param return            模版Id
 */
- (NSString*)templateIdWithData:(NSDictionary*)data;

/**
 *  布局字典Key计算
 *  @param data              数据源
 *  @param return            布局字典的key
 */
- (NSString*)privateKeyWithData:(NSDictionary*)data;

/**
 *  布局信息批量计算,计算后的布局信息保存在scene的layoutDict
 *  @param dataArray         数据源
 *  @param callback          回调处理,返回布局信息(包括头部正文和尾部)
 */
- (void)calculateLayoutInfo:(NSArray*)dataArray callback:(void(^)(NSInteger prepareHeight))callback;

/**
 *  返回View及其子view中class属性为domClass的特定view
 *  @param domClass          class属性值
 *  @param view              视图view
 */
+ (UIView*)findViewWithDomClass:(NSString*)domClass withView:(UIView*)view;

/**
 *  清空数据及布局信息
 */
- (void)removeAll;

/**
 *  删除数据及布局信息
 */
- (void)removeData:(NSArray*)data;


/**
 *  加载、更新数据,回调完成后布局信息保存在scene中，并且返回创建好的view
 *  @param data               数据源
 *  @param dataAdapterBlock   数据适配接口
 *  @param completionBlock    回调接口，返回创建好的view
 */
- (void)sceneViewReloadData:(NSDictionary*)data
           dataAdapterBlock:(MFDataAdapterBlock)dataAdapterBlock
            completionBlock:(void(^)(UIView*view))completionBlock;

/**
 *  加载、更新数据,回调完成后布局信息保存在scene中，并且返回创建好的viewController
 *  @param data               数据源
 *  @param dataAdapterBlock   数据适配接口
 *  @param completionBlock    回调接口，返回创建好的viewController
 */
- (void)sceneViewControllerReloadData:(NSArray*)data
                     dataAdapterBlock:(MFDataAdapterBlock)dataAdapterBlock
                      completionBlock:(void(^)(MFViewController*viewControler))completionBlock;
@end
