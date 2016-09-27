//
//  YWTopicHeaderView.h
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MXImageScrollView.h"

@interface YWTopicHeaderView : MXImageScrollView

@property (nonatomic, strong) UIImageView *blurImageView;
@property (nonatomic, strong) UIImageView *headerView;
@property (nonatomic, strong) UILabel     *topic;
@property (nonatomic, strong) UILabel     *numberOfTopic;
@property (nonatomic, strong) UILabel     *numberOfFavour;
@property (nonatomic, strong) UIButton    *addTopicBtn;
@property (nonatomic, strong) UIButton    *cancelTopicBtn;


@end
