//
//  MainViewController.m
//  GetSystemPhotoVideo
//
//  Created by freedom on 15/6/2.
//  Copyright (c) 2015年 freedom_luo. All rights reserved.
//

#import "MainViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *assetsGroup=[NSMutableArray new];
    
    ALAssetsLibrary *assetsLibray=[ALAssetsLibrary new];
   [assetsLibray enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
       
       if (group) {
           [assetsGroup addObject:group];
           NSLog(@"ALAssetsGroup:%@\n\n",group);
           
           if (assetsGroup.count==1) {
               [assetsGroup[0] enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                   if (result) {
                       NSLog(@"ALAsset:%@\n\n",result);
                       ALAssetRepresentation *assetProperty=[result defaultRepresentation];
                       NSLog(@"ALAssetRepresentation:%@\n\n",assetProperty);
                   }
               }];
           }
       }
       
   } failureBlock:^(NSError *error) {
       NSLog(@"error:%@",error);
   }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
