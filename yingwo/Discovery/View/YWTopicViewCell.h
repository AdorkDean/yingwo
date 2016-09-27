//
//  YWTopicViewCell.h
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWTopicViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UIButton    *rightBtn;

@property (nonatomic, strong) UILabel     *topic;

@property (nonatomic, strong) UILabel     *numberOfTopic;

@property (nonatomic, strong) UILabel     *numberOfFavour;

@end
