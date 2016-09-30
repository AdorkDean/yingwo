//
//  YWSearchController.m
//  Test
//
//  Created by apple on 16/8/18.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWSearchController.h"
#import "YWSearchBar.h"

#import "PerfectInfoController.h"

@interface YWSearchController ()
@property (nonatomic, strong) UIBarButtonItem     *leftBarItem;

@property (nonatomic, strong) CollegeModel *model;
@property (nonatomic, copy  ) NSString     *searchPlaceholderString;
@end

@implementation YWSearchController

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    }
    return _leftBarItem;
}

- (CollegeModel *)model {
    if (_model == nil) {
        _model = [[CollegeModel alloc] init];
    }
    return _model;
}

- (NSMutableArray *)tableSectionsAndItemsPinYin {
    if (_tableSectionsAndItemsPinYin == nil) {
        _tableSectionsAndItemsPinYin = [[NSMutableArray alloc] init];
    }
    return _tableSectionsAndItemsPinYin;
}

- (NSString *)searchPlaceholderString {
    if (_searchPlaceholderString.length == 0) {
        if (self.searchModel == SchoolSearchModel) {
            _searchPlaceholderString = @"输入学校的名称";
        }else if (self.searchModel == AcademySearchModel) {
            _searchPlaceholderString = @"输入学院的名称";
        }
    }
    return _searchPlaceholderString;
}

#pragma mark action

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self styleTableView];
    [self initializeTableContent];
    [self initializeSearchController];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = self.leftBarItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchController.view removeFromSuperview];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  初始化table中的数据
 */
- (void)initializeTableContent {
    
    self.tableSections         = [NSMutableArray arrayWithArray:[self.model getCollegeGroupNamesFromUserDefault]];
    self.tableSectionsAndItems = [NSMutableArray arrayWithArray:[self.model getCollegeDataFromUserDefault]];
    
    //  中文转拼音再存储，筛选时要用
    for (int i = 0; i < self.tableSectionsAndItems.count; i ++) {
        
        NSArray *items           = [self.tableSectionsAndItems objectAtIndex:i];
        NSMutableArray *newItems = [[NSMutableArray alloc] init];

        for (int j = 0; j < items.count; j ++) {
            
            NSDictionary *dic    = [items objectAtIndex:j];
            NSString *group      = dic[@"group"];
            NSString *name       = dic[@"name"];
            name                 = [self transformChinese:name];
            NSDictionary *newDic = @{@"group":group,@"name":name};
            [newItems addObject:newDic];
        }
        [self.tableSectionsAndItemsPinYin addObject:newItems];
    }
}

- (void)initializeSearchController {
    
    //instantiate a search results controller for presenting the search/filter results (will be presented on top of the parent table view)
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    
    //instantiate a UISearchController - passing in the search results controller table
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    
    //this view controller can be covered by theUISearchController's view (i.e. search/filter table)
    self.definesPresentationContext = YES;
    
    //dont hide the navigationBar when focus on searchbar
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //init searchbar placeholder by different search model
    self.searchController.searchBar.placeholder = self.searchPlaceholderString;
    
    //define the frame for the UISearchController's search bar and tint
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    
    //add the UISearchController's search bar to the navigationBar's title view
    self.navigationItem.titleView = self.searchController.searchBar;
    
    //this ViewController will be responsible for implementing UISearchResultsDialog protocol method(s) - so handling what happens when user types into the search bar
    self.searchController.searchResultsUpdater = self;
    
    //this ViewController will be responsisble for implementing UISearchBarDelegate protocol methods(s)
    self.searchController.searchBar.delegate = self;
}

- (void)styleTableView {
    
    [[self tableView] setSectionIndexColor:[UIColor colorWithHexString:THEME_COLOR_3]];
    [[self tableView] setSectionIndexBackgroundColor:[UIColor colorWithHexString:BACKGROUND_COLOR alpha:0.5 ]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [self.tableSections count];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *sectionItems = [self.tableSectionsAndItems objectAtIndex:section];
    
    return sectionItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellReuseId = @"ReuseCell";

    UITableViewCell *cell        = [tableView dequeueReusableCellWithIdentifier:CellReuseId];

    if(cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellReuseId];
    }
    
    NSArray *sectionItems    = [self.tableSectionsAndItems objectAtIndex:indexPath.section];
    NSDictionary *item       = [sectionItems objectAtIndex:indexPath.row];
    cell.textLabel.text      = item[@"name"];
    cell.textLabel.font      = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor colorWithHexString:THEME_COLOR_3];
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionItems = [self.tableSectionsAndItems objectAtIndex:indexPath.section];
    
    NSDictionary *selectedItem = [sectionItems objectAtIndex:indexPath.row];
    
    [self backToPerfectInfoViewWithSelectedItem:selectedItem];
    
