//
//  DiscoveryViewModel.m
//  yingwo
//
//  Created by apple on 16/8/27.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "DiscoveryViewModel.h"

@implementation DiscoveryViewModel

- (instancetype)init {
    if (self = [super init]) {
        
        [self setupRACComand];
        
    }
    
    return self;
}

- (NSMutableArray *)bannerArr {
    if (_bannerArr == nil) {
        _bannerArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _bannerArr;
}

- (NSString *)idForRowByIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0)
    {
        return @"bannerCell";
    }
    return @"subjectCell";
}

- (void)setupRACComand {
    
    @weakify(self);
    _fecthTopicEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            RequestEntity *requestEntity = (RequestEntity *)input;
            
            //这里刷新只刷新banner大图
            //先获取热点大图
            [self requestHotTopicListWithUrl:requestEntity.requestUrl
                                     success:^(NSArray *hotArr) {
                                         
                                         [self.bannerArr removeAllObjects];
                                         
                                         [self.bannerArr addObjectsFromArray:hotArr];
                     
                                         
                                         [subscriber sendNext:hotArr];
                                         [subscriber sendCompleted];
                                         
                
                                         
                                         
                                     } failure:^(NSString *error) {
                                         
                                     }];

            
            
            
            return nil;
        }];
    }];
    
}

- (void)setupModelOfCell:(YWDiscoveryBaseCell *)cell model:(DiscoveryViewModel *)model {
    
    if (model == nil) {
        
        if (self.bannerArr.count != 0) {
            
            NSMutableArray *bannerUrlArr = [[NSMutableArray alloc] init];
            
            for (HotTopicEntity *hot in self.bannerArr) {
                
                [bannerUrlArr addObject:hot.big_img];
                                
            }
            cell.mxScrollView.images = bannerUrlArr;
        }
        
    }

    
    
}

- (void)requestTopicFieldWithUrl:(NSString *)url
                         success:(void (^)(NSArray *fieldArr))success
                         failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:nil
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
                      
                      FieldEntity *field = [FieldEntity mj_objectWithKeyValues:dic];
                      [tempArr addObject:field];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];

    
}


- (void)requestHotTopicListWithUrl:(NSString *)url
                           success:(void (^)(NSArray *hotArr))success
                           failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [manager POST:fullUrl
       parameters:nil
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
                      
                      HotTopicEntity *field = [HotTopicEntity mj_objectWithKeyValues:dic];
                      [tempArr addObject:field];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
    
    
}



@end
