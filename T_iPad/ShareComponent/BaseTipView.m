//
//  BaseTipView.m
//  Sale_app
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "BaseTipView.h"

@implementation BaseTipView

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [self initWithFrame:CGRectZero];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.scale = 0;
        [self addSubview:self.containerView];
        
        [_containerView makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Views
- (UIView *)containerView
{
    if (!_containerView)
    {
        _containerView = [[UIView alloc] init];
    }
    
    return _containerView;
}

#pragma mark - Action

- (void)show
{
    if (![self judgeShowCondition]) {
        return;
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.containerView.transform = CGAffineTransformMakeScale(0.7 - self.scale, 0.7 - self.scale);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:8 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.containerView.transform = CGAffineTransformMakeScale(1 - self.scale, 1 - self.scale);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.transform = CGAffineTransformMakeScale(1.2 - self.scale, 1.2 - self.scale);
        self.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        self.transform = CGAffineTransformMakeScale(1 - self.scale, 1 - self.scale);
        self.alpha = 1;
        
        if (self.hiddenHander != nil)
        {
            self.hiddenHander();
        }
    }];
    self.isShowing = NO;
}

- (UINavigationController *)currentNavigationController
{
    UINavigationController *navigationController = nil;
    
    UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([controller isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabBarController = (UITabBarController *)controller;
        controller = tabBarController.viewControllers[tabBarController.selectedIndex];
        
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            navigationController = (UINavigationController *)controller;
        }
    }
    
    while (controller.presentedViewController != nil)
    {
        controller = controller.presentedViewController;
        
        if ([controller isKindOfClass:[UINavigationController class]])
        {
            navigationController = (UINavigationController *)controller;
        }
    }
    
    
    return navigationController;
}

/** 判断显示条件，如果有其他视图正在显示就不弹出 */
- (BOOL)judgeShowCondition
{
    if (_isShowing)
    {
        return NO;
    }
    
    self.isShowing = YES;
    
    UIViewController *rootController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([rootController.presentedViewController isKindOfClass:[UIAlertController class]] || [rootController.presentedViewController isKindOfClass:[NSClassFromString(@"LoginViewController") class]]) {
        return NO;
    }
    
    UINavigationController *curNavi = [self currentNavigationController];
    if ([curNavi isBeingPresented])
    {
        return NO;
    }
    
    for (UIView *subview in [UIApplication sharedApplication].keyWindow.subviews)
    {
        if ([subview isKindOfClass:[BaseTipView class]])
        {
            return NO;
        }
    }
    
    return YES;
}

@end
