//
//  BaseTipView.h
//  Sale_app
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import <UIKit/UIKit.h>
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

#import "Masonry.h"

@interface BaseTipView : UIView

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic) BOOL isShowing;
@property (nonatomic) CGFloat scale;
@property (nonatomic, copy) void (^hiddenHander)(void);

- (void)show;
- (void)hide;
- (UINavigationController *)currentNavigationController;

@end
