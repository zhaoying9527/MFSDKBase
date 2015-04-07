//
//  MFCell.h
//
//

#import <UIKit/UIKit.h>

@class HTMLNode;
@interface MFCell : UITableViewCell

@property (nonatomic, strong)HTMLNode *viewSoureNode;
@property (nonatomic, strong)NSDictionary *styleParams;
@property (nonatomic, strong)NSDictionary *dataBinding;
@property (nonatomic, strong)NSDictionary *dataDict;
@property (nonatomic, strong)UIView *parentView;

@property (nonatomic, strong)NSMutableDictionary *activeWidgetDict;
@property (nonatomic, strong)NSDictionary *autoLayoutSizeInfo;

@property (nonatomic, copy)NSString *pageID;
@property (nonatomic, assign)NSInteger pageHeight;
@property (nonatomic, assign)NSInteger pageWidth;
@property (nonatomic, assign)BOOL canDelete;

- (void)setupNotify;
- (void)releaseNotify;
- (void)specialHandling;
- (void)setupUI;
- (void)releaseUI;
- (void)createPage:(NSString*)pageID
          pageNode:(HTMLNode*)pageNode
       styleParams:(NSDictionary*)styleParams
       dataBinding:(NSDictionary*)dataBinding
        parentView:(UIView*)parentView;
- (id)findWidgetWithId:(NSString*)widgetId;
- (void)bindingAndLayoutPageData:(NSDictionary*)dataSource parentView:(UIView*)parentView;
@end