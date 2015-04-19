#import "MFViewController.h"
#import "MFLayoutCenter.h"
#import "MFResourceCenter.h"
#import "MFSceneFactory.h"
#import "HTMLParser.h"
#import "ESCssParser.h"
#import "UIView+Sizes.h"
#import "MFDefine.h"
#import "MFBridge.h"
#import "MFCell.h"
#import "MFHelper.h"
#import "MFDOM.h"
#import "MFScene.h"
#import "UIView+UUID.h"
#import "MFSceneCenter.h"

@interface MFViewController() <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic, strong) MFScene *scene;
@property (nonatomic, copy) NSString *sceneName;

@end

@implementation MFViewController

#pragma - lifeCycle
- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [[MFResourceCenter sharedMFResourceCenter] removeAll];
    [[MFSceneCenter sharedMFSceneCenter] releaseHtmlParserWithName:self.sceneName];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[MFSceneCenter sharedMFSceneCenter] unRegisterScene:self.sceneName];
}

- (instancetype)initWithSceneName:(NSString *)sceneName
{
    self = [super init];
    if (self) {
        //场景初始化
        self.scene = [[MFSceneCenter sharedMFSceneCenter] loadSceneWithName:sceneName];
        self.sceneName = sceneName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    [self setupDataSource:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[MFSceneCenter sharedMFSceneCenter] registerScene:self.scene withName:self.sceneName];
}

#pragma mark - Data
- (void)setupDataSource:(NSDictionary*)params
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dataSourcePath = [NSString stringWithFormat:@"%@/%@.plist", bundlePath, self.sceneName];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:dataSourcePath];
    self.scene.dataArray = [data objectForKey:@"data"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.scene autoLayoutOperations:self.scene.dataArray callback:^(NSInteger prepareHeight) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }];
    });
    
}

#pragma mark - UI
- (void)setupUI
{
    if (nil == self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor grayColor];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.allowsSelection = YES;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    if (!self.tableView.superview) {
        [self.view addSubview:self.tableView];
    }

    self.title = @"魔方";
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.scene.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MFCell cellHeightWithScene:self.scene withIndex:indexPath.section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = self.scene.dataArray[indexPath.section];
    MFAlignmentType alignType = [dataDict[KEY_WIDGET_ALIGNMENTTYPE] intValue];

    NSString *tId = dataDict[KEYWORD_TEMPLATE_ID];
    NSString *identifier = [NSString stringWithFormat:@"%@_%d",tId, alignType];

    MFCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[MFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setupUIWithScene:self.scene withTemplateId:tId];
    }

    //布局设置
    [cell layoutWithScene:self.scene withIndex:indexPath.section withAlignmentType:alignType];
    //数据绑定
    [cell bindDataWithScene:self.scene withIndex:indexPath.section];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}
@end
