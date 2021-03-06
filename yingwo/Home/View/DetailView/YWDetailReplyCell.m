//
//  YWDetailReplyCell.m
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailReplyCell.h"


@interface YWDetailReplyCell()

@end

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
    self.moreBtn                            = [[YWAlertButton alloc] init];
    
    self.contentLabel.font                  = [UIFont systemFontOfSize:15];
    self.contentLabel.numberOfLines         = 0;
    self.bottomView                         = [[YWDetailCellBottomView alloc] init];

    self.bottomView.favour.tag = ReplyFavorSpringButtonTag;
    
    [self.masterView.identifier removeFromSuperview];
    
    [self.contentView addSubview:self.backgroundView];
    [self.backgroundView addSubview:self.masterView];
    [self.backgroundView addSubview:self.contentLabel];
    [self.backgroundView addSubview:self.bottomView];
    [self.backgroundView addSubview:self.bgImageView];
    [self.backgroundView addSubview:self.bgCommentView];
    [self.backgroundView addSubview:self.moreBtn];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 10, 2.5, 10));
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
        CGFloat imageHeight               = (SCREEN_WIDTH - 60)/entity.width *entity.height;
       
        UIImageView *imageView            = [[UIImageView alloc] init];
        imageView.tag                     = i+1;
        imageView.userInteractionEnabled  = YES;
        imageView.contentMode             = UIViewContentModeScaleAspectFit;

        //添加单击放大事件
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(singleTapEnlarge:)];
        singleTap.numberOfTouchesRequired = 1;
        singleTap.numberOfTapsRequired    = 1;
        [imageView addGestureRecognizer:singleTap];
        
        imageView.mas_key                 = [NSString stringWithFormat:@"DetailImageView%d:",i+1];
        
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
                     placeholderImage:[UIImage imageNamed:@"ying"]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                entity.isDownload = YES;
                            }];
    }
    
    [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20).priorityLow();
    }];

    
}

- (void)singleTapEnlarge:(UITapGestureRecognizer *)gesture {
    
    
    UIImageView *imageView = (UIImageView *)gesture.view;
    
    [self convertImageViewArr];
    
    self.imageTapBlock(imageView,self.imagesItem);
    
}

//添加评论
- (void)addCommentViewByCommentArr:(NSMutableArray *)commentArr withMasterId:(NSInteger)master_id{
    
    UIView *lastView;
    
    NSInteger count = commentArr.count > 3 ? 3 : commentArr.count;
    
    for (int i = 0; i < count; i ++) {
        
        TieZiComment *entity            = [commentArr objectAtIndex:i];
        
        YWCommentView *commentView;
        
        //含楼主的评论需要重新布局，不能在init初始化实现所有布局
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

        commentView.delegate                    = self;

        UITapGestureRecognizer *tap             = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(comment:)];
        tap.numberOfTapsRequired                = 1;
        tap.numberOfTouchesRequired             = 1;
        
        [commentView addGestureRecognizer:tap];
        
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
    
    UILabel *moreReplyBtn;
    if (commentArr.count > 3) {
        
        moreReplyBtn                    = [[UILabel alloc] init];
        moreReplyBtn.font               = [UIFont systemFontOfSize:13];
        moreReplyBtn.textColor          =[UIColor colorWithHexString:THEME_COLOR_1];
        // 获取replyId
        TieZiComment *entity            = [commentArr objectAtIndex:0];
        
        moreReplyBtn.tag                = [entity.post_reply_id integerValue];
        
        moreReplyBtn.text               = @"查看更多评论";
        
        [moreReplyBtn addTapAction:@selector(selectMoreCommetLabel:) target:self];

        [self.bgCommentView addSubview:moreReplyBtn];
        
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(moreReplyBtn.mas_top).offset(-10).priorityLow();
        }];
        
        [moreReplyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgCommentView);
            make.bottom.equalTo(self.bgCommentView.mas_bottom).offset(-10).priorityLow();
        }];

    }else {
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgCommentView.mas_bottom).offset(-10).priorityLow();
        }];
    }
}

#pragma mark YWCommentViewDelegate

- (void)didSelectLeftNameWithUserId:(int)userId {
 
    if ([self.delegate respondsToSelector:@selector(didSelectCommentViewLeftNameWithUserId:)]) {
        [self.delegate didSelectCommentViewLeftNameWithUserId:userId];
    }
    
}

#pragma mark private

- (void)convertImageViewArr {
    
    [self.imagesItem.imageViewArr removeAllObjects];
    
    [self.imagesItem.URLArr enumerateObjectsUsingBlock:^(UIImageView *obj,
                                                         NSUInteger idx,
                                                         BOOL * stop) {
        
        //保存imageView在cell上的位置
        UIImageView *oldImageView = [self viewWithTag:idx+1];
        
        //oldImageView有可能是空的，只是个占位imageView
        if (oldImageView.image == nil) {
            return;
        }
        UIImageView *newImageView = [[UIImageView alloc] init];
        newImageView.image        = oldImageView.image;
        newImageView.tag          = oldImageView.tag;
        newImageView.frame        = [oldImageView.superview convertRect:oldImageView.frame
                                                                 toView:[UIApplication sharedApplication].keyWindow.rootViewController.view];
        [self.imagesItem.imageViewArr addObject:newImageView];
    }];
}


- (void)selectMoreCommetLabel:(UITapGestureRecognizer *)sender {
    
    UIView *tapView = (UIView *)[sender view];
    
    if ([self.delegate respondsToSelector:@selector(didSelectMoreCommentLabelWith:)]) {
        [self.delegate didSelectMoreCommentLabelWith:tapView];
    }
    
}

- (void)comment:(UITapGestureRecognizer *)sender{
    
    YWCommentView *tapView = (YWCommentView *)[sender view];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCommentView:)]) {
        [self.delegate didSelectCommentView:tapView];
    }
}


@end







