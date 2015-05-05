//
//  PKEmojiLabel.m
//
//  Created by chicp on 15-3-27.
//  Copyright (c) 2015年 长炮 池. All rights reserved.
//


#import "MFEmojiLabel.h"
//TODO
//#import "APDisplayDataManager.h"

static MFEmojiLabel *tempLabel = nil;
static NSMutableArray *emijiCache = nil;

#define maxCacheNumber  100

typedef enum {
    CTLinkTypeA = 1,
    CTLinkTypeAEnd,
    CTLinkTypeFont,
    CTLinkTypeFontEnd
}CTLinkType;

// emoji - 表情
@interface Emoji:NSObject

@property (nonatomic, strong) NSString *content;

@end

@implementation Emoji

@end

// 标签 - 表情
@interface FlagElement:NSObject

@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) CTLinkType type;
@property (nonatomic, assign) NSInteger begin;
@property (nonatomic, assign) NSInteger end;

@end

@implementation FlagElement

@end

// Link - 链接
@interface Link:NSObject

@property (nonatomic, strong) NSArray *contents;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) BOOL showLine;
@end

@implementation Link

@end

@implementation MFEmojiLabel

//mian 过滤器 渲染前过滤
- (void)setCTText:(NSString *)text emojiMap:(NSDictionary *)emojiMap{
    [self setText:nil];
    NSArray *list = [MFEmojiLabel getCacheForText:text];
    if(list == nil){
        NSMutableArray *finalList = [NSMutableArray arrayWithCapacity:5];
        NSArray *acDetectLink = [self detectLink:text];
        [acDetectLink enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([obj isKindOfClass:[NSString class]]){
               [finalList addObjectsFromArray:[self detectEmoji:obj]];
            }else{
                [finalList addObject:obj];
            }
        }];
        list = finalList;
        if(list.count > 5){
            [MFEmojiLabel addCacheWithList:list text:text];
        }
    }
//TODO
//    [self drawCtText:list emojiMap:[APDisplayDataManager sharedAPDisplayDataManager].emojiMap];
}

+ (NSArray *)getCacheForText:(NSString *)text{
    if(text == nil){
        return nil;
    }
    if(emijiCache == nil){
        emijiCache = [NSMutableArray arrayWithCapacity:5];
    }
    //@{text:}
    __block NSArray *items = nil;
    [emijiCache enumerateObjectsUsingBlock:^(NSDictionary *emoji, NSUInteger idx, BOOL *stop) {
        items = emoji[text];
        if(items){
            *stop = YES;
        }
    }];
    return items;
}

+ (void)addCacheWithList:(NSArray *)items text:(NSString *)text{
    if(text == nil || items.count == 1){
        return;
    }
    if(emijiCache == nil){
        emijiCache = [NSMutableArray arrayWithCapacity:5];
    }
    if(emijiCache.count >= maxCacheNumber){
        [emijiCache removeObjectAtIndex:0];
    }
    [emijiCache addObject:@{text:items}];
}

//<a href=“http://www.alipay.com"><font color="red">测试文字</font></a>

- (NSArray *)detectLink:(NSString *)text{
    if(text.length == 0){
        return nil;
    }
    
    NSMutableArray *elementList = [NSMutableArray arrayWithCapacity:5];
    
    int begin = -1;
    for (int i = 0; i < text.length; i++) {
        if([text characterAtIndex:i] == '<'){
            begin = i;
        }else if([text characterAtIndex:i] == '>' && begin >= 0 && i > begin){
            NSRange range;
            range.location = begin;
            range.length = i - begin + 1;
            NSString *element = [text substringWithRange:range];
            if([element rangeOfString:@"<a"].length > 0){
                FlagElement *flagElement = [[FlagElement alloc] init];
                flagElement.content = element;
                flagElement.type = CTLinkTypeA;
                flagElement.begin = begin;
                flagElement.end = i;
                [elementList addObject:flagElement];
            }
            
            if([element rangeOfString:@"</a>"].length > 0){
                FlagElement *flagElement = [[FlagElement alloc] init];
                flagElement.content = element;
                flagElement.type = CTLinkTypeAEnd;
                flagElement.begin = begin;
                flagElement.end = i;
                [elementList addObject:flagElement];
            }
            
            if([element rangeOfString:@"<font"].length > 0){
                FlagElement *flagElement = [[FlagElement alloc] init];
                flagElement.content = element;
                flagElement.type = CTLinkTypeFont;
                flagElement.begin = begin;
                flagElement.end = i;
                [elementList addObject:flagElement];
            }
            
            if([element rangeOfString:@"</font>"].length > 0){
                FlagElement *flagElement = [[FlagElement alloc] init];
                flagElement.content = element;
                flagElement.type = CTLinkTypeFontEnd;
                flagElement.begin = begin;
                flagElement.end = i;
                [elementList addObject:flagElement];
            }
            begin = -1;
        }
    }
    return [self dealElements:elementList oldText:text];
}

