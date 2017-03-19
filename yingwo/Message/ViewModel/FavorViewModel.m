//
//  FavorViewModel.m
//  yingwo
//
//  Created by apple on 2016/11/8.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FavorViewModel.h"

@implementation FavorViewModel

- (void)setupModelOfCell:(YWMessageCell *)cell model:(MessageEntity *)model {
    
    cell.topView.nickname.text = model.follow_user_name;
    NSString *dataString       = [NSString stringWithFormat:@"%d",model.create_time];
    cell.topView.time.text     = [NSDate getDateString:dataString];
    [cell.topView.headImageView sd_setImageWithURL:[NSURL URLWithString:model.follow_user_face_img]
                                  placeholderImage:[UIImage imageNamed:@"touxiang"]];

    cell.replyContent.text     = @"赞了你";
    
    [cell addFavorImageView];
        
    if ([cell isMemberOfClass:[YWImageMessageCell class]]) {
        
        [self setupModelOfImageCell:(YWImageMessageCell *)cell model:model];
    }
    else
    {
        [self setupModelOfNoImageCell:cell model:model];
    }
    
}

- (void)setupModelOfImageCell:(YWImageMessageCell *)cell model:(MessageEntity *)model {
    
    if ([model.source_type isEqualToString:@"POST"]) {
        cell.imageBottomView.username.text = @"原贴:";
    }
    if ([model.source_type isEqualToString:@"REPLY"]) {
        cell.imageBottomView.username.text = @"跟贴:";
    }

    //原帖内容
    if (model.content.length == 0) {
        cell.imageBottomView.content.text = @"分享图片";
    }
    else
    {
        cell.imageBottomView.content.text = model.content;
    }
    
    [cell.imageBottomView.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.img]
                                          placeholderImage:[UIImage imageNamed:@"yingwo"]];
    

    
}

- (void)setupModelOfNoImageCell:(YWMessageCell *)cell model:(MessageEntity *)model {
    
    if ([model.source_type isEqualToString:@"POST"]) {
        cell.bottomView.username.text = @"原贴:";
    }
    if ([model.source_type isEqualToString:@"REPLY"]) {
        cell.bottomView.username.text = @"跟贴:";
    }
    //原帖内容
    if (model.content.length == 0) {
        cell.bottomView.content.text = @"分享图片";
    }
    else
    {
        cell.bottomView.content.text = model.content;
    }
    
    NSString *content                      = [NSString stringWithFormat:@"%@ %@",model.user_name,model.content];
    
    cell.bottomView.content.attributedText = [NSMutableAttributedString
                                              changeCommentContentWithString:content
                                              WithTextIndext:model.user_name.length+1];
    
    cell.bottomView.content.attributedText = [NSMutableAttributedString changeContentWithText:content
                                                                               withTextIndext:model.user_name.length
                                                                                 withFontSize:13];

    
}
@end
