//
//  MFCell.m
//

#import "MFCell.h"
#import "HTMLNode.h"
#import "MFHelper.h"
#import "MFLayoutCenter.h"
#import "MFSceneFactory.h"
#import "MFScene+Internal.h"
#import "UIView+UUID.h"
#import "UIView+Sizes.h"

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

+ (CGFloat)cellHeightWithScene:(MFScene*)scene withData:(NSDictionary*)data
{
    CGFloat totalHeight = 0.0f;
    NSString *indexKey = [scene privateKeyWithData:data];
    CGFloat height = [scene.headerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    totalHeight += height > 0 ? height+[MFHelper cellHeaderHeight] : 0;
    height = [scene.bodyLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    totalHeight += height + [MFHelper sectionHeight];
    height = [scene.footerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    totalHeight += height > 0 ? height+[MFHelper cellFooterHeight] : 0;
    return totalHeight;
}

- (void)setupUIWithScene:(MFScene*)scene withTemplateId:(NSString*)tId
{
    UIView *sceneHeadCanvas = [scene sceneViewWithDomId:tId withType:MFDomTypeHead];
    UIView *sceneBodyCanvas = [scene sceneViewWithDomId:tId withType:MFDomTypeBody];
    UIView *sceneFootCanvas = [scene sceneViewWithDomId:tId withType:MFDomTypeFoot];
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

- (void)layoutWithScene:(MFScene*)scene withData:(NSDictionary*)data
{
    [scene layout:self.contentView withData:data];
}

- (void)bindDataWithScene:(MFScene*)scene withData:(NSDictionary*)data
{
    [scene bind:self.contentView withData:data];
}

- (void)specialHandlingWithData:(NSDictionary*)data{;}

#pragma mark - events
- (void)didClickCTCell:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didClickCTCell:)]) {
        [self.delegate didClickCTCell:self];
    }
}

@end
