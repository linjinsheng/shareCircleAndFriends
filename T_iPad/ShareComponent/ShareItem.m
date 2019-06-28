//
//  ShareItem.m
//  XueChu
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "ShareItem.h"

@implementation ShareItem

- (instancetype)initWithShareType:(ShareType)shareType
{
    if (self = [super init])
    {
        self.shareType = shareType;

        switch (shareType)
        {
            case ShareTypeWeibo:
                self.title = @"新浪微博";
                self.iconName = @"53";
                self.iconNameHighLight = @"53";
                break;
            case ShareTypeWeChat:
                self.title = @"微信好友";
                self.iconName = @"wechat";
                self.iconNameHighLight = @"wechat";
                break;
            case ShareTypeWeChatTimeline:
                self.title = @"朋友圈";
                self.iconName = @"moments";
                self.iconNameHighLight = @"moments";
                break;
            case ShareTypeQQ:
                self.title = @"QQ";
                self.iconName = @"55";
                self.iconNameHighLight = @"55";

                break;
            case ShareTypeQzone:
                self.title = @"QQ空间";
                self.iconName = @"53";
                self.iconNameHighLight = @"53";
                break;
                
            default:
                break;
        }
    }
    
    return self;
}

@end
