//
//  MFCell.m
//

#import "MFCell.h"
#import "HTMLNode.h"
#import "MFHelper.h"
#import "MFLayoutCenter.h"
#import "MFSceneFactory.h"
#import "MFDataBinding.h"
#import "UIView+UUID.h"

@implementation MFCell
#pragma mark UI

- (void)setupNotify {;}
- (void)releaseNotify {;}

- (void)setupUI
{
    [self createWidgetWithPage:self.viewSoureNode
                    parentView:self.parentView
                   styleParams:self.styleParams
             dataBindingParams:self.dataBinding];
}

- (void)releaseUI
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}

- (void)createPage:(NSString*)pageID
          pageNode:(HTMLNode*)pageNode
       styleParams:(NSDictionary*)styleParams
       dataBinding:(NSDictionary*)dataBinding
        parentView:(UIView*)parentView
{
    if (![pageID isEqualToString:self.pageID]) {
        self.pageID = pageID;
        self.styleParams = styleParams;
        self.viewSoureNode = pageNode;
        self.dataBinding = dataBinding;
        self.parentView = parentView;
        [self releaseUI];
        [self setupUI];
    }
}

- (void)createWidgetWithPage:(HTMLNode *)pageNode
                  parentView:(UIView*)parentView
                 styleParams:(NSDictionary *)styleParams
           dataBindingParams:(NSDictionary *)dataBindingParams
{
    if (!(pageNode && parentView && styleParams && dataBindingParams)) {
        return;
    }

    NSString *uuid = [pageNode getAttributeNamed:@"id"];
    NSDictionary *styleDict = [styleParams objectForKey:uuid];
    NSDictionary *dataBindingDict = [dataBindingParams objectForKey:uuid];

    UIView * rootWidget = [[MFSceneFactory sharedMFSceneFactory] createUiWithPage:pageNode style:styleDict];
    NSString *frameString = [MFHelper getFrameStringWithStyle:styleDict];
    CGRect frame = [MFHelper formatRectWithString:frameString parentFrame:parentView.frame];
    rootWidget.frame = frame;
    [[MFSceneFactory sharedMFSceneFactory] addActionForWidget:rootWidget withPage:pageNode];

    if (nil != rootWidget) {
        [parentView addSubview:rootWidget];

        [self registerWidget:rootWidget
                    widgetId:uuid
                  widgetNode:pageNode
                 widgetStyle:styleDict
           widgetDataBinding:dataBindingDict];
    }

    
    for (HTMLNode *chindViewNode in [pageNode children]) {
        if (![[MFSceneFactory sharedMFSceneFactory] supportHtmlTag:chindViewNode.tagName]) {
            continue;
        }
        
        [self createWidgetWithPage:chindViewNode
                        parentView:rootWidget
                       styleParams:styleParams
                 dataBindingParams:dataBindingParams];
    }
}

- (void)registerWidget:(UIView*)widget
              widgetId:(NSString*)widgetId
            widgetNode:(HTMLNode*)widgetNode
           widgetStyle:(NSDictionary*)widgetStyle
     widgetDataBinding:(NSDictionary*)widgetDataBinding
{
    if (nil == self.activeWidgetDict) {
        self.activeWidgetDict = [[NSMutableDictionary alloc] init];
    }

    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:widget forKey:KEY_WIDGET];
    [info setValue:widgetNode forKey:KEY_WIDGET_NODE];
    [info setValue:widgetStyle forKey:KEY_WIDGET_STYLE];
    [info setValue:widgetDataBinding forKey:KEY_WIDGET_DATA_BINDING];
    [self.activeWidgetDict setObject:info forKey:widgetId];
}

- (void)removeWidgetWithId:(NSString*)widgetId
{
    [self.activeWidgetDict removeObjectForKey:widgetId];
}

- (id)findWidgetWithId:(NSString*)widgetId
{
    return [self.activeWidgetDict objectForKey:widgetId];
}

#pragma mark Binding
- (void)bindingAndLayoutPageData:(NSDictionary*)dataSource parentView:(UIView*)parentView
{
    if (!(parentView && dataSource)) {
        return;
    }

    self.dataDict = dataSource;
    NSString *uuid = [parentView UUID];
    NSDictionary *widgetInfoDict = [self findWidgetWithId:uuid];
    NSDictionary *dataBindingDict =[widgetInfoDict objectForKey:KEY_WIDGET_DATA_BINDING];
    UIView* widgetObject = [widgetInfoDict objectForKey:KEY_WIDGET];
    [MFDataBinding bindingWidget:widgetObject withDataSource:dataSource dataBinding:dataBindingDict];

    for (UIView *childView in parentView.subviews) {
        uuid = [childView UUID];
        widgetInfoDict = [self findWidgetWithId:uuid];
        dataBindingDict = self.dataBinding;
        UIView* widgetObject = [widgetInfoDict objectForKey:KEY_WIDGET];
        widgetObject.frame = [[self.autoLayoutSizeInfo objectForKey:uuid] CGRectValue];
        [self bindingAndLayoutPageData:dataSource parentView:childView];
    }
}

#pragma mark Layout
-(void)layoutPage
{
    [self specialHandling];
}
- (void)specialHandling
{
}
@end
