//
//  MessageEntity.h
//  yingwo
//
//  Created by apple on 2016/11/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TieZiReply.h"

typedef NS_ENUM(NSInteger, TieZiType) {
    
    PostTieZi    = 1,
    ReplyTieZi   = 2,
    CommentTieZi = 3,
    MessageTieZi = 4,
    
};

@interface MessageEntity : TieZiReply

//贴子类型
@property (nonatomic, assign) TieZiType type;

@property (nonatomic, assign) int message_id;

@property (nonatomic, copy) NSString *url;

/**
 *  跟贴用户的id
 */
@property (nonatomic, copy) NSString *follow_user_id;

/**
 *  跟贴用户名
 */
@property (nonatomic, copy) NSString *follow_user_name;

/**
 *  跟贴用户的头像
 */
@property (nonatomic, copy) NSString *follow_user_face_img;

/**
 *  被评论的贴子类型：有三种情况
 *  POST代表原帖
 *  REPLY代表跟贴
 *  COMMENT代表评论
 */
@property (nonatomic, copy) NSString *source_type;

/**
 *  回复类型:这里有两种类型 
 *  跟贴（REPLY）
 *  评论（COMMENT）
 */
@property (nonatomic, copy) NSString *follow_type;

/**
 *  评论或回复的内容
 */
@property (nonatomic, copy) NSString *follow_content;

/**
 *  跟贴中带图片（评论中不带图片）
 */
@property (nonatomic, copy) NSString *follow_img;

//贴子的id
@property (nonatomic, assign) int       post_detail_id;
//话题ID 0 是新鲜事
@property (nonatomic, assign) int       post_detail_topic_id;
//用户id
@property (nonatomic, assign) int       post_detail_user_id;
//创建时间戳
@property (nonatomic, assign) int       post_detail_create_time;
//贴子的所属标签
@property (nonatomic, copy  ) NSString  *post_detail_topic_title;
//用户昵称
@property (nonatomic, copy  ) NSString  *post_detail_user_name;
//贴子内容
@property (nonatomic, copy  ) NSString  *post_detail_content;
//图片
@property (nonatomic, copy  ) NSString  *post_detail_img;
//用户头像
@property (nonatomic, copy  ) NSString  *post_detail_user_face_img;

//点赞数
@property (nonatomic, copy  ) NSString  *post_detail_like_cnt;

//回复数
@property (nonatomic, copy  ) NSString  *post_detail_reply_cnt;

//用户是否点赞
@property (nonatomic, assign) int       post_detail_user_post_like;


//这个是将img解析后的images url 数组
@property (nonatomic, strong) NSArray   *post_detail_imageUrlArrEntity;

@end
