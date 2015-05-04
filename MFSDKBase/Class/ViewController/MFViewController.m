#import "MFViewController.h"
#import "MFLayoutCenter.h"
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

@interface MFViewController() <UITableViewDataSource,UITableViewDelegate, MFCellDelegate>
@end

@implementation MFViewController

#pragma - lifeCycle
- (void)dealloc
{
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[MFSceneCenter sharedMFSceneCenter] registerScene:self.scene withName:self.sceneName];
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
    __block CGFloat retHeight = [MFCell cellHeightWithScene:self.scene withData:dataDict];
    if (retHeight <= 0) {
        [self.scene calculateLayoutInfo:@[dataDict] callback:^(NSInteger prepareHeight) {
            retHeight = prepareHeight;
        }];
    }
    return retHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = self.scene.dataArray[indexPath.section];
    NSString *tId = [self.scene templateIdWithData:dataDict];
    
    MFCell *cell = [self dequeueReusablePKCellWithIdentifier:dataDict];
    if (nil == cell) {
        cell = [self allocPKCellWithIdentifier:dataDict];
        [cell setupUIWithScene:self.scene withTemplateId:tId];
    }
    
    //布局设置
    [cell layoutWithScene:self.scene withData:dataDict];
    //数据绑定
    [cell bindDataWithScene:self.scene withData:dataDict];
    //特殊逻辑处理
    [cell specialHandlingWithData:dataDict];
    //数据设置
    [cell setDataItem:dataDict];
    //代理设置
    [cell setDelegate:self];
    
    return cell;
}

- (void)didClickCTCell:(MFCell*)cell{;}

- (MFCell*)allocPKCellWithIdentifier:(NSDictionary*)dataDict
{
    NSString *tId = [self.scene templateIdWithData:dataDict];
    NSString *identifier = [NSString stringWithFormat:@"%@",tId];
    return [[NSClassFromString([self cellClassName]) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
}
- (MFCell*)dequeueReusablePKCellWithIdentifier:(NSDictionary*)dataDict
{
    NSString *tId = [self.scene templateIdWithData:dataDict];
    NSString *identifier = [NSString stringWithFormat:@"%@",tId];
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}
@end
