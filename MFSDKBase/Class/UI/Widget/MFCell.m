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
             dataBindingParams:self.dataBinding
                        events:self.events];
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
            events:(NSDictionary*)events
        parentView:(UIView*)parentView
{
    if (![pageID isEqualToString:self.pageID]) {
        self.pageID = pageID;
        self.styleParams = styleParams;
        self.viewSoureNode = pageNode;
        self.dataBinding = dataBinding;
        self.events = events;
        self.parentView = parentView;
        [self releaseUI];
        [self setupUI];
    }
}

- (void)createWidgetWithPage:(HTMLNode *)pageNode
                  parentView:(UIView*)parentView
                 styleParams:(NSDictionary *)styleParams
           dataBindingParams:(NSDictionary *)dataBindingParams
                      events:(NSDictionary*)events
{
    if (!(pageNode && parentView && styleParams)) {
        return;
    }

    NSString *ID = [pageNode getAttributeNamed:KEYWORD_ID];
    NSDictionary *styleDict = [styleParams objectForKey:ID];
    NSDictionary *dataBindingDict = [dataBindingParams objectForKey:ID];

    UIView * rootWidget = [[MFSceneFactory sharedMFSceneFactory] createUiWithPage:pageNode style:styleDict];
    NSString *frameString = [MFHelper getFrameStringWithStyle:styleDict];
    CGRect frame = [MFHelper formatRectWithString:frameString parentFrame:parentView.frame];
    rootWidget.frame = frame;
    [[MFSceneFactory sharedMFSceneFactory] addActionForWidget:rootWidget withPage:pageNode];

    if (nil != rootWidget) {
        [parentView addSubview:rootWidget];

        [self registerWidget:rootWidget
                    widgetId:ID
                  widgetNode:pageNode
                 widgetStyle:styleDict
           widgetDataBinding:dataBindingDict
                      events:events];
    }

    for (HTMLNode *chindViewNode in [pageNode children]) {
        if (![[MFSceneFactory sharedMFSceneFactory] supportHtmlTag:chindViewNode.tagName]) {
            continue;
        }
        
        [self createWidgetWithPage:chindViewNode
                        parentView:rootWidget
                       styleParams:styleParams
                 dataBindingParams:dataBindingParams
                            events:events];
    }
}

- (void)registerWidget:(UIView*)widget
              widgetId:(NSString*)widgetId
            widgetNode:(HTMLNode*)widgetNode
           widgetStyle:(NSDictionary*)widgetStyle
     widgetDataBinding:(NSDictionary*)widgetDataBinding
                events:(NSDictionary*)events
{
    if (nil == self.activeWidgetDict) {
        self.activeWidgetDict = [[NSMutableDictionary alloc] init];
    }

    NSMutableDictionary *info = [[NSMutableDictionary alloc] init];
    [info setValue:widget forKey:KEY_WIDGET];
    [info setValue:widgetNode forKey:KEY_WIDGET_NODE];
    [info setValue:widgetStyle forKey:KEY_WIDGET_STYLE];
    [info setValue:widgetDataBinding forKey:KEY_WIDGET_DATA_BINDING];
    [info setValue:events forKey:KEY_WIDGET_EVENTS];
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
    NSString *ID = [parentView UUID];
    NSDictionary *widgetInfoDict = [self findWidgetWithId:ID];
    NSDictionary *dataBindingDict =[widgetInfoDict objectForKey:KEY_WIDGET_DATA_BINDING];
    UIView* widgetObject = [widgetInfoDict objectForKey:KEY_WIDGET];
    [MFDataBinding bindingWidget:widgetObject withDataSource:dataSource dataBinding:dataBindingDict];

    for (UIView *childView in parentView.subviews) {
        ID = [childView UUID];
        widgetInfoDict = [self findWidgetWithId:ID];
        dataBindingDict = self.dataBinding;
        UIView* widgetObject = [widgetInfoDict objectForKey:KEY_WIDGET];
        widgetObject.frame = [[self.autoLayoutSizeInfo objectForKey:ID] CGRectValue];
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
