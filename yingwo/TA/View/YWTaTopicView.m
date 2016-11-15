//
//  YWTaTopicView.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaTopicView.h"
#import "YWTaTopicListView.h"

#define DEVICESCALE SCREEN_WIDTH / 375  //定义屏幕比例（与667 * 375相比）

#define TOPICLISTVIEWWIDTH (SCREEN_WIDTH - DEVICESCALE * 80) / 3


@interface YWTaTopicView()

@property (nonatomic, strong) UILabel               *taTopicLabel;
@property (nonatomic, strong) UIImageView           *rightImageView;
@property (nonatomic, strong) UIView                *separator;

@end

@implementation YWTaTopicView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor            = [UIColor whiteColor];
        UILabel *taTopicLabel           = [[UILabel alloc] init];
        taTopicLabel.text               = @"TA的话题";
        taTopicLabel.textColor          = [UIColor colorWithHexString:THEME_COLOR_4];
        taTopicLabel.font               = [UIFont systemFontOfSize:SCREEN_HEIGHT / 667 * 16];
        self.taTopicLabel               = taTopicLabel;
        
        UIImageView *rightImageView     = [[UIImageView alloc] init];
        rightImageView.image            = [UIImage imageNamed:@"Row"];
        rightImageView.contentMode      = UIViewContentModeScaleAspectFill;
        self.rightImageView             = rightImageView;
        
        UILabel *moreLabel              = [[UILabel alloc] init];
        moreLabel.text                  = @"更多";
        moreLabel.textColor             = [UIColor colorWithHexString:THEME_COLOR_4];
        moreLabel.font                  = [UIFont systemFontOfSize:SCREEN_HEIGHT / 667 * 16];
        
        self.separator                  = [[UIView alloc] init];
        self.separator.backgroundColor  = [UIColor colorWithHexString:@"#F5F5F5"];
        
        [self addSubview:self.taTopicLabel];
        [self addSubview:self.rightImageView];
        [self addSubview:self.separator];
        [self addSubview:moreLabel];

        [self.taTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
        }];
        
        [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(taTopicLabel);
        }];
        
        [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.taTopicLabel.mas_bottom).offset(5);
            make.right.width.equalTo(self);
            make.height.equalTo(@1);
        }];
        
        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.rightImageView.mas_left).offset(-10);
            make.top.equalTo(self.taTopicLabel);
        }];
    
    }
    return self;
}

- (void)addTopicListViewBy:(NSArray *)entities {
    
    if (entities.count > 0) {
        
        YWTaTopicListView *lastView;
        for (int i = 0; i < 3 && i < entities.count; i ++) {
            
            TopicEntity *entity               = [entities objectAtIndex:i];
            
            YWTaTopicListView *topicListView    = [[YWTaTopicListView alloc] init];
            topicListView.tag                   = i+1;
            
            topicListView.topic_id            = [entity.topic_id intValue];
            topicListView.topic.text          = entity.title;
            
            [topicListView.topicImageView sd_setImageWithURL:[NSURL URLWithString:entity.img]
                                            placeholderImage:[UIImage imageNamed:@"morenhuati"]];
            
            [topicListView addTarget:self
                              action:@selector(selectTopic:)
                    forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:topicListView];
            
            if (!lastView) {
                [topicListView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.separator.mas_bottom).offset(5);
                    make.left.equalTo(self).offset(10);
                    make.bottom.equalTo(self).offset(-10);
                    make.width.mas_equalTo(TOPICLISTVIEWWIDTH);
                }];
                lastView = topicListView;
                
            }else {
                [topicListView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.separator.mas_bottom).offset(5);
                    make.left.equalTo(lastView.mas_right).offset(DEVICESCALE * 20);
                    make.bottom.equalTo(self).offset(-10);
                    make.width.mas_equalTo(TOPICLISTVIEWWIDTH);
                }];
                lastView = topicListView;
            }
            
        }
        
    }
    else {
        UILabel *noTopicLabel = [[UILabel alloc] init];
        noTopicLabel.text = @"TA还未关注过话题哦~";
        noTopicLabel.font = [UIFont systemFontOfSize:14];
        noTopicLabel.textAlignment = NSTextAlignmentCenter;
        noTopicLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
        
        [self addSubview:noTopicLabel];
        
        [noTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.centerY.equalTo(self);
        }];
    }
    
}


- (void)selectTopic:(UIButton *)sender {
    
    YWTaTopicListView *topicBtn = (YWTaTopicListView *)sender;
    
    if ([self.delegate respondsToSelector:@selector(didSelectTopicWith:)])
    {
        [self.delegate didSelectTopicWith:topicBtn.topic_id];
    }
    
}


@end
