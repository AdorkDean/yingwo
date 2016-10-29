//
//  YWTaTopicView.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaTopicView.h"
#import "YWTaTopicListView.h"

@implementation YWTaTopicView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *taTopicLabel = [[UILabel alloc] init];
        taTopicLabel.text = @"TA的话题";
        taTopicLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_2];
        taTopicLabel.font = [UIFont systemFontOfSize:14];
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.image = [UIImage imageNamed:@"Row"];
        rightImageView.contentMode = UIViewContentModeScaleAspectFill;

        [self addSubview:taTopicLabel];
        [self addSubview:rightImageView];

        [taTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(taTopicLabel);
        }];
    
    }
    return self;
}

- (void)addTopicListViewBy:(NSArray *)entities {
    
    YWTaTopicListView *lastView;
    
    //   int count = (entities.count > 3 ) ? 3 : (int)entities.count ;
    
    for (int i = 0; i < 3; i ++) {
        
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
                make.top.equalTo(self.mas_bottom).offset(10);
                make.left.equalTo(self).offset(10);
                make.bottom.equalTo(self).offset(-10);
                make.width.equalTo(@100);
            }];
            lastView = topicListView;
            
        }else {
            [topicListView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.mas_bottom).offset(10);
                make.left.equalTo(lastView.mas_left).offset(10);
                make.bottom.equalTo(self).offset(-10);
                make.width.equalTo(@100);
                
            }];
            lastView = topicListView;
        }
        
    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
    }];
    
}


- (void)selectTopic:(UIButton *)sender {
    
//    YWTaTopicListView *topicBtn = (YWTaTopicListView *)sender;
    
//    if ([self.delegate respondsToSelector:@selector(didSelectTopicWith:)])
//    {
//        [self.delegate didSelectTopicWith:topicBtn.topic_id];
//    }
    
}


@end
