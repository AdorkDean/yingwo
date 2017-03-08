//
//  YWTopicScrView.m
//  yingwo
//
//  Created by 王世杰 on 2017/3/5.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWTopicScrView.h"

@implementation YWTopicScrView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.directionalLockEnabled = YES;
        
        self.backgroundColor = [UIColor colorWithHexString:BACKGROUND_COLOR];
        
    }
    return self;
}

-(void)addRecommendTopicWith:(NSArray *)entities {
    
    YWTitle *lastTopiclabel;
    self.contentSize                        = CGSizeMake(entities.count * 100, 0);
    
    YWTitle *firstLabel                     = [[YWTitle alloc] init];
    firstLabel.delegate                     = self;
    firstLabel.backgroundColor              = [UIColor whiteColor];
    firstLabel.label.text                   = @"全部";
    firstLabel.tag                          = 0; //区分全部
    
    [self addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(7);
        make.bottom.equalTo(self.mas_bottom).offset(-7);
        make.width.equalTo(firstLabel.mas_width);
    }];
    
    
    for (int i = 0; i < entities.count; i++) {
        TopicEntity *entity                 = [TopicEntity mj_objectWithKeyValues:[entities objectAtIndex:i]];
        
        YWTitle *topicLabel                 = [[YWTitle alloc] init];
        topicLabel.delegate                 = self;
        topicLabel.backgroundColor          = [UIColor whiteColor];
        topicLabel.tag                      = i + 1;
        
        topicLabel.label.text               = entity.title;
        topicLabel.topic_id                 = [entity.topic_id intValue];
        
        [self addSubview:topicLabel];
        
        if (!lastTopiclabel) {
            
            [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(firstLabel.mas_right).offset(8);
                make.top.equalTo(self.mas_top).offset(7);
                make.bottom.equalTo(self.mas_bottom).offset(-7);
                make.width.equalTo(topicLabel.mas_width);
            }];
            lastTopiclabel = topicLabel;
        }else {
            
            [topicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastTopiclabel.mas_right).offset(8);
                make.top.equalTo(self.mas_top).offset(7);
                make.bottom.equalTo(self.mas_bottom).offset(-7);
                make.width.equalTo(topicLabel.mas_width);
            }];
            lastTopiclabel = topicLabel;
        }
    }
    
    [lastTopiclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}


- (void)didSelectLabel:(YWTitle *)label withTopicId:(int)topicId {
    if ([self.Scrdelegate respondsToSelector:@selector(topicDidSelectLabel:withTopicId:)]) {
        [self.Scrdelegate topicDidSelectLabel:label withTopicId:topicId];
    }
}


@end









