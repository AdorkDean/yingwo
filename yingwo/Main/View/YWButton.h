//
//  YWButton.h
//  XXTabBar
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWButton : UIButton

@property (nonatomic, strong)UIImage *selectedImage;
@property (nonatomic, strong)UIImage *backgroundImage;

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage selectImage:(UIImage *)selectImage;

@end
