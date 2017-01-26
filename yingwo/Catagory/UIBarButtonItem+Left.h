//
//  UIBarButtonItem+(Left).h
//  yingwo
//
//  Created by apple on 16/7/28.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  自定义导航栏左边按钮类，支持返回上一页，所有导航栏都应该倒入该类
 */
@interface UIBarButtonItem (Left)

- (instancetype)initLeftBarButtonItemWithImage;
/**
 *  返回上个界面（pop返回）
 *
 *  @param sender 当前界面
 */
- (void)popToForwardControllerWithSender:(UIViewController *) sender;

@end
