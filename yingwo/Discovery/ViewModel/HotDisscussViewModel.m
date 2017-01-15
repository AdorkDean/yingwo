//
//  HotDisscussViewModel.m
//  yingwo
//
//  Created by apple on 2017/1/11.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "HotDisscussViewModel.h"

@implementation HotDisscussViewModel

- (instancetype)init {
    
    if (self = [super init]) {
        
        [self setupRACComand];
    }
    
    return self;
}

- (void)setupRACComand {
    
    @weakify(self);
    _fecthTopicEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            RequestEntity *requestEntity = (RequestEntity *)input;
            
            NSDictionary *parameter = @{@"start_id":@(requestEntity.start_id)};
            
            [self requestForHotDiscussWithURL:requestEntity.requestUrl
                                    parameter:parameter
                                      success:^(NSArray *items) {
                
                                          [subscriber sendNext:items];
                                          [subscriber sendCompleted];
                                          
            } failure:^(NSError *failure) {
                
            }];
            
            
            return nil;
        }];
    }];
    
}


- (void)setupModelOfCell:(YWHotDiscussCell *)cell model:(HotDiscussEntity *)model {
    
    
    cell.topView.title.label.text = model.topic_title;
    cell.topView.title.topic_id   = model.topic_id;
    cell.middleView.content.text = model.body;
    
    [cell.middleView.imageView sd_setImageWithURL:[NSURL URLWithString:model.imageURL]
                                 placeholderImage:[UIImage imageNamed:@"ying"]];
    
    cell.bottomView.timeLabel.text = [NSDate getDateString:model.time];
    cell.bottomView.messageNumLabel.text = model.replyCount;
    
    [cell.bottomView addHeadImagesWith:model.listURL];
}



- (void)requestForHotDiscussWithURL:(NSString *)url
                          parameter:(NSDictionary *)parameter
                            success:(void (^)(NSArray *items ))success
                            failure:(void (^)(NSError *failure))failure {
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:parameter
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content   = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:nil];
                  
                  StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                  NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                  
                  for (NSDictionary *dic in entity.info) {
                      
                      HotDiscussEntity *field = [HotDiscussEntity mj_objectWithKeyValues:dic];
                      
                      field.imageUrlArrEntity = [NSString separateImageViewURLString:field.img];

                      [tempArr addObject:field];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSLog(@"获取主题失败");
          }];
    
}


@end
