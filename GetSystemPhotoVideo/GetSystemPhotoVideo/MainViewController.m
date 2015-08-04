//
//  MainViewController.m
//  GetSystemPhotoVideo
//
//  Created by freedom on 15/6/2.
//  Copyright (c) 2015年 freedom_luo. All rights reserved.
//

#import "MainViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "ShowPhotosViewController.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface MainViewController (){
    NSMutableArray *_assetsGroupsList;//相册集合
}

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) ALAssetsLibrary *assetsLibray;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"照片";
    
    _assetsGroupsList=[[NSMutableArray alloc] init];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    
    if (!self.assetsLibray) {
       self.assetsLibray=[ALAssetsLibrary new];
    }
    
   [self.assetsLibray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
       
       if (group) {
           [group setAssetsFilter:[ALAssetsFilter allAssets]];
           [_assetsGroupsList addObject:group];
       }
       
       [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
       
   } failureBlock:^(NSError *error) {
       NSLog(@"error:%@",error);
   }];

}

#pragma mark UITableView数据源的委托

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _assetsGroupsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableViewCellIdentifier=@"tableViewCellIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:tableViewCellIdentifier];
    
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableViewCellIdentifier];
    }
    
    cell.imageView.image =  [UIImage imageWithCGImage:[_assetsGroupsList[indexPath.row] posterImage]];
    cell.textLabel.text = [_assetsGroupsList[indexPath.row] valueForProperty:ALAssetsGroupPropertyName];;
    cell.detailTextLabel.text = [@([_assetsGroupsList[indexPath.row] numberOfAssets]) stringValue];
    
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

#pragma mark UITableView动作的委托

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShowPhotosViewController *showPhotosVC=[ShowPhotosViewController new];
    showPhotosVC.assetsGroup=_assetsGroupsList[indexPath.row];

    [self.navigationController pushViewController:showPhotosVC animated:YES];
}

@end
