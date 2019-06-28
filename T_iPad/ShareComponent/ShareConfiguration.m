//
//  ShareCnfiguration.m
//  XueChu
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import "ShareConfiguration.h"

@implementation ShareConfiguration

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content imageUrlString:(NSString *)imageUrlString linkUrlString:(NSString *)linkUrlString
{
    self = [super init];
    
    if (self)
    {
        self.title = title;
        self.content = content;
        self.imageUrlString = imageUrlString;
        self.linkUrlString = linkUrlString;
    }
    
    return self;
}

+ (instancetype)defaultConfiguration
{
    return [self configurationWithTitle:nil content:nil imageUrlString:nil linkUrlString:nil];
}

+ (instancetype)configurationWithTitle:(NSString *)title content:(NSString *)content imageUrlString:(NSString *)imageUrlString linkUrlString:(NSString *)linkUrlString
{
    return [[self alloc] initWithTitle:title content:content imageUrlString:imageUrlString linkUrlString:linkUrlString];
}


@end
