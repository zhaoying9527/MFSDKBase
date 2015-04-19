#import <UIKit/UIKit.h>

@interface MFViewController : UIViewController

/**
 *  UI初始化设置，子类可重载
 */
- (void)setupUI;

/**
 *  页面创建初始化
 *  @param sceneName     页面对应场景名
 *  @return              UIViewController
 */
- (instancetype)initWithSceneName:(NSString *)sceneName;

/**
 *  页面数据源配置
 *  @param data          页面显示数据
 */
- (void)setupDataSource:(NSDictionary*)data;

@end
