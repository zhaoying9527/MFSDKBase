//
//  MFVirtualNode.h
//  MFSDKBase
//
//  Created by 李春荣 on 15/7/30.
//  Copyright (c) 2015年 alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MFDOM;

@interface MFVirtualNode : NSObject

@property (nonatomic, weak) NSDictionary *fullData;
@property (nonatomic, weak) id data;
@property (nonatomic, weak)MFDOM *dom;
@property (nonatomic, weak)MFVirtualNode *superNode;
@property (nonatomic, strong)NSMutableArray *subNodes;
@property (nonatomic, assign)CGSize widgetSize;
@property (nonatomic, assign)CGRect frame;
@property (nonatomic, assign)NSInteger mfTag;

- (instancetype)initWithDom:(MFDOM*)dom dataSource:(NSDictionary*)dataSource;

- (NSDictionary*)sizeOfHeadWithSuperFrame:(CGRect)superFrame;
- (NSDictionary*)sizeOfBodyWithSuperFrame:(CGRect)superFrame;
- (NSDictionary*)sizeOfFootWithSuperFrame:(CGRect)superFrame;

- (id)triggerEvent:(NSString*)event withParams:(NSDictionary*)params;

@end
