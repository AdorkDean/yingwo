//
//  YWReplyCell.m
//  yingwo
//
//  Created by apple on 2017/2/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "YWReplyCell.h"

@implementation YWReplyCell

-(DetailViewModel *)detailViewModel {
    if (_detailViewModel == nil) {
        _detailViewModel = [[DetailViewModel alloc] init];
    }
    return _detailViewModel;
}

//overwrite

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
    
    self.bottomView.favour.tag          = ReplyFavorSpringButtonTag;
    //hidden
    self.bottomView.favour.hidden       = YES;
    self.bottomView.message.hidden      = YES;
    self.bottomView.favourLabel.hidden  = YES;
    self.bottomView.messageLabel.hidden = YES;
    
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
        make.height.equalTo(@1);
        make.left.equalTo(self.contentLabel.mas_left);
        make.right.equalTo(self.contentLabel.mas_right);
    }];
    
    [self.bgCommentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(10);
        make.left.right.equalTo(self.backgroundView);
        make.bottom.equalTo(self.backgroundView.mas_bottom).priorityLow();
    }];
    
}

//overwrite
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
        
        commentView.delegate                    = self;

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(showMenuController:)];

        
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

#pragma mark YWCommentViewDelegate

- (void)didSelectLeftNameWithUserId:(int)userId {
    
    if ([self.delegate respondsToSelector:@selector(didSelectCommentViewLeftNameWithUserId:)]) {
        [self.delegate didSelectCommentViewLeftNameWithUserId:userId];
    }
    
}

#pragma mark private
- (void)showMenuController:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        [self showMenuWith:sender];
        
    }else if (sender.state == UIGestureRecognizerStateEnded){
        
    }
}

- (void)showMenuWith:(UILongPressGestureRecognizer *)sender {
    
    [self becomeFirstResponder];
    
    YWCommentView *comment           = [[YWCommentView alloc] init];
    YWCommentReplyView *commentReply = [[YWCommentReplyView alloc] init];
    
    YWCommentView *commentView;
    if ([sender.view isKindOfClass:commentReply.class]) {
        
        commentView                      = (YWCommentReplyView *)[sender view];
        self.selectedCommentView         = commentView;
        
    }else if ([sender.view isKindOfClass:comment.class]){
        
        commentView                      = (YWCommentView *)[sender view];
        self.selectedCommentView         = commentView;
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
    
    if ([self.delegate respondsToSelector:@selector(didDeleteRigthContentWithCommentId:commentView:)]) {
        [self.delegate didDeleteRigthContentWithCommentId:self.selectedCommentView.post_comment_id commentView:self.selectedCommentView];
    }
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



@end
