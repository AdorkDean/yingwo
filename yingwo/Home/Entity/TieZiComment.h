//
//  TiZiComment.h
//  yingwo
//
//  Created by apple on 16/9/6.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TieZiComment : NSObject
//评论的id
@property (nonatomic, copy)NSString *comment_id;
//被评论的回贴id
@property (nonatomic, copy)NSString *post_reply_id;
//被回复的评论的人id
@property (nonatomic, copy)NSString *post_comment_user_id;

//被回复的评论的人name
@property (nonatomic, copy)NSString *commented_user_name;

//用户id
@property (nonatomic, copy)NSString *user_id;
//内容
@property (nonatomic, copy)NSString *content;
//是否删除
@property (nonatomic, copy)NSString *del;

//用户昵称
@property (nonatomic, copy)NSString *user_name;
//用户头像
@property (nonatomic, copy)NSString *user_face_img;

@end
