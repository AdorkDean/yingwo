//
//  ReplyViewModel.m
//  yingwo
//
//  Created by apple on 2017/2/1.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "ReplyViewModel.h"

@implementation ReplyViewModel



- (void)setupModelOfCell:(YWReplyCell *)cell model:(TieZiReply *)model {
    //解决cell复用带来的问题
    //移除所有的子试图，再添加
    NSArray *subviews = [[NSArray alloc] initWithArray:cell.contentView.subviews];
    for (UIView *subview in subviews) {
        [subview removeFromSuperview];
    }
    
    //子view的创建延迟到viewmodel中
    [cell createSubview];
    
    cell.masterView.floorLabel.text            = @"楼主";
    //回复内容
    cell.contentLabel.text                     = model.content;
    if (model.user_name.length == 0) {
        cell.masterView.nicnameLabel.text          = @"匿名";
    }
    else
    {
        //昵称
        cell.masterView.nicnameLabel.text          = model.user_name;
        
    }
    //时间
    NSString *dataString                       = [NSString stringWithFormat:@"%d",model.create_time];
    cell.masterView.timeLabel.text             = [NSDate getDateString:dataString];
    
    //获取正确的头像url
    model.user_face_img = [NSString selectCorrectUrlWithAppendUrl:model.user_face_img];
    
    //头像
    [cell.masterView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.user_face_img]
                                     placeholderImage:[UIImage imageNamed:@"touxiang"]];
    
    //圆角头像
    cell.masterView.headImageView.layer.cornerRadius = 20;
    
    //user_id
    cell.masterView.user_id                          = model.user_id;
    
    cell.bottomView.favourLabel.text                 = model.like_cnt;
    
    //回复评论的数量
    cell.bottomView.messageLabel.text                = [NSString stringWithFormat:@"%d",model.comment_cnt];
    
    //当前回复的id，不是楼主的贴子id！！
    cell.bottomView.post_reply_id                          = model.reply_id;
    cell.bottomView.favour.reply_id                        = model.reply_id;
    
    //其他人可以删除自己的跟帖
    Customer *customer              = [User findCustomer];
    if (model.user_id != [customer.userId intValue]) {
        cell.moreBtn.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",nil];
    }else {
        cell.moreBtn.names  = [NSMutableArray arrayWithObjects:@"复制",@"举报",@"删除",nil];
    }
    //楼主删除可以所有跟帖
    if (self.master_id == [customer.userId intValue]) {
        cell.moreBtn.names = [NSMutableArray arrayWithObjects:@"复制",@"举报",@"删除",nil];
    }
    
    //判断是否有点赞过
    if ( [self isLikedTieZiWithReplyId:[NSNumber numberWithInt:model.reply_id]]) {
        [cell.bottomView.favour   setBackgroundImage:[UIImage imageNamed:@"heart_red"]
                                            forState:UIControlStateNormal];
        cell.bottomView.favour.isSpringReply = YES;
    }else {
        [cell.bottomView.favour setBackgroundImage:[UIImage imageNamed:@"heart_gray"]
                                          forState:UIControlStateNormal];
        cell.bottomView.favour.isSpringReply = NO;
    }
    
    //加载跟帖图片
    if (model.imageUrlEntityArr.count > 0) {
        
        NSMutableArray *entities = [NSMutableArray arrayWithArray:model.imageUrlEntityArr];
        
        self.imageUrlEntity      = entities;
        
        [cell addImageViewByImageArr:entities];
    }
    
    //加载评论
    if (model.commentArr.count > 0) {
        NSMutableArray *entities = [NSMutableArray arrayWithArray:model.commentArr];
        [cell addCommentViewByCommentArr:entities withMasterId:self.master_id];
    }
    else
    {
        //如果没有任何评论隐藏cell的下划线
        cell.bottomView.bottomLine.hidden = YES;
    }
}

@end
