//
//  MBProgressHUD+Dispaly.h
//  yingwo
//
//  Created by apple on 16/7/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  MBProgressHUD 分类，用于扩展 MBProgressHUD 
 */
@interface MBProgressHUD (Dispaly)

+ (void)showHUDToAddToView:(UIView *)view
                 labelText:(NSString *)text
                  animated:(Boolean)animated
                afterDelay:(float)delay
                   success:(void (^)())success;

+ (void)showErrorHUDToAddToView:(UIView *)view
                 labelText:(NSString *)text
                  animated:(Boolean)animated
                afterDelay:(float)delay;

+ (MBProgressHUD *)showActivityIndicatorToView:(UIView *)view
                                      animated:(Boolean)animated;

+ (MBProgressHUD *)showProgressViewToView:(UIView *)view
                                 animated:(Boolean)animated;

@end
