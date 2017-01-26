//
//  YWDetailCellBottomView.h
//  yingwo
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YWSpringButton.h"

@protocol YWDetailCellBottomViewDelegate;

@interface YWDetailCellBottomView : UIView


@property (nonatomic, strong) YWSpringButton                 *favour;
@property (nonatomic, strong) UIButton                       *message;
@property (nonatomic, strong) UILabel                        *favourLabel;
@property (nonatomic, strong) UILabel                        *messageLabel;
@property (nonatomic, strong) UILabel                        *bottomLine;
@property (nonatomic, assign) id<YWDetailCellBottomViewDelegate> delegate;

//点击message按钮需要传的参数
@property (nonatomic, assign) NSInteger                      post_reply_id;
//@property (nonatomic, assign) NSString *post_comment_id;
//@property (nonatomic, assign) NSString *post_comment_user_id;

@end

@protocol YWDetailCellBottomViewDelegate <NSObject>

//点击回贴
//- (void)didSelectMessageWith:(NSInteger)replyId;

- (void)didSelectMessageWith:(NSInteger)replyId onSuperview:(UIView *)view;

//- (void)didSelectMessageWith:(NSString *)replyId
//                   commentId:(NSString *)commentId
//               commentUserId:(NSString *)commentUserId ;

@end
