//
//  RequestEntity.h
//  yingwo
//
//  Created by apple on 16/9/4.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <Foundation/Foundation.h>

//留言的类型
typedef NS_ENUM(NSInteger, MessageType){
    //获取评论和跟贴的列表
    CommentMessageType = 1,
    //获取点赞列表
    FavorMessageType = 2,
};

@interface RequestEntity : NSObject

//请求网址
@property (nonatomic, copy  ) NSString     *requestUrl;

//请求所需参数
@property (nonatomic, strong) NSDictionary *paramaters;

//领域下的id
@property (nonatomic, assign) int          field_id;

//主题的id
@property (nonatomic, assign) int          subject_id;

//话题的id
@property (nonatomic, assign) int          topic_id;

//过滤参数 0 全部 1 新鲜事 2 关注的话题
@property (nonatomic, assign) int          filter;

//最热话题
@property (nonatomic, assign) NSString     *sort;

//回贴偏移量
@property (nonatomic, assign) int          page;

//下拉刷新需要的偏移量
@property (nonatomic, assign) int          start_id;

//留言类型
@property (nonatomic, assign) MessageType  messageType;

//用户ID
@property (nonatomic, assign) int          user_id;


@end
