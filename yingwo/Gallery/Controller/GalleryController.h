//
//  ViewController.h
//  YWGalleryView
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailController.h"
#import "TopicController.h"
#import "YWTabBarController.h"

#import "TieZi.h"
#import "GalleryViewModel.h"
#import "YWDropDownView.h"
#import "YWPhotoCotentView.h"

@interface GalleryController : BaseViewController

@property (nonatomic, strong) UITableView      *tableView;
@property (nonatomic, strong) GalleryViewModel *viewModel;
@property (nonatomic, strong) TieZi            *model;

@property (nonatomic, strong) NSMutableArray   *tieZiList;

@end

