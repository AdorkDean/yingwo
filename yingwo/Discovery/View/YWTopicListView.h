//
//  YWTopicListView.h
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YWTopicListView : UIButton

@property (nonatomic, strong) UIImageView *leftImageView;

@property (nonatomic, strong) UILabel     *topic;

@property (nonatomic, strong) UILabel     *numberOfTopic;

@property (nonatomic, strong) UILabel     *numberOfFavour;

@property (nonatomic, assign) int         topic_id;

@end
