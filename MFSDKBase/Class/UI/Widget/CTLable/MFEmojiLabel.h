//
//  PKEmojiLabel.h
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//

#import "CTLabel.h"

typedef enum {
    MFEmojiLabelDetectNone     = 0,
    MFEmojiLabelDetectEmoji    = 1 << 0,
    MFEmojiLabelDetectLink     = 1 << 1
}MFEmojiLabelDetectType;

@interface MFEmojiLabel : CTLabel

@property (nonatomic, assign)BOOL side;
@property (nonatomic, assign)NSInteger alignmentType;

/**
 * emojiMap ctEmoji.plist 内容后续迁移
 **/

- (void)setCTText:(NSString *)text emojiMap:(NSDictionary *)emojiMap;

+ (CGSize)sizeOfText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)size;

@end
