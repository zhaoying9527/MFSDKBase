//
//  MFImagePickerController.m
//  MFSDK
//
//  Created by 赵嬴 on 15/4/16.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "MFImagePickerController.h"
#import "MFSelectBackgroundViewController.h"
#import "UIImage+Scale.h"
@interface MFImagePickerController()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong)UITableView *tableview;
@property (nonatomic,strong)NSArray *dataArray;
@end

@implementation MFImagePickerController
- (id)initWithParams:(NSDictionary*)params
{
    self = [super initWithNibName:nil bundle:nil];
    
    self.title = @"聊天背景";
    
    [self setupUI];
    
    NSDictionary *dict1 = [NSDictionary dictionaryWithObjectsAndKeys:@"选择背景图片",@"title",@"builtInBackgroundSelection",@"url",nil];
    NSDictionary *dict2 = [NSDictionary dictionaryWithObjectsAndKeys:@"从手机相册选择",@"title",@"selectThePhotoLibImage",@"url",nil];
    NSDictionary *dict3 = [NSDictionary dictionaryWithObjectsAndKeys:@"拍一张",@"title",@"selectTheCameraImage",@"url",nil];
    
    NSArray *ga1 = [NSArray arrayWithObjects:dict1,nil];
    NSArray *ga2 = [NSArray arrayWithObjects:dict2,dict3,nil];
    
    self.dataArray = [NSArray arrayWithObjects:ga1,ga2,nil];
    
    return self;
}

- (UIImage*)fitBGImage:(UIImage*)originalImage
{
    UIImage * retImage = originalImage;
    CGSize originalImageSize = originalImage.size;
    CGSize  screenSize = [UIScreen mainScreen].applicationFrame.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize fitImageSize = CGSizeMake(screenSize.width*scale, screenSize.height*scale);
    
    if (originalImageSize.width > fitImageSize.width || originalImageSize.height > fitImageSize.height) {
        
        int height = fitImageSize.height;
        int width = originalImageSize.width * fitImageSize.height / originalImageSize.height;
        
        UIImage *scaleImage = [originalImage scaleToSize:CGSizeMake(width, height)];
        CGSize scaleImageSize = scaleImage.size;
        retImage = [scaleImage subImage:CGRectMake((scaleImageSize.width-fitImageSize.width)/2,
                                                 (scaleImageSize.height-fitImageSize.height)/2,
                                                 fitImageSize.width, fitImageSize.height)];
    }
    
    return retImage;
}

- (void)openURL:(NSString*)url
{
    [self performSelector:NSSelectorFromString(url)];
}

- (void)setupUI
{
    self.tableview = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.view addSubview:self.tableview];
}
#pragma mark
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *data = [self.dataArray objectAtIndex:section];
    return data.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"identifier";
    UITableViewCell *cell = [self.tableview dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }

    NSString *text = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.textLabel.text = text;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *url = [[[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"url"];
    [self openURL:url];
}

#pragma mark
#pragma mark Select BackgroundImage func
- (void)builtInBackgroundSelection
{
    MFSelectBackgroundViewController *glvc = [[MFSelectBackgroundViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:glvc animated:YES ];
}

- (void)selectTheCameraImage
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = NO;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}

- (void)selectThePhotoLibImage
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;   // 设置委托
    imagePickerController.sourceType = sourceType;
    imagePickerController.allowsEditing = NO;
    [self presentViewController:imagePickerController animated:YES completion:nil];  //需要以模态的形式展示
}

#pragma mark
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    NSLog(@"get the media info: %@", info);
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];

//TODO
//    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
//        UIImage* originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//        if (nil != originalImage) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHiChatBackgroundImageDidUpdate
//                                                                object:[self fitBGImage:originalImage] userInfo:nil];
//        }
//    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end

