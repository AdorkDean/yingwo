//
//  UINavigationBar+HideBottomLine.m
//  yingwo
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "UINavigationBar+HideBottomLine.h"

@implementation UINavigationBar (HideBottomLine)


- (void)hideNavigationBarBottomLine {
    
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self setShadowImage:[UIImage new]];
}
@end