// 后续优化...
- (NSArray *)dealElements:(NSArray *)elementList oldText:(NSString *)text{
    NSMutableArray *finalList = [NSMutableArray arrayWithCapacity:5];
    if(elementList.count > 0 && elementList.count % 2 == 0){
        NSInteger begin = 0;
        for (int i = 0; i < elementList.count; i++) {
            FlagElement *elementItem = elementList[i];
            if(elementItem.type == CTLinkTypeA){
                //find link end
                int find = -1;
                for (int j = i+1 ; j < elementList.count; j++) {
                    FlagElement *lastEmentItem = elementList[j];
                    if(lastEmentItem.type == CTLinkTypeAEnd){
                        find = j;
                        break;
                    }
                }
                if(find != -1){
                    FlagElement *endEmentItem = elementList[find];
                    if(find - i == 1){
                        NSRange range;
                        range.location = begin;
                        range.length = elementItem.begin - begin;
                        [self appendRange:range forText:text inList:finalList];
                        begin = elementItem.end + 1;
                        
                        range.location = begin;
                        range.length = endEmentItem.begin - begin;
                        if(range.length > 0){
                            NSString *midStr = [text substringWithRange:range];
                            NSArray *contents = [self detectEmoji:midStr];
                            Link *link = [[Link alloc] init];
                            link.contents = contents;
                            link.url = [self getUrl:elementItem.content];
                            link.color = nil;
                            link.font = nil;
                            link.showLine = NO;
                            [finalList addObject:link];
                        }
                    }else if(find - i == 3){//可能包含<font>
                        FlagElement *fontBeginEmentItem = elementList[find - 2];
                        FlagElement *fontEndEmentItem = elementList[find - 1];
                        if(fontBeginEmentItem.type == CTLinkTypeFont && fontEndEmentItem.type == CTLinkTypeFontEnd){
                            NSRange range;
                            range.location = begin;
                            range.length = elementItem.begin - begin;
                            [self appendRange:range forText:text inList:finalList];
                            begin = fontBeginEmentItem.end + 1;
                            
                            range.location = begin;
                            range.length = fontEndEmentItem.begin - begin;
                            if(range.length > 0){
                                NSString *midStr = [text substringWithRange:range];
                                NSArray *contents = [self detectEmoji:midStr];
                                Link *link = [[Link alloc] init];
                                link.contents = contents;
                                link.url = [self getUrl:elementItem.content];
                                link.color = [self getColor:fontBeginEmentItem.content];
                                link.font = nil;
                                link.showLine = NO;
                                [finalList addObject:link];
                            }
                        }
                    }else{//格式不识别
                        NSRange range;
                        range.location = begin;
                        range.length = endEmentItem.end - begin;
                        [self appendRange:range forText:text inList:finalList];
                        begin = endEmentItem.end + 1;
                    }
                    begin = endEmentItem.end + 1;
                    i = find;
                }
            }else if(elementItem.type == CTLinkTypeFont){
                int find = -1;
                for (int j = i+1 ; j < elementList.count; j++) {
                    FlagElement *lastEmentItem = elementList[j];
                    if(lastEmentItem.type == CTLinkTypeFontEnd){
                        find = j;
                        break;
                    }
                }
                if(find != -1){
                    FlagElement *endEmentItem = elementList[find];
                    if(find - i == 1){
                        if(elementItem.type == CTLinkTypeFont && endEmentItem.type == CTLinkTypeFontEnd){
                            NSRange range;
                            range.location = begin;
                            range.length = elementItem.begin - begin;
                            [self appendRange:range forText:text inList:finalList];
                            begin = elementItem.end + 1;
                            
                            range.location = begin;
                            range.length = endEmentItem.begin - begin;
                            if(range.length > 0 && range.location + range.length > 0){
                                NSString *midStr = [text substringWithRange:range];
                                NSArray *contents = [self detectEmoji:midStr];
                                Link *link = [[Link alloc] init];
                                link.contents = contents;
                                link.url = [self getUrl:elementItem.content];
                                link.color = [self getColor:elementItem.content];
                                link.font = nil;
                                link.showLine = NO;
                                [finalList addObject:link];
                            }
                        }else{
                            NSRange range;
                            range.location = begin;
                            range.length = endEmentItem.end - begin;
                            [self appendRange:range forText:text inList:finalList];
                        }
                    }else{
                        NSRange range;
                        range.location = begin;
                        range.length = endEmentItem.end - begin;
                        [self appendRange:range forText:text inList:finalList];
                    }
                    begin = endEmentItem.end + 1;
                    i = find;
                }
            }else{
                NSRange range;
                range.location = begin;
                range.length = elementItem.end - begin;
                [self appendRange:range forText:text inList:finalList];
                begin = elementItem.end + 1;
            }
            
            if(i >= elementList.count - 1){
                NSRange range;
                range.location = begin;
                range.length = text.length - begin;
                [self appendRange:range forText:text inList:finalList];
                begin = text.length + 1;
                break;
            }
        }
    }else{
        [finalList addObjectsFromArray:[self detectEmoji:text]];
    }
    return finalList;
}

