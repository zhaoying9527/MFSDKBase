#import "MFViewController.h"
#import "MFLayoutCenter.h"
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

@property (nonatomic, copy) NSString *scriptName;
@property (nonatomic, strong) MFScene *scene;

@end

@implementation MFViewController

#pragma - lifeCycle
- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
}

- (instancetype)initWithScriptName:(NSString *)scriptName
{
    self = [super init];
    if (self) {
        //场景初始化
        self.scene = [[MFSceneCenter sharedMFSceneCenter] addSceneWithName:scriptName];
        self.scriptName = scriptName;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    [self prepareData:nil];
}

#pragma mark - Data
- (void)prepareData:(NSDictionary*)params
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dataSourcePath = [NSString stringWithFormat:@"%@/%@.plist", bundlePath, self.scriptName];
    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:dataSourcePath];
    self.scene.dataArray = [data objectForKey:@"data"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.scene autoLayoutOperations:self.scene.dataArray callback:^(NSDictionary *prepareLayoutDict, NSInteger prepareHeight) {
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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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
    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    return [self.scene.layoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
/*
    NSDictionary *dataDict = self.scene.dataArray[indexPath.section];
    NSString *templateId = dataDict[KEYWORD_TEMPLATE_ID];
    MFDOM *matchDom = [self.scene domWithId:templateId];

    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSInteger retHeight = [self.scene.layoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    if (retHeight <= 0) {
        CGRect superFrame = CGRectMake(0, 0, [MFHelper screenXY].width, 0);
        NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfDom:matchDom superDomFrame:superFrame dataSource:dataDict];
        [self.scene.layoutDict setObject:indexPathDict forKey:indexKey];
        retHeight = [indexPathDict[KEY_WIDGET_HEIGHT] intValue];
    }
    return retHeight;
*/

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = self.scene.dataArray[indexPath.section];
    
    NSString *tId = dataDict[KEYWORD_TEMPLATE_ID];
    NSString *identifier = [NSString stringWithFormat:@"%@",tId];

    MFCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[MFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.userInteractionEnabled = YES;
        UIView *sceneCanvas = [self.scene sceneViewWithDomId:tId];
        if (nil != sceneCanvas) {
            [cell.contentView addSubview:sceneCanvas];
        }
    }
    
    //数据绑定
    [self.scene bind:cell.contentView withIndex:indexPath.section];
    //布局设置
    [self.scene layout:cell.contentView withIndex:indexPath.section];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
