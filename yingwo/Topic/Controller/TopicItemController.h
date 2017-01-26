//
//  TopicItemController.h
//  yingwo
//
//  Created by apple on 2017/1/26.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "GalleryController.h"

@interface TopicItemController : GalleryController

@property (nonatomic, strong) UIScrollView            *topicSrcView;
@property (nonatomic, assign) CGSize                  tableViewSize;
@property (nonatomic, assign) CGFloat                 tableViewY;

@property (nonatomic, strong) RequestEntity           *requestEntity;

@property (nonatomic, assign) int                     topic_id;
@property (nonatomic, assign) id<TopicControllerDelegate> delegate;

- (void)refreshData;

@end
