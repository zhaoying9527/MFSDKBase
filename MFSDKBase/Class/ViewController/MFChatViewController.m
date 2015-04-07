#import "MFChatViewController.h"
#import "HTMLParser.h"
#import "ESCssParser.h"

//@interface MFChatViewController() <UITableViewDataSource,UITableViewDelegate>
//@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) NSMutableArray *dataArray;
//
//@property (nonatomic, copy) NSString *scriptName;
//@property (nonatomic, strong) HTMLParser *html;
//@property (nonatomic, strong) NSDictionary *css;
//@property (nonatomic, strong) NSDictionary *dataBindings;
//@property (nonatomic, strong) NSDictionary *actions;
//
//@property (nonatomic, strong) NSMutableArray *array;
//@end
//
//@implementation MFChatViewController
//
//#pragma - lifeCycle
//- (void)dealloc
//{
//    self.tableView.delegate = nil;
//    self.tableView.dataSource = nil;
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//}
//
//- (id)initWithScriptName:(NSString *)scriptName
//{
//    self = [super init];
//    if (self) {
//        self.array = [NSMutableArray array];
//        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//        NSString *htmlPath = [NSString stringWithFormat:@"%@/%@.html", bundlePath, scriptName];
//        NSString *cssPath = [NSString stringWithFormat:@"%@/%@.css", bundlePath, scriptName];
//        NSString *dataBindingPath = [NSString stringWithFormat:@"%@/%@.dataBinding", bundlePath, scriptName];
//
//        NSError *error = nil;
//        self.scriptName = scriptName;
//        self.html = [[HTMLParser alloc] initWithString:[NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&error] error:&error];
//        self.css = [[[ESCssParser alloc] init] parseText:[NSString stringWithContentsOfFile:cssPath encoding:NSUTF8StringEncoding error:&error]];
//        self.dataBindings = [[[ESCssParser alloc] init] parseText:[NSString stringWithContentsOfFile:dataBindingPath encoding:NSUTF8StringEncoding error:&error]];
//        [[MFBridge sharedMFBridge] configWithScriptName:[NSString stringWithFormat:@"%@.lua", scriptName]];
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor blackColor];
//    [self setupUI];
//    [self loadData];
//}
//
//#pragma mark - Data
//- (void)loadData
//{
//    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
//    NSString *dataSourcePath = [NSString stringWithFormat:@"%@/%@.plist", bundlePath, self.scriptName];
//    NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:dataSourcePath];
//    self.dataArray = [data objectForKey:@"data"];
//    [self.tableView reloadData];
//}
//
//#pragma mark - UI
//- (void)setupUI
//{
//    if (nil == self.tableView) {
//        self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        self.tableView.backgroundColor = [UIColor grayColor];
//        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        self.tableView.allowsSelection = YES;
//        self.tableView.delegate = self;
//        self.tableView.dataSource = self;
//    }
//    if (!self.tableView.superview) {
//        [self.view addSubview:self.tableView];
//    }
//
//    HTMLNode *titleNode = [self.html.head firstChild];
//    self.title = [titleNode contents];
//}
//
//#pragma mark - UITableViewDelegate
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return [self.dataArray count];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 1;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 150;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dataDict = self.dataArray[indexPath.section];
//    NSString *identifier = [NSString stringWithFormat:@"%@",dataDict[@"templateId"]];
//    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.userInteractionEnabled = YES;
//    }
//
//    UIView * containerView = [PKFactory createUiWithLayout:self.html.body style:self.css vmId:dataDict[@"templateId"]];
//    [PKDataBinding bindingView:containerView withDataSource:self.dataArray[indexPath.section] dataBinding:self.dataBindings];
//    
//    for (UIView *view in cell.contentView.subviews) {
//        [view removeFromSuperview];
//    }
//    if ([containerView isKindOfClass:[UITableViewCell class]]) {
//        cell = (UITableViewCell *)containerView;
//    } else {
//        [cell.contentView addSubview:containerView];
//    }
//    cell.contentView.layer.borderWidth = 0.5;
//    cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}
//
//- (void)delegateMethod:(id)obj
//{
//    NSLog(@"%@",obj);
//    NSLog(@"%lu", (unsigned long)self.array.count);
//}
//@end
