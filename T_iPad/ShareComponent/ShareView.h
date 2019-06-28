//
//  ShareView.h
//  XueChu
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "BaseTipView.h"
#import "ShareItem.h"
#import "ShareConfiguration.h"

typedef void(^SelectedHandler)(ShareItem *shareItem);

@interface ShareView : BaseTipView

+ (void)showShareViewWithShareConfiguration:(ShareConfiguration *)shareConfiguration
                            selectedHandler:(SelectedHandler)selectedHandler
                             dismissHandler:(void(^)(void))dismissHandler;

+ (void)hideShareView;

@end
