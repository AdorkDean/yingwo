//
//  CommentView.h
//  yingwo
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YWCommentView : UIView


@property (nonatomic, strong) UILabel     *leftName;
@property (nonatomic, strong) UIImageView *identfier;
@property (nonatomic, strong) UILabel     *content;
@property (nonatomic, strong) UIButton    *deleteBtn;

//这些值是点击评论的时候需要的
@property (nonatomic, assign) int         post_reply_id;
@property (nonatomic, assign) int         post_comment_id;
@property (nonatomic, assign) int         post_comment_user_id;
@property (nonatomic, assign) int         user_id;
@property (nonatomic, copy  ) NSString    *user_name;
@property (nonatomic, copy  ) NSString    *sourceContent;

@end

@protocol YWCommentViewDelegate <NSObject>

- (void)commentViewWith:(int)postReplyId
              commentId:(int)commentId
          commentUserId:(int)commentUserId
      commentedUserName:(NSString *)userName;

@end
