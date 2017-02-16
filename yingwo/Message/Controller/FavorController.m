//
//  FavorController.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "FavorController.h"

#import "YWMessageCell.h"
#import "YWImageMessageCell.h"

#import "FavorViewModel.h"

#import "MessageEntity.h"


@interface FavorController ()

@property (nonatomic, strong) FavorViewModel *viewModel;

@end

@implementation FavorController


- (FavorViewModel *)viewModel {
    
    if (_viewModel == nil) {
        _viewModel = [[FavorViewModel alloc] init];
    }
    
    return _viewModel;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"点赞";
    
    self.requestEntity.URLString = MY_LIKED_URL;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
    
}

// overwrite
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    YWMessageCell *cell      = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                               forIndexPath:indexPath];
    [self.viewModel setupModelOfCell:cell model:self.messageArr[indexPath.row]];
    
    if (cell.topView.deleteBtn) {
        [cell.topView.deleteBtn removeFromSuperview];
    }
    
    cell.delegate            = self;
    cell.messageEntity       = self.messageArr[indexPath.row];
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
