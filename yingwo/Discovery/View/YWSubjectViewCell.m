//
//  YWSubjectViewCell.m
//  yingwo
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWSubjectViewCell.h"

@implementation YWSubjectViewCell

- (void)createSubview {
    
    self.backgroundView                     = [[UIView alloc] init];
    self.backgroundColor                    = [UIColor colorWithHexString:BACKGROUND_COLOR];
    self.backgroundView.backgroundColor     = [UIColor whiteColor];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius  = 10;

    self.fieldListView                          = [[YWFieldListView alloc ] init];
    
    [self.contentView addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.fieldListView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 0, 10));
    }];
    

    [self.fieldListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView.mas_left).offset(10);
        make.right.equalTo(self.backgroundView.mas_right).offset(-10);
        make.top.equalTo(self.backgroundView.mas_top);
        make.height.equalTo(@44);
    }];
    
    
}

- (void)addTopicListViewBy:(NSArray *)entities {
    
    YWTopicListView *lastView;
    
 //   int count = (entities.count > 3 ) ? 3 : (int)entities.count ;
    
    for (int i = 0; i < entities.count; i ++) {
        
        TopicEntity *entity               = [entities objectAtIndex:i];

        YWTopicListView *topicListView    = [[YWTopicListView alloc] init];
        topicListView.tag                 = i+1;

        topicListView.topic_id            = [entity.topic_id intValue];
        topicListView.topic.text          = entity.title;
        topicListView.numberOfTopic.text  = [NSString stringWithFormat:@"%@贴子",entity.post_cnt];
        topicListView.numberOfFavour.text = [NSString stringWithFormat:@"%@关注",entity.like_cnt];

        [topicListView.leftImageView sd_setImageWithURL:[NSURL URLWithString:entity.img]
                                       placeholderImage:[UIImage imageNamed:@"morenhuati"]];

        [topicListView addTarget:self
                          action:@selector(selectTopic:)
                forControlEvents:UIControlEventTouchUpInside];
        
        [self.backgroundView addSubview:topicListView];
        
     //   topicListView.leftImageView.backgroundColor = [UIColor redColor];
        
        if (!lastView) {
            
            [topicListView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.fieldListView.mas_bottom);
                make.left.equalTo(self.fieldListView.mas_left);
                make.right.equalTo(self.fieldListView.mas_right);
                make.height.equalTo(@44);
            }];
            lastView = topicListView;
            
        }else {
            [topicListView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(10);
                make.left.equalTo(self.fieldListView.mas_left);
                make.right.equalTo(self.fieldListView.mas_right);
                make.height.equalTo(@44);
            }];
            lastView = topicListView;
        }
        
    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.backgroundView.mas_bottom).offset(-10).priorityLow();
    }];
    
}

- (void)selectTopic:(UIButton *)sender {
    
    YWTopicListView *topicBtn = (YWTopicListView *)sender;
    
    if ([self.delegate respondsToSelector:@selector(didSelectTopicWith:)])
    {
        [self.delegate didSelectTopicWith:topicBtn.topic_id];
    }
    
}

@end
