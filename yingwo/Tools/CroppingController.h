//
//  CroppingController.h
//  YWPhoto
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  头像裁剪类
 */
@interface CroppingController : UIViewController<UIGestureRecognizerDelegate>


@property (nonatomic,retain) UIImage *croppedImage;

- (id)initWithCompleteBlock:(void (^)(UIImage *img))block;

@end
