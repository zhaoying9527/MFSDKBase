//
//  MFSelectBackgroundViewController.m
//
//  Created by 赵嬴 on 15/4/16.
//  Copyright (c) 2015年 赵嬴. All rights reserved.
//

#import "MFSelectBackgroundViewController.h"
#import "MFImageCollectionViewCell.h"

#define IMGWH 100
#define _minimumInteritemSpacing 5
#define _minimumLineSpacing 5
#define _spacing 5
#define _row 3

#define MFSDKBGImage(imageName) \
[UIImage imageNamed:[NSString stringWithFormat:@"%@/MFSDK.bundle/background-images/%@",[[NSBundle mainBundle] resourcePath], imageName]]
@interface MFSelectBackgroundViewController()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation MFSelectBackgroundViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    self.title = @"选择背景图";
    [self setupCollectView];
    [self loadData];
    return self;
}

- (void)loadData
{
    NSString * resPath = [[NSBundle mainBundle] resourcePath];
    NSString *plistPath = [NSString stringWithFormat:@"%@/MFSDK.bundle/background-images/%@",resPath,@"background-images.plist"];
    self.dataArray = [NSArray arrayWithContentsOfFile:plistPath];
}

- (NSInteger)itemWidth:(NSInteger)row
{
 
    int width = self.view.frame.size.width;
    if (width == 320) { //320*640
        return 100;
    }else if (width == 375) { //375x667
        return 118;
    }else if (width == 414) { //414x736
        return 131;
    }
    return 100;
}

- (NSInteger)itemHeight:(NSInteger)row
{
    int width = self.view.frame.size.width;
    if (width == 320) { //320*640
        return 100;
    }else if (width == 375) { //375x667
        return 118;
    }else if (width == 414) { //414x736
        return 131;
    }
    return 100;
}

- (void)setupCollectView
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = _minimumInteritemSpacing;//内部之间距
    flowLayout.minimumLineSpacing = _minimumLineSpacing; //行间距
    flowLayout.itemSize = CGSizeMake([self itemWidth:_row], [self itemHeight:_row]);
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[MFImageCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.collectionView];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(_spacing, _spacing, _spacing, _spacing);
    
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"cell";
    MFImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (nil == cell.imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:nil];
 
        cell.imageView = imageView;
        [cell addSubview:imageView];
    }
    cell.imageView.frame = CGRectMake(0, 0, [self itemWidth:_row], [self itemHeight:_row]);
    cell.imageView.image = MFSDKBGImage([self.dataArray[indexPath.row] objectForKey:@"Thumb"]);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHiChatBackgroundImageDidUpdate
                                                        object:MFSDKBGImage([self.dataArray[indexPath.row] objectForKey:@"URI"])
                                                                                userInfo:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
