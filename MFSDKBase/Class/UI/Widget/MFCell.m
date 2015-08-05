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
#import "UIView+MFHelper.h"
#import "UIView+Sizes.h"

@implementation MFCell
#pragma mark UI

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.exclusiveTouch = YES;
        self.contentView.width = kMFDeviceWidth;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)specialHandling
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
