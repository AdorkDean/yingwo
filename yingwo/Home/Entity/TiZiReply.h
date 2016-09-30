//
//  TiZiReply.h
//  yingwo
//
//  Created by apple on 16/9/4.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TiZiReply : NSObject

//	回复ID
@property (nonatomic, assign) NSInteger reply_id;
//	用户ID
@property (nonatomic, assign) NSInteger user_id;
//帖子ID
@property (nonatomic, assign) NSInteger post_id;
//	创建时间戳
@property (nonatomic, assign) NSInteger create_time;
//无
@property (nonatomic, assign) NSInteger del;
//	内容
@property (nonatomic, copy  ) NSString  *content;
//	图片链接
@property (nonatomic, copy  ) NSString  *img;
//用户名
@property (nonatomic, copy  ) NSString  *user_name;
//用户头像
@property (nonatomic, copy  ) NSString  *user_face_img;

@end
