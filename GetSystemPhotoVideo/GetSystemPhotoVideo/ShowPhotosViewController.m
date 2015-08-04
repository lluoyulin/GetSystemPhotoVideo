//
//  ShowPhotosViewController.m
//  GetSystemPhotoVideo
//
//  Created by freedom on 15/6/4.
//  Copyright (c) 2015年 freedom_luo. All rights reserved.
//

#import "ShowPhotosViewController.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

@interface ShowPhotosViewController (){
    NSMutableArray *_assetsList;//照片结合
}

@property(nonatomic,strong) UIView *photosView;
@property(nonatomic,strong) UIImageView *topImage;
@property(nonatomic,strong) UIImageView *bottomImage;

@end

@implementation ShowPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"照片集";
    
    _assetsList=[[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
        [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if (result) {
                [_assetsList addObject:result];
                NSLog(@"ALAsset:%@\n\n",result);
                ALAssetRepresentation *assetProperty=[result defaultRepresentation];
                NSLog(@"ALAssetRepresentation:%@\n\n",assetProperty);
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self initPhotosView];
        });
    });
}

-(void)initPhotosView{
    self.photosView=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-20-44)];
    self.photosView.backgroundColor=[UIColor yellowColor];
    [self.view addSubview:self.photosView];
    
        CGFloat x=10.0;
        CGFloat y=120.0;
        for (int i=0; i<(_assetsList.count>10 ? 10 :_assetsList.count); i++) {
            UIButton *image=[UIButton buttonWithType:UIButtonTypeCustom];
            image.frame=CGRectMake(x, y, SCREEN_WIDTH-2*x, 150);
            [image setAdjustsImageWhenHighlighted:NO];
            [image setImage:[UIImage imageWithCGImage:[_assetsList[i] aspectRatioThumbnail]] forState:UIControlStateNormal];
            [image addTarget:self action:@selector(tapGestureTouched:) forControlEvents:UIControlEventTouchUpInside];
            [self.photosView insertSubview:image atIndex:0];
    
            x+=10;
            y-=8;
        }
//图片折叠
//    self.topImage=[[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 300, 100)];
//    self.topImage.image=[UIImage imageWithCGImage:[_assetsList[0] aspectRatioThumbnail]];
//    self.topImage.layer.contentsRect=CGRectMake(0, 0, 1, 0.5);
//    self.topImage.layer.anchorPoint=CGPointMake(0.5, 1);
//    [self.photosView addSubview:self.topImage];
//    
//    self.bottomImage=[[UIImageView alloc] initWithFrame:CGRectMake(50,100, 300, 100)];
//    self.bottomImage.image=[UIImage imageWithCGImage:[_assetsList[0] aspectRatioThumbnail]];
//    self.bottomImage.layer.contentsRect=CGRectMake(0, 0.5, 1, 0.5);
//    self.bottomImage.layer.anchorPoint=CGPointMake(0.5, 0);
//    [self.photosView addSubview:self.bottomImage];
//    
//    UIView *panView=[[UIView alloc] initWithFrame:CGRectMake(self.topImage.frame.origin.x, self.topImage.frame.origin.y, self.topImage.frame.size.width, self.topImage.frame.size.height+self.bottomImage.frame.size.height)];
//    [self.photosView addSubview:panView];
//    
//    UIPanGestureRecognizer *tap=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
//    [panView addGestureRecognizer:tap];
}

-(void)tapGestureRecognizer:(UIPanGestureRecognizer *)sender{
    // 获取手指偏移量
    CGPoint offset=[sender translationInView:sender.view.superview];
    
    // 初始化形变
    CATransform3D transform3D=CATransform3DIdentity;
    // 设置立体效果
    transform3D.m34=-1/1000.0;
    // 计算折叠角度，因为需要逆时针旋转，所以取反
    CGFloat angle = -offset.y / 200.0 * M_PI;
    
    switch (sender.state) {
        case UIGestureRecognizerStateChanged:
            self.topImage.layer.transform=CATransform3DRotate(transform3D, angle, 1, 0, 0);
            break;
        case UIGestureRecognizerStateEnded:
            // 还原
            [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.topImage.layer.transform = CATransform3DIdentity;
            } completion:nil];
            break;
    }
}

-(void)tapGestureTouched:(UIButton *)tap{
    
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        tap.transform=CGAffineTransformMakeRotation((M_PI / 180.0f)*180.0);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSLog(@"aaaa");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
