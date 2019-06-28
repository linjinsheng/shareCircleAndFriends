//
//  ShareManager.m
//  XueChu
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "ShareManager.h"
#import "ShareView.h"
#import "WXApi.h"

@interface ShareManager()

@property (nonatomic, strong) ShareConfiguration *shareConfiguration;

@end

@implementation ShareManager

+ (ShareManager *)shareManager
{
    static ShareManager *sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    
    return sharedManager;
}

- (void)showInViewController:(UIViewController *)viewController shareConfiguration:(ShareConfiguration *)shareConfiguration
{
    if (shareConfiguration == nil)
    {
        shareConfiguration = [ShareConfiguration defaultConfiguration];
    }
    
    self.shareConfiguration = shareConfiguration;
    
    [ShareView showShareViewWithShareConfiguration:shareConfiguration selectedHandler:^(ShareItem *shareItem) {
        
        //图片
        NSData *imageData = UIImageJPEGRepresentation(shareConfiguration.imageUrlString, 0.8);
        
        WXImageObject *imageObject = [WXImageObject object];
        imageObject.imageData = imageData;
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = imageObject;
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        req.scene = shareItem.shareType == ShareTypeWeChat ? WXSceneSession : WXSceneTimeline;
        [WXApi sendReq:req];
        
    } dismissHandler:^{
        
    }];
}

- (void)hideShareView
{
    [ShareView hideShareView];
}

@end
