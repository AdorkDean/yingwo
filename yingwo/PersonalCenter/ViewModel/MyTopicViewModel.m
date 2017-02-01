//
//  MyTopicViewModel.m
//  yingwo
//
//  Created by apple on 2017/1/30.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "MyTopicViewModel.h"
#import "FieldEntity.h"

@implementation MyTopicViewModel

- (void)requestForField {
    
    [YWRequestTool YWRequestCachedPOSTWithURL:TOPIC_FIELD_URL
                                    parameter:nil
                                 successBlock:^(id content) {
                                     
                                     StatusEntity *entity    = [StatusEntity mj_objectWithKeyValues:content];
                                     NSMutableArray *tempArr = [[NSMutableArray alloc] init];
                                     
                                     for (NSDictionary *dic in entity.info) {
                                         
                                         FieldEntity *field = [FieldEntity mj_objectWithKeyValues:dic];
                                         [tempArr addObject:field];
                                         
                                     }
                                     
                                     self.successBlock(tempArr);
                                     
                                 } errorBlock:^(id error) {
                                     
                                 }];
}

@end
