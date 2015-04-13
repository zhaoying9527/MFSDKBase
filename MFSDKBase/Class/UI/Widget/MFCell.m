//
//  MFCell.m
//

#import "MFCell.h"
#import "HTMLNode.h"
#import "MFHelper.h"
#import "MFLayoutCenter.h"
#import "MFSceneFactory.h"
#import "UIView+UUID.h"

@implementation MFCell
#pragma mark UI

- (void)setupNotify {;}
- (void)releaseNotify {;}

- (void)setupUI
{
}

- (void)releaseUI
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}
@end
