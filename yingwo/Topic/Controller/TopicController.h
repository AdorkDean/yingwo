//
//  TopicController.h
//  yingwo
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "TieZi.h"

typedef NS_ENUM(NSInteger,PageSelectedModel) {
    NewPageModel = 0,
    HotPageModel = 1,
};

@protocol TopicControllerDelegate;

@interface TopicController : BaseViewController

@property (nonatomic, strong) TieZi             *model;

@property (nonatomic, assign) int               topic_id;
@property (nonatomic, copy  ) NSString          *topic_title;

@property (nonatomic, assign) CGSize            pageTableViewSize;
@property (nonatomic, assign) CGFloat           oldTableViewY;

@property (nonatomic, assign) PageSelectedModel pageModel;


- (instancetype)initWithTopicId:(int)topicId;

@end

@protocol TopicControllerDelegate <NSObject>

- (void)didSelectCellWith:(TieZi *)model;

- (void)didSelectBottomWith:(id)bottomView;

@end
