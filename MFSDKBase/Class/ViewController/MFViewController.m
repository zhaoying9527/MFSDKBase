#import "MFViewController.h"
#import "MFLayoutCenter.h"
#import "MFDispatchCenter.h"
#import "MFResourceCenter.h"
#import "MFScene+Internal.h"
#import "MFSceneFactory.h"
#import "HTMLParsers.h"
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

@interface MFViewController() <UITableViewDataSource,UITableViewDelegate, MFCellDelegate, MFEventProtcol>
@end

@implementation MFViewController

#pragma - lifeCycle
- (void)dealloc
{
    [self removeNotify];
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [[MFResourceCenter sharedMFResourceCenter] removeAll];
    [[MFSceneCenter sharedMFSceneCenter] releaseSceneWithName:self.sceneName];
}

- (void)loadSceneWithName:(NSString *)sceneName
{
    //场景初始化
    self.scene = [[MFSceneCenter sharedMFSceneCenter] loadSceneWithName:sceneName];
    self.sceneName = sceneName;
    self.scene.adapterBlock = [self dataAdapterBlock];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[MFSceneCenter sharedMFSceneCenter] unRegisterScene:self.sceneName];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self loadData];
    
    [self setupNotify];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[MFSceneCenter sharedMFSceneCenter] registerScene:self.scene withName:self.sceneName];
}

- (void)setupNotify
{
}
- (void)removeNotify{
}

#pragma - strategy
- (NSString*)cellClassName
{
    return @"MFCell";
}

#pragma mark - UI
- (void)setupUI
{
    if (nil == self.tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.opaque = YES;
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.allowsSelection = NO;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollsToTop = YES;
    }
    if (!self.tableView.superview) {
        [self.view addSubview:self.tableView];
    }
    self.title = @"魔方";
}

#pragma mark - Data
- (void)loadData
{
    NSString *bundlePath = [[NSString alloc] initWithFormat:@"%@/%@",[MFHelper getResourcePath],[MFHelper getBundleName]];
    NSString *dataSourcePath = [NSString stringWithFormat:@"%@/%@.plist", bundlePath, @"MFChat"];
    NSDictionary *dataSource = [[NSDictionary alloc] initWithContentsOfFile:dataSourcePath];
    NSArray *dataArray = [dataSource objectForKey:@"data"];

    __weak typeof(self) wSelf= self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [wSelf.scene calculateLayoutInfo:dataArray callback:^(NSArray *virtualNodes) {
            wSelf.scene.dataArray = [NSMutableArray arrayWithArray:dataArray];
            wSelf.scene.virtualNodes = [NSMutableArray arrayWithArray:virtualNodes];
        }];

         dispatch_async(dispatch_get_main_queue(), ^{
             [wSelf.tableView reloadData];
         });
    });
}

- (MFDataAdapterBlock)dataAdapterBlock
{
    return nil;
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
    NSDictionary *dataDict = self.scene.dataArray[indexPath.section];
    CGFloat retHeight = [self.scene cellHeightWithIndex:indexPath.section];
    if (retHeight <= 0) {
        [self.scene calculateLayoutInfo:@[dataDict] callback:^(NSArray *virtualNodes) {}];
        retHeight = [self.scene cellHeightWithIndex:indexPath.section];
    }
    return retHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MFCell *cell = [self.scene buildUIWithTableView:tableView className:[self cellClassName] index:indexPath.section];
    [self.scene layout:cell];
    [self.scene bindData:cell];

    //特殊逻辑处理
    [cell specialHandling];
    //代理设置
    [cell setDelegate:self];
    
    return cell;
}

- (void)didClickCTCell:(MFCell*)cell
{
}

//Native拦截优先处理事件，处理了返回YES，否则返回NO
- (BOOL)handleNativeEvent:(NSDictionary *)eventInfo target:(id)sender
{
    return NO;
}
@end
