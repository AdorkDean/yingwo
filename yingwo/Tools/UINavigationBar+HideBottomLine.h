//
//  UINavigationBar+HideBottomLine.h
//  yingwo
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  去除导航栏下的一条线的分类，所有导航栏控制器都应该倒入该类
 */
@interface UINavigationBar (HideBottomLine)

//去除导航栏下的一条横线
- (void)hideNavigationBarBottomLine;

@end
