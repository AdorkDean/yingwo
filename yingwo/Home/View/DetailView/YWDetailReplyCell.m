//
//  YWDetailReplyCell.m
//  yingwo
//
//  Created by apple on 16/9/3.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWDetailReplyCell.h"


@interface YWDetailReplyCell()

@property (nonatomic, strong) YWCommentView     *selectedCommentView;
@property (nonatomic, strong) DetailViewModel   *detailViewModel;

@end

@implementation YWDetailReplyCell

-(DetailViewModel *)detailViewModel {
    if (_detailViewModel == nil) {
        _detailViewModel = [[DetailViewModel alloc] init];
    }
    return _detailViewModel;
}

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
    
    UIButton *moreBtn;
    if (commentArr.count > 3) {
        
        moreBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:13];

        // 获取replyId
        TieZiComment *entity    = [commentArr objectAtIndex:0];

        moreBtn.tag             = [entity.post_reply_id integerValue];
        
        [moreBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];
        [moreBtn setTitle:@"查看更多评论" forState:UIControlStateNormal];

        [moreBtn addTarget:self
                    action:@selector(selectMoreCommetBtn:)
          forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgCommentView addSubview:moreBtn];
    }
    
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
    
    if (moreBtn != nil) {
        
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(moreBtn.mas_top).offset(-10).priorityLow();
        }];
        
        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgCommentView);
            make.bottom.equalTo(self.bgCommentView.mas_bottom).offset(-10).priorityLow();
        }];
    }
    else
    {
        [lastView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.bgCommentView.mas_bottom).offset(-10).priorityLow();
        }];
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


- (void)comment:(UITapGestureRecognizer *)sender{
    
    YWCommentView *tapView = (YWCommentView *)[sender view];
    
    if ([self.delegate respondsToSelector:@selector(didSelectCommentView:)]) {
        [self.delegate didSelectCommentView:tapView];
    }
}

- (void)showMenuController:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {

        [self showMenuWith:sender];
        
    }else if (sender.state == UIGestureRecognizerStateEnded){

    }
}

- (void)showMenuWith:(UILongPressGestureRecognizer *)sender {
    
    [self becomeFirstResponder];
    YWCommentView *comment = [[YWCommentView alloc] init];
    YWCommentReplyView *commentReply = [[YWCommentReplyView alloc] init];
    
    YWCommentView *commentView;
    if ([sender.view isKindOfClass:commentReply.class]) {
        
        commentView = (YWCommentReplyView *)[sender view];
        self.selectedCommentView   = commentView;
        
    }else if ([sender.view isKindOfClass:comment.class]){
        
        commentView = (YWCommentView *)[sender view];
        self.selectedCommentView   = commentView;
    }

    UIMenuItem *copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyAction:)];
    UIMenuItem *reportItem = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(reportAction:)];
    UIMenuItem *deleteItem = [[UIMenuItem alloc]initWithTitle:@"删除" action:@selector(deleteAction:)];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    Customer *user = [User findCustomer];
    if (commentView.user_id == [user.userId intValue]) {
        menuController.menuItems = @[copyItem,reportItem,deleteItem];
    }else {
        menuController.menuItems = @[copyItem,reportItem];
    }
    //将悬浮菜单栏置于回复视图上
    [menuController setTargetRect:commentView.content.frame inView:commentView.content];
    [menuController setMenuVisible:YES animated:YES];
    
}

-(void)copyAction:(id)sender {
    UIPasteboard *pastBoard = [UIPasteboard generalPasteboard];
    pastBoard.string = self.selectedCommentView.sourceContent;
    [SVProgressHUD showSuccessStatus:@"已复制" afterDelay:HUD_DELAY];
}

-(void)reportAction:(id)sender {
    NSLog(@"---%s---",__func__);
}

-(void)deleteAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"操作不可恢复，确认删除吗？"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [self deleteComment];
                                                        }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel handler:nil]];
    
    alertController.view.tintColor = [UIColor blackColor];
    
    [self.window.rootViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
  

}

-(void)deleteComment {
    
    int commentId = self.selectedCommentView.post_comment_id;
    //网络请求
    NSDictionary *paramaters = @{@"comment_id":@(commentId)};
    
    //必须要加载cookie，否则无法请求
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
//    [self.detailViewModel deleteCommentWithUrl:TIEZI_COMMENT_DEL_URL
//                                    paramaters:paramaters
//                                       success:^(StatusEntity *statusEntity) {
//                                           if (statusEntity.status == YES) {
//                                               //将被删除的view从视图中移除
//                                               [self.selectedCommentView removeFromSuperview];
//                                               [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:HUD_DELAY];
//                                           }else if(statusEntity.status == NO){
//                                               
//                                               [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:HUD_DELAY];
//                                           }
//                                       }
//                                       failure:^(NSString *error) {
//                                           NSLog(@"error:%@",error);
//                                       }];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return action==@selector(deleteAction:)||
    action==@selector(reportAction:)||
    action==@selector(copyAction:);
}

- (void)selectMoreCommetBtn:(UIButton *)btn {
    
    if ([self.delegate respondsToSelector:@selector(didSelectMoreCommentBtnWith:)]) {
        [self.delegate didSelectMoreCommentBtnWith:btn];
    }
    
}


@end







