#import "MFViewController.h"
#import "HTMLParser.h"
#import "ESCssParser.h"
#import "UIView+Sizes.h"
#import "MFDefine.h"
#import "MFBridge.h"
#import "MFCell.h"
#import "MFHelper.h"
#import "MFLayoutCenter.h"



#import "MFSceneCenter.h"

@interface MFViewController() <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableDictionary *indexPathDictionary;

@property (nonatomic, copy) NSString *scriptName;
@property (nonatomic, strong) HTMLParser *html;
@property (nonatomic, strong) NSDictionary *css;
@property (nonatomic, strong) NSDictionary *dataBindings;
@property (nonatomic, strong) NSDictionary *actions;

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
        [[MFSceneCenter sharedMFSceneCenter] initSceneWithName:scriptName];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self setupUI];
    [self loadData];
}

#pragma mark - Data
- (void)loadData
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

    HTMLNode *titleNode = [self.html.head firstChild];
    self.title = [titleNode contents];
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
    NSDictionary *layoutDict = self.css;
    NSDictionary *dataBinding = self.dataBindings;
    NSArray *matchNodes = [self.html.body findChildrenWithAttribute:@"id" matchingName:templateId allowPartial:NO];
    HTMLNode *pageNode = [matchNodes firstObject];

    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSInteger retHeight = [[[self.indexPathDictionary objectForKey:indexKey] objectForKey:KEY_WIDGET_HEIGHT] intValue];
    if (retHeight <= 0) {
        NSMutableDictionary *widgetDict = [NSMutableDictionary dictionary];
        NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] getLayoutInfoForPage:pageNode
                                                                                       templateId:templateId
                                                                                        styleDict:layoutDict
                                                                                         dataDict:dataDict
                                                                                      dataBinding:dataBinding
                                                                                  parentViewFrame:CGRectMake(0, 0, [MFHelper screenXY].width, 0)
                                                                                    retWidgetInfo:widgetDict];
        

        if (nil != indexKey) {
            [self.indexPathDictionary setObject:indexPathDict forKey:indexKey];
        }
        retHeight =  [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }

    return retHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDict = self.dataArray[indexPath.section];
    
    NSString *tempateId = [dataDict objectForKey:KEYWORD_TEMPLATE_ID];
    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)indexPath.section];
    NSString *identifier = tempateId;

    MFCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MFCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.userInteractionEnabled = YES;
    }
    
    NSArray *matchNodes = [self.html.body findChildrenWithAttribute:@"id" matchingName:tempateId allowPartial:NO];
    HTMLNode *pageNode = [matchNodes firstObject];
    NSDictionary *layoutDict = self.css;
    NSDictionary *dataBinding = self.dataBindings;

    NSDictionary * sumLayoutInfoItems = [self.indexPathDictionary objectForKey:indexKey];
    NSDictionary * widgetSizeDict = [sumLayoutInfoItems objectForKey:KEY_WIDGET_SIZE];
    NSInteger cellHeight = [[sumLayoutInfoItems objectForKey:KEY_WIDGET_HEIGHT] intValue];
    NSInteger cellWidth = [[sumLayoutInfoItems objectForKey:KEY_WIDGET_WIDTH] intValue];
    CGSize screenXY = [MFHelper screenXY];
    [cell setFrame:CGRectMake(0, 0, screenXY.width , cellHeight)];
    [cell setPageHeight:cellHeight];
    [cell setPageWidth:cellWidth];
    [cell createPage:tempateId pageNode:pageNode styleParams:layoutDict dataBinding:dataBinding parentView:cell.contentView];
    [cell setAutoLayoutSizeInfo:widgetSizeDict];
    [cell bindingAndLayoutPageData:dataDict parentView:cell.contentView];

    cell.contentView.layer.borderWidth = 0.5;
    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)autoLayoutOperations:(NSArray*)dataArray callback:(void(^)(NSDictionary*prepareLayoutDict,NSInteger prepareHeight))callback
{
    NSInteger retHeight = 0;
    NSMutableDictionary * indexPathDictionary = [[NSMutableDictionary alloc] initWithCapacity:self.dataArray.count];
    for (int accessIndex=0; accessIndex < [dataArray count]; accessIndex++) {
        NSDictionary *dataDict = [dataArray objectAtIndex:accessIndex];
        NSString *templateId = [dataDict objectForKey:KEYWORD_TEMPLATE_ID];
        NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)accessIndex];
        NSDictionary *layoutDict = self.css;
        NSDictionary *dataBinding = self.dataBindings;
        NSArray *matchNodes = [self.html.body findChildrenWithAttribute:@"id" matchingName:templateId allowPartial:NO];
        HTMLNode *pageNode = [matchNodes firstObject];
        NSMutableDictionary *widgetDict = [NSMutableDictionary dictionary];
        NSDictionary *indexPathDict = [[MFLayoutCenter sharedMFLayoutCenter] getLayoutInfoForPage:pageNode templateId:templateId styleDict:layoutDict dataDict:dataDict dataBinding:dataBinding parentViewFrame:CGRectMake(0, 0, [MFHelper screenXY].width, 0) retWidgetInfo:widgetDict];

        if (nil != indexKey) {
            [indexPathDictionary setObject:indexPathDict forKey:indexKey];
        }
        retHeight += [[indexPathDict objectForKey:KEY_WIDGET_HEIGHT] intValue];
    }
    callback(indexPathDictionary,retHeight);
}
@end
