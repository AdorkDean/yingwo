//
//  RelationViewModel.m
//  yingwo
//
//  Created by 王世杰 on 2016/11/11.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "RelationViewModel.h"

@interface RelationViewModel()

@property (nonatomic, strong) RelationEntity *selectedModel;

@end

@implementation RelationViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self setupRACComand];
        
    }
    return self;
}

- (void)setupRACComand {
    
    @weakify(self);
    _fecthRelationEntityCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self);
            
            RequestEntity *requestEntity = (RequestEntity *)input ;
            
            NSDictionary *paramaters = @{@"user_id":@(requestEntity.user_id)};
            
            [self requestRelationListWithUrl:requestEntity.requestUrl
                                  paramaters:paramaters
                                     success:^(NSArray *relationArr) {
                                         [subscriber sendNext:relationArr];
                                         [subscriber sendCompleted];
                                     }
                                     failure:^(NSString *error) {
                                         
                                     }];
            
            return  nil;
        }];
    }];
}

-(void)setupModelOfCell:(YWMyRelationShipCell *)cell model:(RelationEntity *)model {
    
    if (model != nil) {
        
        cell.user_id                = [model.user_id intValue];
        cell.nameLabel.text         = model.user_name;
        cell.signatureLabel.text    = model.user_signature;
        
        //设置按钮关注状态
        if ([model.status intValue] == 1) {
            [cell.rightBtn setImage:[UIImage imageNamed:@"guanzhuzhong"] forState:UIControlStateNormal];
            [cell.rightBtn setTitle:@"关注中" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4] forState:UIControlStateNormal];
            [cell.rightBtn addTarget:self
                              action:@selector(unFollowTa:)
                    forControlEvents:UIControlEventTouchUpInside];
            
        }else if([model.status intValue] == 0) {
            [cell.rightBtn setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
            [cell.rightBtn setTitle:@"关注" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];

            [cell.rightBtn addTarget:self
                              action:@selector(followTa:)
                    forControlEvents:UIControlEventTouchUpInside];
        }
        
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.user_face_img]
                              placeholderImage:nil];
        
    }
}

/**
 *  获取用户的关系列表
 *
 *  @param url
 *  @param paramaters  user_id
 *  @param success
 *  @param failure
 */
- (void)requestRelationListWithUrl:(NSString *)url
                        paramaters:(NSDictionary *)paramaters
                           success:(void (^)(NSArray *relationArr))success
                           failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
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
                      
                      RelationEntity *relationShip = [RelationEntity mj_objectWithKeyValues:dic];
                      [tempArr addObject:relationShip];
                      
                  }
                  
                  success(tempArr);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              
          }];
}

/**
 *  关注用户请求
 *
 *  @param url        /User/like
 *  @param paramaters user_id value
 *  @param success
 *  @param failure
 */
- (void)requestUserLikeWithUrl:(NSString *)url
                    paramaters:(NSDictionary *)paramaters
                       success:(void (^)(StatusEntity *status))success
                       failure:(void (^)(NSString *error))failure{
    
    NSString *fullUrl      = [BASE_URL stringByAppendingString:url];
    YWHTTPManager *manager =[YWHTTPManager manager];
    
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [manager POST:fullUrl
       parameters:paramaters
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              
              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)task.response;
              
              if (httpResponse.statusCode == SUCCESS_STATUS) {
                  
                  NSDictionary *content   = [NSJSONSerialization JSONObjectWithData:responseObject
                                                                            options:NSJSONReadingMutableContainers
                                                                              error:nil];
                  StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                  
                  success(entity);
              }
              
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              failure(@"网络错误");
          }];
}


