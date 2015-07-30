//
//  MFCell.m
//

#import "MFCell.h"
#import "HTMLNode.h"
#import "MFHelper.h"
#import "MFLayoutCenter.h"
#import "MFSceneFactory.h"
#import "MFScene+Internal.h"
#import "MFVirtualNode.h"
#import "UIView+UUID.h"
#import "UIView+Sizes.h"

@interface MFCell ()
@property (nonatomic, copy) NSString *tId;
@end

@implementation MFCell
#pragma mark UI

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.exclusiveTouch = YES;
        self.contentView.width = kDeviceWidth;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (CGFloat)cellHeightWithScene:(MFScene*)scene withData:(NSDictionary*)data withIndex:(NSInteger)index
{
    CGFloat totalHeight = 0.0f;
    
    NSDictionary *virtualNodes = scene.virtualNodes[index];
    MFVirtualNode *headVirtualNode = virtualNodes[kMFVirtualHeadNode];
    MFVirtualNode *bodyVirtualNode = virtualNodes[kMFVirtualBodyNode];
    MFVirtualNode *footVirtualNode = virtualNodes[kMFVirtualFootNode];

    CGFloat height = headVirtualNode.widgetSize.height;
    totalHeight += height > 0 ? height+[MFHelper cellHeaderHeight] : 0;
    height = bodyVirtualNode.widgetSize.height;
    totalHeight += height + [MFHelper sectionHeight];
    height = footVirtualNode.widgetSize.height;
    totalHeight += height > 0 ? height+[MFHelper cellFooterHeight] : 0;
    return totalHeight;
}

- (void)setupUIWithScene:(MFScene*)scene withTemplateId:(NSString*)tId withIndex:(NSInteger)index
{
    if (![self.tId isEqualToString:tId]) {
        self.tId = tId;
        if (index >scene.virtualNodes.count) {
            return;
        }
        UIView *sceneHeadCanvas = [scene sceneViewWithVirtualNode:scene.virtualNodes[index][kMFVirtualHeadNode]
                                                         withType:MFNodeTypeHead];
        UIView *sceneBodyCanvas = [scene sceneViewWithVirtualNode:scene.virtualNodes[index][kMFVirtualBodyNode]
                                                         withType:MFNodeTypeBody];
        UIView *sceneFootCanvas = [scene sceneViewWithVirtualNode:scene.virtualNodes[index][kMFVirtualFootNode]
                                                         withType:MFNodeTypeFoot];
        if (nil != sceneHeadCanvas) {
            [self.contentView addSubview:sceneHeadCanvas];
        }
        if (nil != sceneBodyCanvas) {
            [self.contentView addSubview:sceneBodyCanvas];
        }
        if (nil != sceneFootCanvas) {
            [self.contentView addSubview:sceneFootCanvas];
        }
    }
}

- (void)layoutWithScene:(MFScene*)scene withData:(NSDictionary*)data withIndex:(NSInteger)index
{
    [scene layout:self.contentView withData:data];
}

- (void)bindDataWithScene:(MFScene*)scene withData:(NSDictionary*)data withIndex:(NSInteger)index
{
    [scene bind:self.contentView withData:data];
}

- (void)specialHandlingWithData:(NSDictionary*)data
{
}

#pragma mark - events
- (void)didClickCTCell:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickCTCell:)]) {
        [self.delegate didClickCTCell:self];
    }
}

@end
