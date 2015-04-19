//
//  MFCell.m
//

#import "MFCell.h"
#import "HTMLNode.h"
#import "MFHelper.h"
#import "MFLayoutCenter.h"
#import "MFSceneFactory.h"
#import "UIView+UUID.h"
#import "UIView+Sizes.h"

@implementation MFCell
#pragma mark UI

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userInteractionEnabled = YES;
        self.contentView.width = kDeviceWidth;
        self.contentView.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1];
    }
    return self;
}

+ (CGFloat)cellHeightWithScene:(MFScene*)scene withIndex:(NSInteger)index
{
    NSString *indexKey = [NSString stringWithFormat:@"%ld", (long)index];
    CGFloat height = [scene.headerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    height += [scene.bodyLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    height += [scene.footerLayoutDict[indexKey][KEY_WIDGET_HEIGHT] intValue];
    return height;
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

- (void)layoutWithScene:(MFScene*)scene withIndex:(NSInteger)index withAlignmentType:(MFAlignmentType)alignType
{
    [scene layout:self.contentView withIndex:index withAlignmentType:alignType];
}

- (void)bindDataWithScene:(MFScene*)scene withIndex:(NSInteger)index
{
    [scene bind:self.contentView withIndex:index];
}

@end
