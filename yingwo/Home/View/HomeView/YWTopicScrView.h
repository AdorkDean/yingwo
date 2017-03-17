//
//  YWTopicScrView.h
//  yingwo
//
//  Created by 王世杰 on 2017/3/5.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWTitle.h"

@protocol YWTopicScrViewDelegate;

@interface YWTopicScrView : UIScrollView <YWTitleDelegate>

@property (nonatomic, assign) id<YWTopicScrViewDelegate> Scrdelegate;

- (void)addRecommendTopicWith:(NSArray *)entities;

@end

@protocol YWTopicScrViewDelegate <NSObject>

- (void)topicDidSelectLabel:(YWTitle *)label withTopicId:(int)topicId;

@end
