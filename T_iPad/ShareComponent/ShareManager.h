//
//  ShareManager.h
//  XueChu
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ShareConfiguration.h"

@interface ShareManager : NSObject

@property (nonatomic, copy) void (^shareCompletion)(void);

+ (ShareManager *)shareManager;

- (void)showInViewController:(UIViewController *)viewController
          shareConfiguration:(ShareConfiguration *)shareConfiguration;

- (void)hideShareView;

@end
