//
//  UIImage+(Copping).m
//  yingwo
//
//  Created by apple on 16/7/17.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "UIImage+(Copping).h"

@implementation UIImage(Copping)

+ (UIImage *)circleImage:(UIImage *)image {
    
    UIImage *newImage = image;
    
    CGSize size = newImage.size;
    UIGraphicsBeginImageContext(size);
    //创建圆形路径
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //设置为裁剪区域
    [path addClip];
    //绘制图片
    [newImage drawAtPoint:CGPointZero];
    //获取裁剪后的图片
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