- (void)appendRange:(NSRange)range forText:(NSString *)text inList:(NSMutableArray *)finalList{
    if(range.length > 0 && range.location + range.length <= text.length){
        NSString *preStr = [text substringWithRange:range];
        [finalList addObjectsFromArray:[self detectEmoji:preStr]];
    }
}

/** link识别校验
 *  1. <a href=“http://www.alipay.com"><font  color="red">测试[大笑]文字</font></a>
 *  2. <a href=“http://www.alipay.com">测试文字</a>
 *  3. <font color="red">测试文字</font>
 **/
- (NSString *)getUrl:(NSString *)htmlElement{
    NSArray *items = [htmlElement componentsSeparatedByString:@"href=\""];
    if(items.count == 2){
       NSArray *newItems = [items.lastObject componentsSeparatedByString:@"\""];
        if(newItems.count == 2){
            return newItems.firstObject;
        }else{
            return nil;
        }
    }
    return nil;
}

- (UIColor *)getColor:(NSString *)htmlElement{
    NSArray *items = [htmlElement componentsSeparatedByString:@"color=\""];
    if(items.count == 2){
        NSArray *newItems = [items.lastObject componentsSeparatedByString:@"\""];
        if(newItems.count == 2){
            NSString *colorStr = newItems.firstObject;
            if([colorStr rangeOfString:@"#"].length > 0 && colorStr.length == 7){
                return [MFEmojiLabel colorWithHexString:colorStr];
            }else{
                if([colorStr isEqualToString:@"black"]){
                    return [UIColor blackColor];
                }else if ([colorStr isEqualToString:@"darkGray"]){
                    return [UIColor darkGrayColor];
                }else if ([colorStr isEqualToString:@"lightGray"]){
                    return [UIColor lightGrayColor];
                }else if ([colorStr isEqualToString:@"white"]){
                    return [UIColor whiteColor];
                }else if ([colorStr isEqualToString:@"gray"]){
                    return [UIColor grayColor];
                }else if ([colorStr isEqualToString:@"red"]){
                    return [UIColor redColor];
                }else if ([colorStr isEqualToString:@"green"]){
                    return [UIColor greenColor];
                }else if ([colorStr isEqualToString:@"blue"]){
                    return [UIColor blueColor];
                }else if ([colorStr isEqualToString:@"cyan"]){
                    return [UIColor cyanColor];
                }else if ([colorStr isEqualToString:@"yellow"]){
                    return [UIColor yellowColor];
                }else if ([colorStr isEqualToString:@"magenta"]){
                    return [UIColor magentaColor];
                }else if ([colorStr isEqualToString:@"orange"]){
                    return [UIColor orangeColor];
                }else if ([colorStr isEqualToString:@"purple"]){
                    return [UIColor purpleColor];
                }else if ([colorStr isEqualToString:@"brown"]){
                    return [UIColor brownColor];
                }else if ([colorStr isEqualToString:@"clear"]){
                    return [UIColor clearColor];
                }else{
                    return nil;
                }
            }
        }else{
            return nil;
        }
    }
    return nil;
}

