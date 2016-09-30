//
//  YWTopicViewCell.h
//  yingwo
//
//  Created by apple on 16/9/15.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YWTopicViewCellDelegate;

@interface YWTopicViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView             *leftImageView;

@property (nonatomic, strong) UIButton                *rightBtn;

@property (nonatomic, strong) UILabel                 *topic;

@property (nonatomic, strong) UILabel                 *numberOfTopic;

@property (nonatomic, strong) UILabel                 *numberOfFavour;

@property (nonatomic, assign) int                     topic_id;

@property (nonatomic, assign) id<YWTopicViewCellDelegate> delegate;

@end

@protocol YWTopicViewCellDelegate <NSObject>

//点击关注话题的按钮
- (void)didSelectRightBtnWith:(int)value;

@end
