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
@property (nonatomic, copy) NSString *scriptName;

@end

@implementation MFViewController

#pragma - lifeCycle
- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    [[MFResourceCenter sharedMFResourceCenter] removeAll];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[MFSceneCenter sharedMFSceneCenter] removeSceneWithName:self.scriptName];
}

- (instancetype)initWithScriptName:(NSString *)scriptName
{
    self = [super init];
    if (self) {
        //场景初始化
        self.scene = [[MFSceneCenter sharedMFSceneCenter] loadSceneWithName:scriptName];
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

- (void)viewDidAppear:(BOOL)animated
{
    [[MFSceneCenter sharedMFSceneCenter] registerScene:self.scene WithName:self.scriptName];
}

#pragma mark - Data
- (void)prepareData:(NSDictionary*)params
{
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    NSString *dataSourcePath = [NSString stringWithFormat:@"%@/%@.plist", bundlePath, self.scriptName];
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
    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    CGFloat height = [self.scene.headerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    height += [self.scene.bodyLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    height += [self.scene.footerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    return height;
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
        cell.userInteractionEnabled = YES;
        cell.contentView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
        UIView *sceneHeadCanvas = [self.scene sceneViewWithDomId:tId withType:MFDomTypeHead];
        UIView *sceneBodyCanvas = [self.scene sceneViewWithDomId:tId withType:MFDomTypeBody];
        UIView *sceneFootCanvas = [self.scene sceneViewWithDomId:tId withType:MFDomTypeFoot];
        if (nil != sceneHeadCanvas) {
            [cell.contentView addSubview:sceneHeadCanvas];
        }
        if (nil != sceneBodyCanvas) {
            [cell.contentView addSubview:sceneBodyCanvas];
        }
        if (nil != sceneFootCanvas) {
            [cell.contentView addSubview:sceneFootCanvas];
        }
    }

    //布局设置
    [self.scene layout:cell.contentView withIndex:indexPath.section withAlignmentType:alignType];

    //数据绑定
    [self.scene bind:cell.contentView withIndex:indexPath.section];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
