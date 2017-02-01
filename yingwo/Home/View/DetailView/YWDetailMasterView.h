//
//  YWDetailMasterView.h
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTitle.h"

@protocol YWMasterDelegate;

@interface YWDetailMasterView : UIView

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *identifier;
@property (nonatomic, strong) UILabel     *nicnameLabel;
@property (nonatomic, strong) UILabel     *floorLabel;
@property (nonatomic, strong) UILabel     *timeLabel;

@property (nonatomic, assign) int         user_id;

@property (nonatomic, assign) id<YWMasterDelegate> delegate;

@end

@protocol YWMasterDelegate <NSObject>

- (void)didSelectMaster:(YWDetailMasterView *)masterView;

@end
