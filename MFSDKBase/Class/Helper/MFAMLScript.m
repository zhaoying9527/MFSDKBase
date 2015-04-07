//
//  RuntimeClass.m

#import "MFAMLScript.h"
#import "MFHelper.h"
#import "UIView+Sizes.h"
#import "MFStrategyCenter.h"

@interface MFAMLScript()
@property (nonatomic,weak)id object;
@property (nonatomic,strong)NSDictionary *classMapDict;
@property (nonatomic,strong)NSDictionary *propertyMapDict;

- (BOOL)setProperty:(id)objC popertyName:(NSString*)popertyName withObject:(id)withObject;
- (id)getProperty:(id)objC popertyName:(NSString*)popertyName;
- (id)allocObjC:(NSString*)className;
@end

@implementation MFAMLScript
SYNTHESIZE_SINGLETON_FOR_CLASS(MFAMLScript)
- (void)removeAll
{
    self.classMapDict = nil;
    self.propertyMapDict = nil;
    self.object = nil;
}

- (instancetype)init
{
    if (self = [super init]) {
        if (nil == self.classMapDict || nil == self.propertyMapDict) {
            self.classMapDict = [[MFStrategyCenter sharedMFStrategyCenter] sourceWithID:@"MFWidgetMap"];
            self.propertyMapDict = [[MFStrategyCenter sharedMFStrategyCenter] sourceWithID:@"MFPropertyMap"];
        }
    }
    return self;
}

- (id)allocObject:(NSString*)classKey
{
    id result = nil;
    NSString *className = [self.classMapDict objectForKey:classKey];
    if (nil != className) {
        result = [self allocObjC:className];
    }
    return result;
}

- (BOOL)bindObject:(id)object
{
    BOOL ret = NO;
    if (nil != object) {
        self.object = object;
        ret = YES;
    }

    return ret;
}

- (void)batchExecution:(NSDictionary *)scriptDict
{
    for (NSString *metaProperty in [scriptDict allKeys]) {
        NSString *propertyName = [self.propertyMapDict objectForKey:metaProperty];
        NSString *propertyValue = [scriptDict objectForKey:metaProperty];
        id dataObject = [self valueFormat:propertyValue withPropertyName:metaProperty];
        if (nil == propertyName || nil == dataObject) {
            NSLog(@"warning: propertyName or dataObject is nil");
            continue;
        }
        [self setProperty:self.object popertyName:propertyName withObject:dataObject];
    }
    
    //TODO  button image backgroundImage
}

- (id)valueFormat:(NSString *)propertyValue withPropertyName:(NSString *)propertyName
{
    id retObj = nil;
    if ([propertyName isEqualToString:@"height"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"width"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"left"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"top"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"border-radius"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"border-width"]) {
        retObj = [NSNumber numberWithFloat:[propertyValue floatValue]];
    }else if ([propertyName isEqualToString:@"border-color"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"color"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"background-color"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"highlightedTextColor"]) {
        retObj = [MFHelper colorWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"text-align"]) {
        NSTextAlignment textAlignment = [MFHelper formatTextAlignmentWithString:propertyValue];
        retObj = [NSNumber numberWithInt:textAlignment];
    }else if ([propertyName isEqualToString:@"numberOfLines"]) {
        retObj = [NSNumber numberWithInt:[propertyValue intValue]];
    }else if ([propertyName isEqualToString:@"font"]) {
        retObj = [MFHelper formatFontWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"image"]) {
        retObj = [UIImage imageNamed:propertyValue];
    }else if ([propertyName isEqualToString:@"backgroundImage"]) {
        retObj = [UIImage imageNamed:propertyValue];
    }else if ([propertyName isEqualToString:@"align"]) {
        MFAlignmentType alignment = [MFHelper formatAlignmentWithString:propertyValue];
        retObj = [NSNumber numberWithInt:alignment];
    }else if ([propertyName isEqualToString:@"visibility"]) {
        retObj = [MFHelper formatVisibilityWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"layout"]) {
        MFLayoutType layoutType = [MFHelper formatLayoutWithString:propertyValue];
        retObj = [NSNumber numberWithInt:layoutType];
    }else if ([propertyName isEqualToString:@"format"]) {
        retObj = propertyValue;
    }else if ([propertyName isEqualToString:@"side"]) {
        retObj = [MFHelper formatSideWithString:propertyValue];
    }else if ([propertyName isEqualToString:@"touchEnabled"]) {
        retObj = [MFHelper formatTouchEnableWithString:propertyValue];
    }

    return retObj;
}

- (BOOL)supportHtmlTag:(NSString *)htmlTag
{
    BOOL support = NO;
    if ([self.classMapDict objectForKey:htmlTag]) {
        support = YES;
    }
    return support;
}

#pragma mark run-time
#pragma --
- (BOOL)setProperty:(id)objC popertyName:(NSString*)popertyName withObject:(id)withObject
{
    BOOL ret = NO;
    SEL sel = NSSelectorFromString(popertyName);
    if([objC respondsToSelector:sel]) {
        [objC setValue:withObject forKey:popertyName];
        ret = YES;
    }
    return ret;
}

- (id)getProperty:(id)objC popertyName:(NSString*)popertyName
{
    id retObjC = nil;
    SEL sel = NSSelectorFromString(popertyName);
    if([objC respondsToSelector:sel]) {
        retObjC = [objC valueForKey:popertyName];
    }
    return retObjC;
}

- (id)allocObjC:(NSString*)className
{
    Class  tClass =  NSClassFromString(className);
    if (tClass) {
        return [[tClass alloc] init];
    }
    return nil;
}
@end
