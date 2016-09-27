//
//  CommentView.h
//  yingwo
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YWLabel.h"
#import "YWContentLabel.h"


@interface YWCommentView : UIView

@property (nonatomic, strong) UILabel        *leftName;
@property (nonatomic, strong) UIImageView    *identfier;
@property (nonatomic, strong) YWContentLabel *content;

//这些值是点击评论的时候需要的
@property (nonatomic, assign) int            post_reply_id;
@property (nonatomic, assign) int            post_comment_id;
@property (nonatomic, assign) int            post_comment_user_id;
@property (nonatomic, copy  ) NSString       *user_name;

@end

@protocol YWCommentViewDelegate <NSObject>

- (void)commentViewWith:(int)postReplyId
              commentId:(int)commentId
          commentUserId:(int)commentUserId
      commentedUserName:(NSString *)userName;

@end
