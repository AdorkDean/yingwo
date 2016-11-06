//
//  YWMessageTopView.h
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWContentLabel.h"

@interface YWMessageTopView : UIView

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel     *nickname;
@property (nonatomic, strong) UILabel     *time;
@property (nonatomic, strong) UIButton    *deleteBtn;

@end
