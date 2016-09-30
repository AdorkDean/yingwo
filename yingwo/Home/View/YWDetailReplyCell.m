//
//  YWDetailReplyCell.m
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailReplyCell.h"
#import "TieZiComment.h"
#import "YWCommentView.h"
#import "YWCommentReplyView.h"

@implementation YWDetailReplyCell

- (void)createSubview {
    
    self.backgroundView                     = [[UIView alloc] init];
    self.backgroundColor                    = [UIColor clearColor];
    self.backgroundView.backgroundColor     = [UIColor whiteColor];
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.cornerRadius  = 10;


    self.masterView                         = [[YWDetailMasterView alloc] init];
    self.contentLabel                       = [[YWContentLabel alloc] initWithFrame:CGRectZero];
    self.bgImageView                        = [[UIView alloc] init];
    self.bgCommentView                      = [[UIView alloc] init];
    self.moreBtn                            = [[YWAlertButton alloc] initWithNames:[NSArray arrayWithObjects:@"复制",@"举报" ,nil]];

    self.contentLabel.font                  = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines         = 0;
    self.bottomView                         = [[YWDetailCellBottomView alloc] init];

    [self.masterView.identifier removeFromSuperview];
    
    [self.contentView addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.masterView];
    [self.backgroundView addSubview:self.contentLabel];
    [self.backgroundView addSubview:self.bottomView];
    [self.backgroundView addSubview:self.bgImageView];
    [self.backgroundView addSubview:self.bgCommentView];
    [self.backgroundView addSubview:self.moreBtn];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(2.5, 10, 2.5, 10));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top).offset(10);
        make.right.equalTo(self.backgroundView.mas_right).offset(-10);
    }];
    
    [self.masterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.backgroundView.mas_left).offset(20);
        make.right.equalTo(self.backgroundView.mas_right).offset(-10);
        make.top.equalTo(self.backgroundView.mas_top).offset(10);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.masterView.mas_bottom).offset(10);
        make.left.equalTo(self.masterView.mas_left);
        make.right.equalTo(self.masterView.mas_right);
    }];
    
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.equalTo(self.contentLabel.mas_left);
        make.right.equalTo(self.contentLabel.mas_right);
    }];

    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.left.equalTo(self.contentLabel.mas_left);
        make.right.equalTo(self.contentLabel.mas_right);
     //   make.bottom.equalTo(self.bgCommentView.mas_top).offset(-20).priorityLow();
    }];
    
    [self.bgCommentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(10);
        make.left.right.equalTo(self.backgroundView);
        make.bottom.equalTo(self.backgroundView.mas_bottom).priorityLow();
    }];
    
}

- (void)addImageViewByImageArr:(NSMutableArray *)entities {
    
    UIImageView *lastView;
    
    for (int i = 0; i < entities.count; i ++) {
        
        ImageViewEntity *entity           = [entities objectAtIndex:i];
        CGFloat imageHeight = SCREEN_WIDTH/entity.width *entity.height;
        
        UIImageView *imageView           = [[UIImageView alloc] init];
        imageView.tag                    = i+1;
        imageView.userInteractionEnabled = YES;
        
        //添加单击放大事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(singelTap:)];
        singleTap.numberOfTouchesRequired = 1;
        singleTap.numberOfTapsRequired    = 1;
        [imageView addGestureRecognizer:singleTap];
        
        imageView.mas_key                = [NSString stringWithFormat:@"DetailImageView%d:",i+1];
        
        [self.bgImageView addSubview:imageView];
        
        if (!lastView) {
            
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentLabel.mas_bottom).offset(10);
                make.left.equalTo(self.bgImageView.mas_left);
                make.right.equalTo(self.bgImageView.mas_right);
                make.height.equalTo(@(imageHeight)).priorityHigh();
            }];
            lastView = imageView;
            
        }else {
            [imageView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(lastView);
                make.top.equalTo(lastView.mas_bottom).offset(10).priorityHigh();
                make.height.equalTo(@(imageHeight)).priorityHigh();
            }];
            lastView = imageView;
        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:entity.imageName]
                     placeholderImage:[UIImage imageNamed:@"ying"]];
    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20).priorityLow();
    }];

    
}

- (void)singelTap:(UITapGestureRecognizer *)sender {
    
    if ([self.delegate respondsToSelector:@selector(didSeletedImageView:)]) {
        [self.delegate didSeletedImageView:(UIImageView *)sender.view];
        
    }
}

