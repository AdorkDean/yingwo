//
//  YWSearchController.h
//  Test
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollegeModel.h"

typedef NS_ENUM(NSInteger, SearchModel) {
    SchoolSearchModel,
    AcademySearchModel,
};

@interface YWSearchController : UITableViewController<UISearchResultsUpdating, UISearchBarDelegate>

@property (nonatomic, strong) UISearchController *searchController;
//存储一个section中items
@property (nonatomic, strong) NSMutableArray     *tableSections;
//存储所有的sections
@property (nonatomic, strong) NSMutableArray     *tableSectionsAndItems;

@property (nonatomic, strong) NSMutableArray     *tableSectionsAndItemsPinYin;

@property (nonatomic, assign) SearchModel        searchModel;

@end
