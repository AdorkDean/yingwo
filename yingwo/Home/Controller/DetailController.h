//
//  DetailController.h
//  yingwo
//
//  Created by apple on 16/8/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "BaseViewController.h"
#import "TieZi.h"

typedef NS_ENUM(NSInteger,CommentType) {
    TieZiCommentModel, //帖子的评论
    CommentedModel //评论的评论
};

/**
 *  DetailController 用于显示贴子、新鲜事的详细信息
 *  包括贴子的评论，用户可还可以评论贴子
 */
@interface DetailController : BaseViewController

//点击的贴子
@property (nonatomic, strong) TieZi       *model;

@property (nonatomic, assign) CommentType commentType;

@end