//    NSString *name = [selectedItem objectForKey:@"name"];
//
//    NSLog(@"User selected %@", name);
//    
//    [self backToPerfectInfoViewWithString:name];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.tableSections objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    //only show section index titles if there is no text in the search bar
    if(!(self.searchController.searchBar.text.length > 0)) {
        
        NSArray *indexTitles = [NSMutableArray arrayWithArray:[self.model getCollegeGroupNamesFromUserDefault]];
        
        return indexTitles;
        
    } else {
        
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //background color of section
    view.tintColor = [UIColor colorWithHexString:BACKGROUND_COLOR alpha:0.5];
    
    //color of text in header
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    
    [header.textLabel setFont:[UIFont systemFontOfSize:14]];
    [header.textLabel setTextColor:[UIColor colorWithHexString:THEME_COLOR_3]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

#pragma mark - UISearchResultsUpdating
//-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    
//    NSString *searchText = [self.searchController.searchBar text];
//    
//    if ([searchText length] == 0) {
//        [self initializeTableContent];
//    }else {
//        
//        //这一步必须要，先清除tableSectionsAndItemsPinYin的内容在添加
//        [self.tableSectionsAndItemsPinYin removeAllObjects];
//        
//        //初始化数组
//        [self initializeTableContent];
//        
//        //移除section title的内容，后面重新添加
//        [self.tableSections removeAllObjects];
//
//        if ([searchText length] > 0) {
//            
//            NSMutableArray *searchItems = [[NSMutableArray alloc] init];
//            
//            //先根据拼音数组，按照拼音找对应的大学名字
//            //这里不是按照大学首字母英文来找的，是根据所有拼音来找的
//            for (int i = 0; i < self.tableSectionsAndItemsPinYin.count;  i++) {
//                
//                NSArray *pinyinItems     = self.tableSectionsAndItemsPinYin[i];
//                NSArray *chineseItems    = self.tableSectionsAndItems[i];
//                NSMutableArray *newItems = [[NSMutableArray alloc] init];
//                
//                for (int j = 0; j < pinyinItems.count; j ++) {
//                    
//                    NSDictionary *pinyinDic = pinyinItems[j];
//                    NSString *name          = pinyinDic[@"name"];
//
//                    if ([name containsString:searchText]) {
//                        //找到对应的拼音大学名字后，将对应的中文名字的位置添加到新的数组中
//                        [newItems addObject:chineseItems[j]];
//                    }
//                }
//                //如果匹配不到，不添加空数组
//                if (newItems.count != 0) {
//                    
//                    [searchItems addObject:newItems];
//
//                }
//            }
//            
//            self.tableSectionsAndItems = searchItems;
//            
//            //更换section title中的内容
//            for (NSArray *items in self.tableSectionsAndItems) {
//                NSDictionary *dic = items[0];
//                NSString *group   = dic[@"group"];
//                [self.tableSections addObject:group];
//            }
//            
//            [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
//
//        }
//    }
//
//}

//本来准备通过输入首字母拼音的方式查找的，后来调整了，改为中文查找

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchText = [self.searchController.searchBar text];
    
    if ([searchText length] == 0) {
        [self initializeTableContent];
    }else {
        
        //这一步必须要，先清除tableSectionsAndItemsPinYin的内容在添加
        [self.tableSectionsAndItemsPinYin removeAllObjects];
        
        //初始化数组
        [self initializeTableContent];
        
        //移除section title的内容，后面重新添加
        [self.tableSections removeAllObjects];
        
        if ([searchText length] > 0) {
            
            NSMutableArray *searchItems = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < self.tableSectionsAndItems.count;  i++) {
                
          //      NSArray *pinyinItems     = self.tableSectionsAndItemsPinYin[i];
                NSArray *chineseItems    = self.tableSectionsAndItems[i];
                NSMutableArray *newItems = [[NSMutableArray alloc] init];
                
                for (int j = 0; j < chineseItems.count; j ++) {
                    
                    NSDictionary *groupDic = chineseItems[j];
                    NSString *name          = groupDic[@"name"];
                    
                    if ([name containsString:searchText]) {
                        //找到对应的拼音大学名字后，将对应的中文名字的位置添加到新的数组中
                        [newItems addObject:chineseItems[j]];
                    }
                }
                //如果匹配不到，不添加空数组
                if (newItems.count != 0) {
                    
                    [searchItems addObject:newItems];
                    
                }
            }
            
            self.tableSectionsAndItems = searchItems;
            
            //更换section title中的内容
            for (NSArray *items in self.tableSectionsAndItems) {
                NSDictionary *dic = items[0];
                NSString *group   = dic[@"group"];
                [self.tableSections addObject:group];
            }
            
            [((UITableViewController *)self.searchController.searchResultsController).tableView reloadData];
            
        }
    }
    
}

#pragma mark - UISearchBarDelegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //customer the cancel title
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
        }
    }
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    //先移除，再添加
    [self.tableSections removeAllObjects];
    
    [self.tableSectionsAndItems removeAllObjects];
    
    [self initializeTableContent];
}

- (NSString *)transformChinese:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
//    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}

- (void)backToPerfectInfoViewWithString:(NSString *)name {
    
    PerfectInfoController *perfectInfoVc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    if (self.searchModel == SchoolSearchModel) {
        perfectInfoVc.school = name;
    }else {
        perfectInfoVc.academy = name;
    }
    [self.searchController.view removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)backToPerfectInfoViewWithSelectedItem:(NSDictionary *)selectedItem {
    
    PerfectInfoController *perfectInfoVc = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];

    NSString *name       = [selectedItem objectForKey:@"name"];
    NSString *selectedId = [selectedItem objectForKey:@"id"];
    
    if (self.searchModel == SchoolSearchModel) {
        
        perfectInfoVc.school    = name;
        perfectInfoVc.school_id = selectedId;
        
    }else {
        
        perfectInfoVc.academy    = name;
        perfectInfoVc.academy_id = selectedId;
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
