//
//  YWReplyCell.m
//  yingwo
//
//  Created by apple on 2017/2/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWReplyCell.h"

@implementation YWReplyCell

- (void)addCommentViewByCommentArr:(NSMutableArray *)commentArr withMasterId:(NSInteger)master_id{

    UIView *lastView;

    for (int i = 0; i < commentArr.count; i ++) {

        TieZiComment *entity            = [commentArr objectAtIndex:i];

        YWCommentView *commentView;

        //含楼主的评论需要重新布局，不能在init初始化实现所有布局
        //在createSubview中不能写实现所想的布局，不信自己试试去～
        if ([entity.user_id integerValue] == master_id) {

            commentView                        = [[YWCommentView alloc] init];
            commentView.leftName.text          = entity.user_name;
            //connectString内容为用户名字＋评论内容，其中“占“字为占位符

            //首行缩进
            NSString *connectString = @"";

            if (entity.commented_user_name == nil) {
                connectString            = [NSString stringWithFormat:@"%@占占 : %@",
                                                      entity.user_name,
                                                      entity.content];

            }
            else
            {
                connectString            = [NSString stringWithFormat:@"%@占占 回复 %@ : %@",
                                                      entity.user_name,
                                                      entity.commented_user_name,
                                                      entity.content];

            }
                //首行缩进
                commentView.content.attributedText = [NSMutableAttributedString changeCommentContentWithString:connectString
                                                                                                WithTextIndext:entity.user_name.length + 2];
        }
        else
        {
            //不含楼主的评论
            commentView                      = [[YWCommentReplyView alloc] init];
            commentView.leftName.text        = entity.user_name;

            //回复评论
            if (entity.commented_user_name.length != 0) {

                //connectString内容为用户名字＋评论内容
                NSString *connectString            = [NSString stringWithFormat:@"%@ 回复 %@ : %@",entity.user_name,entity.commented_user_name,entity.content];

                //首行缩进
                commentView.content.attributedText = [NSMutableAttributedString changeCommentContentWithString:connectString
                                                                                                WithTextIndext:entity.user_name.length];

            }
            //评论
            else
            {
                //connectString内容为用户名字＋评论内容
                NSString *connectString            = [NSString stringWithFormat:@"%@  : %@",entity.user_name,entity.content];
                //首行缩进
                commentView.content.attributedText = [NSMutableAttributedString changeCommentContentWithString:connectString
                                                                                                WithTextIndext:entity.user_name.length];
            }

        }

        commentView.post_reply_id               = [entity.post_reply_id intValue];
        commentView.post_comment_id             = [entity.comment_id intValue];
        commentView.post_comment_user_id        = [entity.post_comment_user_id intValue];
        commentView.user_id                     = [entity.user_id intValue];
        commentView.user_name                   = entity.user_name;
        commentView.sourceContent               = entity.content;

        UITapGestureRecognizer *tap             = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(comment:)];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(showMenuController:)];
        tap.numberOfTapsRequired                = 1;
        tap.numberOfTouchesRequired             = 1;

        [commentView addGestureRecognizer:tap];
        [commentView addGestureRecognizer:longPress];

        [self.bgCommentView addSubview:commentView];

        if (!lastView) {
            [commentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bgCommentView.mas_top).offset(10).priorityHigh();
                make.left.equalTo(self.contentLabel.mas_left).priorityHigh();
                make.right.equalTo(self.contentLabel.mas_right).priorityHigh();
            }];
        }
        else
        {
            [commentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(lastView.mas_bottom).offset(10).priorityHigh();
                make.left.equalTo(self.contentLabel.mas_left);
                make.right.equalTo(self.contentLabel.mas_right).priorityHigh();
            }];
        }
        lastView = commentView;
    }

    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgCommentView.mas_bottom).offset(-10).priorityLow();
    }];
}


@end
