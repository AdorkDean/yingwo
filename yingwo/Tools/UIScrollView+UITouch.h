//
//  UIScrollView+UITouch.h
//  yingwo
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  UIView的touch事件被UIScrollView捕获了
 *  解决办法：给UIScrollView添加一个分类，让touches事件传递下去
 *  给需要传递的文件添加这个头文件，不添加到全局头文件里面了
 */
@interface UIScrollView (UITouch)

@end