//表情塞选
- (NSArray *)detectEmoji:(NSString *)text{
    if(text.length == 0){
        return nil;
    }
    NSArray *items = [text componentsSeparatedByString:@"["];
    NSMutableArray* finalList = [NSMutableArray arrayWithCapacity:5];
    [items enumerateObjectsUsingBlock:^(NSString* str, NSUInteger idx1, BOOL *stop) {
        if(idx1 == 0){
            [finalList addObject:str];
        }else{
            NSArray *emojiItems = [str componentsSeparatedByString:@"]"];
            if(emojiItems.count > 1){
                [emojiItems enumerateObjectsUsingBlock:^(NSString *content, NSUInteger idx2, BOOL *stop) {
                    if(idx2 == 0){
                        Emoji *emoji = [[Emoji alloc] init];
                        emoji.content = content;
                        [finalList addObject:emoji];
                    }else if(idx2 < emojiItems.count - 1){
                        [finalList addObject:[NSString stringWithFormat:@"%@]",content]];
                    }else{
                        [finalList addObject:content];
                    }
                }];
            }else if(idx1 < items.count - 1){
                [finalList addObject:[NSString stringWithFormat:@"[%@",str]];
            }else{
                [finalList addObject:str];
            }
        }
    }];
    return finalList;
}

//绘制界面
- (void)drawCtText:(NSArray *)ctArray emojiMap:(NSDictionary *)emojiMap{
    [ctArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:[Emoji class]]){
            Emoji *emoji = (Emoji *)obj;
            NSString *imageName = emojiMap[emoji.content];
            UIImage *image = nil;
            if(imageName.length > 0){
                image = [UIImage imageNamed:imageName];
            }
            if(image){
                NSInteger size = self.font.pointSize + 1;
                [self appendImage:image
                          maxSize:CGSizeMake(size, size)
                           margin:UIEdgeInsetsMake(0, 1, 0, 1)
                        alignment:CTImageAlignmentCenter];
            }else{
                [self appendText:[NSString stringWithFormat:@"[%@]",emoji.content]];
            }
        }else if([obj isKindOfClass:[NSString class]]){
            [self appendText:obj];
        }else if ([obj isKindOfClass:[Link class]]){
            NSRange range;
            range.location = self.attributedString.length;
            Link *link = (Link *)obj;
            //递归 临界点把握好
            [self drawCtText:link.contents emojiMap:emojiMap];
            range.length = self.attributedString.length - range.location;
            [self addCustomLink:link.url forRange:range linkColor:link.color underLine:link.showLine];
        }
    }];
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor clearColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor clearColor];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (CGSize)sizeOfText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)size{
    if(tempLabel == nil){
        tempLabel = [[MFEmojiLabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    }
    tempLabel.font = font;
    [tempLabel setCTText:text emojiMap:nil];
    
    CGSize outSize = [tempLabel sizeThatFits:CGSizeMake(size.width, 0)];
    outSize.height -= 2;
    return outSize;
}

- (void)setAlignmentType:(NSInteger)type
{
    _alignmentType = type;
    if (self.side) {
        if (_alignmentType == MFAlignmentTypeLeft) {
            self.textAlignment = NSTextAlignmentLeft;
        }else if (_alignmentType == MFAlignmentTypeCenter) {
            self.textAlignment = NSTextAlignmentCenter;
        }else if (_alignmentType == MFAlignmentTypeRight) {
            self.textAlignment = NSTextAlignmentRight;
        }
    }
}
@end
