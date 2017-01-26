//
//  HomeController.m
//  yingwo
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "HotTopicController.h"
#import "DetailController.h"

#import "TopicViewModel.h"



@interface HotTopicController ()


@end

@implementation HotTopicController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"最热";
    self.requestEntity.sort = @"hot";

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
