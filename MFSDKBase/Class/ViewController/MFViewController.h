#import <UIKit/UIKit.h>
#import "MFScene.h"
#import "MFCell.h"

@class MFScene;
@class MFCellDelegate;

@interface MFViewController : UIViewController
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MFScene *scene;
@property (nonatomic,copy) NSString *sceneName;

/**
 *  返回使用Cell类名
 */
- (NSString*)cellClassName;

/**
 *  UI初始化设置，子类可重载
 */
- (void)setupUI;

/**
 *  页面创建初始化
 *  @param sceneName     页面对应场景名
 */
- (void)loadSceneWithName:(NSString *)sceneName;

/**
 *  加载页面数据源
 */
- (void)loadData;

/**
 *  数据适配
 *  @param data          原始数据
 *  @return              适配接口, 如果不需适配直接返回nil
 */
- (MFDataAdapterBlock)dataAdapterBlock;

@end
