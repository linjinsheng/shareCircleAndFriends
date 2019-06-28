//
//  ViewController.m
//  T_iPad
//
//  Created by targetios on 2019/5/27.
//  Copyright © 2019 targetios. All rights reserved.
//

#import "ViewController.h"
#import "ShareManager.h"
#import "SGQRCodeGenerateManager.h"

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"

@interface ViewController ()

@property (nonatomic, strong) UIImage *snapshotImage;

@end

@implementation ViewController

- (CGFloat)yOffset
{
    return 120 * [UIScreen mainScreen].bounds.size.width / 375.0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundImage"]];
    imageview.userInteractionEnabled = YES;
    [self.view addSubview:imageview];
    [imageview makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIView *erweimaBox = [[UIView alloc] init];
    erweimaBox.backgroundColor = [UIColor whiteColor];
    erweimaBox.layer.cornerRadius = 5;
    erweimaBox.layer.masksToBounds = YES;
    [imageview addSubview:erweimaBox];
    [erweimaBox makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview);
        make.centerY.equalTo(imageview).offset([self yOffset]);
        make.size.equalTo(CGSizeMake(160, 160));
    }];
    
    UIImageView *erweimaImgView = [[UIImageView alloc] init];
    erweimaImgView.image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:@"https://dsx-dev.1ziton.com/#/download" imageViewWidth:150];
    [erweimaBox addSubview:erweimaImgView];
    [erweimaImgView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(erweimaBox).offset(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    
    UILabel *tipLb = [[UILabel alloc] init];
    tipLb.text = @"——— 扫码下载 ———";
    [imageview addSubview:tipLb];
    [tipLb makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(erweimaBox);
        make.top.equalTo(erweimaBox.bottom).offset(20);
    }];
    
    //保存好当前的截图
    _snapshotImage = [self nomalSnapshotImage];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:[UIColor blackColor]];
    shareBtn.layer.cornerRadius = 20;
    shareBtn.layer.masksToBounds = YES;
    [imageview addSubview:shareBtn];
    [shareBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageview);
        make.size.equalTo(CGSizeMake(160, 40));
        make.bottom.equalTo(imageview).offset(-30);
    }];
}

- (void)shareBtnClick
{
    ShareConfiguration *config = [ShareConfiguration defaultConfiguration];
    config.imageUrlString = _snapshotImage;
    
    [[ShareManager shareManager] showInViewController:self shareConfiguration:config];
}

/**
 @return 截取的图片
 */
- (UIImage *)nomalSnapshotImage
{
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, [UIScreen mainScreen].scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

@end
