//
//  YWAvatarBrowserHelper.h
//  yingwo
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  七牛图片下载单例类
 */
@interface YWAvatarBrowserHelper : NSObject

@property (nonatomic, strong)void (^singleSuccessBlock)(UIImage *);
@property (nonatomic, strong)void (^singleFailureBlock)(NSString *);

/**
 *  单例
 *
 *  @return 
 */
+ (YWAvatarBrowserHelper *)shareInstance;

@end
