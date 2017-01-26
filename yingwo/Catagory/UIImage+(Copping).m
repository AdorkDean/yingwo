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

//等比率缩放
+ (UIImage *)scaleImageToScale:(float)scale withImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//自定长宽
+ (UIImage *)scaleImageToSize:(CGSize)size withImage:(UIImage *)image
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//圆角
+ (UIImage *)circlewithImage:(UIImage *)image {
    
    // 开始图形上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
    
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    // 根据一个rect创建一个椭圆
    CGContextAddEllipseInRect(ctx, rect);
    
    // 裁剪
    CGContextClip(ctx);
    
    // 将原照片画到图形上下文
    [image drawInRect:rect];
    
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