//关注用户
- (void)followTa:(UIButton *)sender {
    
    YWMyRelationShipCell *selectedCell = (YWMyRelationShipCell *)sender.superview;
    
    NSDictionary *paramater = @{@"user_id":@(selectedCell.user_id),
                                @"value":@(1)};
    
    [self requestUserLikeWithUrl:TA_USER_LIKE_URL
                      paramaters:paramater
                         success:^(StatusEntity *status) {
                             if (status.status == YES) {
                                 
                                 [sender setImage:[UIImage imageNamed:@"guanzhuzhong"] forState:UIControlStateNormal];
                                 [sender setTitle:@"关注中" forState:UIControlStateNormal];
                                 [sender setTitleColor:[UIColor colorWithHexString:THEME_COLOR_4] forState:UIControlStateNormal];

                                 //先移除之前已经添加的action，再添加新的action
                                 [sender removeTarget:self
                                               action:@selector(followTa:)
                                     forControlEvents:UIControlEventTouchUpInside];
                                 
                                 [sender addTarget:self
                                            action:@selector(unFollowTa:)
                                  forControlEvents:UIControlEventTouchUpInside];
                                 
                             }else {
                                 [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                 [SVProgressHUD showErrorStatus:@"关注失败" afterDelay:HUD_DELAY];
                             }
                         }
                         failure:^(NSString *error) {
                             [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                             [SVProgressHUD showErrorStatus:@"关注失败" afterDelay:HUD_DELAY];
                         }];

    

}

//取关用户
- (void)unFollowTa:(UIButton *)sender {
    
    YWMyRelationShipCell *selectedCell          = (YWMyRelationShipCell *)sender.superview;
    
    UIAlertController *alertController          = [UIAlertController alertControllerWithTitle:@"取消关注Ta吗？"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction *imageAction                  = [UIAlertAction actionWithTitle:@""
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    
    UIImage *accessoryImage                     = selectedCell.headImageView.image;
    accessoryImage                              = [UIImage scaleImageToSize:CGSizeMake(40, 40) withImage:accessoryImage];
    accessoryImage                              = [UIImage circlewithImage:accessoryImage];
    accessoryImage                              = [accessoryImage imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, - SCREEN_WIDTH / 2 + 40, 0, 0)];
    accessoryImage                              = [accessoryImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [imageAction setValue:accessoryImage forKey:@"image"];
    
    [alertController addAction:imageAction];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction * _Nonnull action) {
                                                         
                                                          NSDictionary *paramater = @{@"user_id":@(selectedCell.user_id),
                                                                                      @"value":@(0)};
                                                          
                                                          [self requestUserLikeWithUrl:TA_USER_LIKE_URL
                                                                            paramaters:paramater
                                                                               success:^(StatusEntity *status) {
                                                                                   if (status.status == YES) {
                                                                                       
                                                                                       [sender setImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
                                                                                       [sender setTitle:@"关注" forState:UIControlStateNormal];
                                                                                       [sender setTitleColor:[UIColor colorWithHexString:THEME_COLOR_1] forState:UIControlStateNormal];

                                                                                       //先移除之前已经添加的action，再添加新的action
                                                                                       [sender removeTarget:self
                                                                                                     action:@selector(unFollowTa:)
                                                                                           forControlEvents:UIControlEventTouchUpInside];
                                                                                       
                                                                                       [sender addTarget:self
                                                                                                  action:@selector(followTa:)
                                                                                        forControlEvents:UIControlEventTouchUpInside];
                                                                                       
                                                                                   }else {
                                                                                       [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                                                                       [SVProgressHUD showErrorStatus:@"取消关注失败" afterDelay:HUD_DELAY];
                                                                                   }
                                                                               }
                                                                               failure:^(NSString *error) {
                                                                                   [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
                                                                                   [SVProgressHUD showErrorStatus:@"取消关注失败" afterDelay:HUD_DELAY];
                                                                               }];
                                                          
                                                          
                                                      }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];

    alertController.view.tintColor = [UIColor blackColor];
    
    UIViewController *rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];
    [rootViewController presentViewController:alertController
                                     animated:YES
                                   completion:nil];
}


@end






