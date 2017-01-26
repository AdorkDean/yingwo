//
//  MessageDetailViewModel.m
//  yingwo
//
//  Created by apple on 2016/11/7.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessageDetailViewModel.h"

@implementation MessageDetailViewModel

//- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath model:(TieZi *)model {
//
//    return @"replyCell";
//
//}

- (void)requestDetailWithUrl:(NSString *)url
                  paramaters:(NSDictionary *)paramaters
                     success:(void (^)(TieZi *tieZi))success
                     failure:(void (^)(NSString *error))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager = [YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content      = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                               options:NSJSONReadingMutableContainers
                                                                                 error:nil];
                  NSLog(@"detail:%@",content);
                  TieZi *originTieZi            = [TieZi mj_objectWithKeyValues:content[@"info"]];
                  
                  //图片实体
               //   originTieZi.imageUrlArrEntity = [NSString separateImageViewURLString:originTieZi.img];

                  
                  success(originTieZi);
              }
              else
              {
                  NSLog(@"消息界面原贴获取失败");
              }

              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"回贴获取失败");
          }];
}
@end
