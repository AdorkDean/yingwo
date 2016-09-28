//
//  UIImage+blur.h
//  yingwo
//
//  Created by apple on 16/9/28.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage   (blur)

/**
 *  图片变暗
 *
 *  @param image
 *  @param alpha 图明度
 *
 *  @return image
 */
+ (UIImage *)darkImage:(UIImage *)image withAlpha:(CGFloat)alpha;

/**
 *  通过Accelerate中高效的数学运算处理图片模糊
 *
 *  @param image
 *  @param blur  模糊度
 *
 *  @return 
 */
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
