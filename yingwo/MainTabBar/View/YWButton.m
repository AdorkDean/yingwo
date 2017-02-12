//
//  YWButton.m
//  XXTabBar
//
//  Created by apple on 16/7/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWButton.h"

@implementation YWButton

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage selectImage:(UIImage *)selectImage {
    if (self = [super init]) {
        
        self.selectedImage   = selectImage;
        self.backgroundImage = backgroundImage;
        [self setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)touchButton:(UIButton *)sender{
    
    UIButton *selectedBtn = sender;
    [selectedBtn setBackgroundImage:self.selectedImage forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        selectedBtn.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
        selectedBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];

}

@end
