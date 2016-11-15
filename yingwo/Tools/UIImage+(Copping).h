//
//  UIImage+(Copping).h
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  圆形裁剪类，主要用来裁剪圆形头像
 */
@interface UIImage (Copping)

+ (UIImage *)circleImage:(UIImage *)image ;

//等比率缩放
+ (UIImage *)scaleImageToScale:(float)scale withImage:(UIImage *)image;

//自定长宽
+ (UIImage *)scaleImageToSize:(CGSize)size withImage:(UIImage *)image;

//圆角
+ (UIImage *)circlewithImage:(UIImage *)image;


@end
