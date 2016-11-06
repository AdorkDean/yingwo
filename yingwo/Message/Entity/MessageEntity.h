//
//  MessageEntity.h
//  yingwo
//
//  Created by apple on 2016/11/5.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "TieZiReply.h"

@interface MessageEntity : TieZiReply

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


@end
