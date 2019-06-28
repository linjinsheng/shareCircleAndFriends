//
//  ShareCnfiguration.h
//  XueChu
//
//  Created by targetios on 2018/7/27.
//  Copyright © 2018年 eddy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareConfiguration : NSObject

//标题
@property (nonatomic, copy) NSString *title;

//内容
@property (nonatomic, copy) NSString *content;

//缩略图
@property (nonatomic, strong) id imageUrlString;

//点击链接
@property (nonatomic, copy) NSString *linkUrlString;

/**
 默认配置
 
 @return 配置对象本身
 */
+ (instancetype)defaultConfiguration;

@end
