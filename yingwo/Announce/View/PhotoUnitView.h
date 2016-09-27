//
//  photoUnitView.h
//  yingwo
//
//  Created by apple on 16/8/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoUnitView : UIView

@property (nonatomic, strong) UIButton    *deleteViewBtn;
@property (nonatomic, strong) UIImageView *photoImageView;

- (instancetype)initWithImage:(UIImage *)photoImage;

@end
