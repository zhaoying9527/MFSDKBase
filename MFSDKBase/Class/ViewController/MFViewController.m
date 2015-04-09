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




#import "MFSceneCenter.h"

@interface MFViewController() <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *indexPathDictionary;

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
    self.dataArray = [data objectForKey:@"data"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self autoLayoutOperations:self.dataArray callback:^(NSDictionary *prepareLayoutDict, NSInteger prepareHeight) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.indexPathDictionary = [NSMutableDictionary dictionaryWithDictionary:prepareLayoutDict];
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

    self.title = @"Master";
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = self.dataArray[indexPath.section];
    NSString *templateId = [dataDict objectForKey:KEYWORD_TEMPLATE_ID];
    MFDOM *matchDom = [self.scene.dom findSubDomWithID:templateId];

    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSInteger retHeight = [[[self.indexPathDictionary objectForKey:indexKey] objectForKey:KEY_WIDGET_HEIGHT] intValue];
    if (retHeight <= 0) {
        CGRect superFrame = CGRectMake(0, 0, [MFHelper screenXY].width, 0);
        NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfDom:matchDom superDomFrame:superFrame dataSource:dataDict];
        [self.indexPathDictionary setObject:indexPathDict forKey:indexKey];
        retHeight = [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }

    return retHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = self.dataArray[indexPath.section];
    
    NSString *templateId = [dataDict objectForKey:KEYWORD_TEMPLATE_ID];
    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSString *identifier = templateId;

    MFCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.userInteractionEnabled = YES;
        cell.contentView.layer.borderWidth = 0.5;
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }

    MFDOM *matchDom = [self.scene.dom findSubDomWithID:templateId];
    NSDictionary * sumLayoutInfo = [self.indexPathDictionary objectForKey:indexKey];
    NSDictionary * widgetSizeDict = sumLayoutInfo[KEY_WIDGET_SIZE];
    NSInteger cellHeight = [sumLayoutInfo[KEY_WIDGET_HEIGHT] intValue];
    NSInteger cellWidth = [sumLayoutInfo[KEY_WIDGET_WIDTH] intValue];
    [cell.contentView removeAllSubviews];
    [cell setFrame:CGRectMake(0, 0, cellWidth, cellHeight)];

    UIView *templateView = [[MFSceneFactory sharedMFSceneFactory] createUIWithDOM:matchDom sizeInfo:widgetSizeDict];
    [cell.contentView addSubview:templateView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSDictionary*prepareLayoutDict,NSInteger prepareHeight))callback
{
    NSInteger retHeight = 0;
    NSMutableDictionary * indexPathDictionary = [[NSMutableDictionary alloc] initWithCapacity:self.dataArray.count];
    for (int accessIndex=0; accessIndex < dataArray.count; accessIndex++) {
        NSDictionary *dataDict = [dataArray objectAtIndex:accessIndex];
        NSString *templateId = [dataDict objectForKey:KEYWORD_TEMPLATE_ID];
        MFDOM *matchDom = [self.scene.dom findSubDomWithID:templateId];
        NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)accessIndex];

        CGRect superFrame = CGRectMake(0, 0, [MFHelper screenXY].width, 0);
        NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] sizeOfDom:matchDom superDomFrame:superFrame dataSource:dataDict];
        [indexPathDictionary setObject:indexPathDict forKey:indexKey];
        retHeight += [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }
    callback(indexPathDictionary, retHeight);
}
@end