//添加评论
- (void)addCommentViewByCommentArr:(NSMutableArray *)commentArr withMasterId:(NSInteger)master_id{

    UIView *lastView;
    
    for (int i = 0; i < commentArr.count; i ++) {
        
        TieZiComment *entity            = [commentArr objectAtIndex:i];

        YWCommentView *commentView;
        
        //含楼主的评论需要重新布局，不能在init初始化实现所有布局
        //在createSubview中不能写实现所想的布局，不信自己试试去～
        if ([entity.user_id integerValue] == master_id) {
            
<<<<<<< HEAD
            commentView                        = [[YWCommentView alloc] init];
            commentView.leftName.text          = entity.user_name;

            //connectString内容为用户名字＋评论内容，其中“占“字为占位符
            NSString *connectString            = [NSString stringWithFormat:@"%@：占占%@",entity.user_name,entity.content];

            //首行缩进
            commentView.content.attributedText = [NSMutableAttributedString changeCommentContentWithString:connectString
                                                                                            WithTextIndext:entity.user_name.length + 2];

=======
            commentView                      = [[YWCommentView alloc] init];
            commentView.leftName.text        = entity.user_name;
            commentView.content.text         = [NSString stringWithFormat:@":%@",entity.content];
>>>>>>> origin/master
            
            [commentView.leftName mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(commentView.mas_left);
            }];
            
            [commentView.identfier mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(commentView.leftName.mas_right).priorityHigh();
                make.width.equalTo(@30);
            }];
            
            [commentView.content mas_updateConstraints:^(MASConstraintMaker *make) {
<<<<<<< HEAD
                make.top.equalTo(commentView.leftName.mas_top);
            }];

=======
                make.left.equalTo(commentView.leftName.mas_left);
            }];

            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            //首行缩进
            paragraphStyle.firstLineHeadIndent = 100;
            
            NSDictionary *ats = @{ NSParagraphStyleAttributeName : paragraphStyle};

            commentView.content.attributedText = [[NSAttributedString alloc] initWithString:entity.content attributes:ats];
            
            commentView.content.backgroundColor = [UIColor redColor];
            commentView.content.firstLineIndent = 100;
            [commentView.content sizeToFit];
//            [commentView.content mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(commentView.identfier.mas_right);
//            }];
            

>>>>>>> origin/master
        }
        else
        {
            //不含楼主的评论
            commentView                      = [[YWCommentReplyView alloc] init];
            commentView.leftName.text        = entity.user_name;
            
<<<<<<< HEAD
            //回复评论
            if (entity.commented_user_name.length != 0) {
                
                //connectString内容为用户名字＋评论内容
                NSString *connectString            = [NSString stringWithFormat:@"%@：回复:%@",entity.user_name,entity.content];
                
                //首行缩进
                commentView.content.attributedText = [NSMutableAttributedString changeCommentContentWithString:connectString
                                                                                                WithTextIndext:entity.user_name.length];
                
            }
            //评论
            else
            {
                //connectString内容为用户名字＋评论内容
                NSString *connectString            = [NSString stringWithFormat:@"%@：%@",entity.user_name,entity.content];
                
                //首行缩进
                commentView.content.attributedText = [NSMutableAttributedString changeCommentContentWithString:connectString
                                                                                                WithTextIndext:entity.user_name.length];
=======
            if (entity.commented_user_name.length != 0) {
                
                commentView.content.text         = [NSString stringWithFormat:@"回复%@:%@",
                                                    entity.commented_user_name,entity.content];
                commentView.content.firstLineIndent = entity.user_name.length + 20;
                NSLog(@"width:%f",commentView.content.firstLineIndent);
            }
            else
            {
                commentView.content.text         = [NSString stringWithFormat:@":%@",entity.content];
>>>>>>> origin/master
            }
        }
        
        commentView.post_reply_id        = [entity.post_reply_id intValue];
        commentView.post_comment_id      = [entity.comment_id intValue];
        commentView.post_comment_user_id = [entity.post_comment_user_id intValue];
        commentView.user_name            = entity.user_name;
<<<<<<< HEAD

=======
>>>>>>> origin/master
        
        UITapGestureRecognizer *tap      = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(comment:)];
        tap.numberOfTapsRequired         = 1;
        tap.numberOfTouchesRequired      = 1;
        
        [commentView addGestureRecognizer:tap];
        
        [self.bgCommentView addSubview:commentView];
        
<<<<<<< HEAD
=======
      //  NSLog(@"number of lines:%lu",commentView.content.numberOfLines) ;
     //   commentView.backgroundColor = [UIColor grayColor];
>>>>>>> origin/master
        
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

- (void)comment:(UITapGestureRecognizer *)sender{
    
    YWCommentView *tapView = (YWCommentView *)[sender view];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCommentView:)]) {
        [self.delegate didSelectCommentView:tapView];
    }
}




@end
