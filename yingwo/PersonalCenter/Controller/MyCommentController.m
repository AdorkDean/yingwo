//
//  MyCommentController.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/25.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MyCommentController.h"
#import "DetailController.h"

#import "YWMessageCell.h"
#import "YWImageMessageCell.h"

#import "MessageViewModel.h"
#import "DetailViewModel.h"

#import "MessageEntity.h"

@interface MyCommentController ()<UITableViewDelegate,UITableViewDataSource,YWMessageCellDelegate>

@property (nonatomic, strong) UITableView       *tableView;

@property (nonatomic, strong) MessageViewModel  *viewModel;
@property (nonatomic, strong) DetailViewModel   *detailViewModel;

@property (nonatomic, strong) RequestEntity     *requestEntity;
@property (nonatomic, strong) MessageEntity     *messageEntity;

@property (nonatomic, strong) NSMutableArray    *messageArr;
@property (nonatomic, strong) NSIndexPath       *selectedIndexPath;

@end

static NSString *noImageCellidentifier = @"noImage";
static NSString *imageCellidentifier   = @"hasImage";

static int start_id = 0;

@implementation MyCommentController

-(UITableView *)tableView {
    if (_tableView == nil) {
        
        _tableView                                  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate                         = self;
        _tableView.dataSource                       = self;
        _tableView.separatorStyle                   = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor                  = [UIColor clearColor];
        _tableView.contentInset                     = UIEdgeInsetsMake(5, 0, 75, 0);
        
        [_tableView registerClass:[YWMessageCell class] forCellReuseIdentifier:noImageCellidentifier];
        [_tableView registerClass:[YWImageMessageCell class] forCellReuseIdentifier:imageCellidentifier];
    }
    return _tableView;
}

-(MessageViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[MessageViewModel alloc] init];
    }
    return _viewModel;
}

-(DetailViewModel *)detailViewModel {
    if (_detailViewModel == nil) {
        _detailViewModel = [[DetailViewModel alloc] init];
    }
    return _detailViewModel;
}

-(RequestEntity *)requestEntity {
    if (_requestEntity == nil) {
        _requestEntity = [[RequestEntity alloc] init];
        _requestEntity.requestUrl = MY_REPLY_AND_COMMENT_URL;
        _requestEntity.start_id = 0;
    }
    return _requestEntity;
}

- (NSMutableArray *)messageArr {
    if (_messageArr == nil) {
        _messageArr = [[NSMutableArray alloc] init];
    }
    return _messageArr;
}

-(void)layoutSubviews {
    
    [self.view addSubview:self.tableView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self layoutSubviews];
    
    __weak MyCommentController *weakSelf = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.requestEntity.start_id = start_id;
        
        [weakSelf loadDataWithRequestEntity:self.requestEntity];
    }];
    
    self.tableView.mj_footer    = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf loadMoreDataWithRequestEntity:self.requestEntity];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"我的评论";
    self.navigationItem.leftBarButtonItem   = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                                               style:UIBarButtonItemStylePlain
                                                                              target:self
                                                                              action:@selector(backToPersonCenterView)];
    
    
}


/**
 *  下拉刷新
 */
- (void)loadDataWithRequestEntity:(RequestEntity *)requestEntity {
    
    //网络连接错误的情况下停止刷新
    if ([YWNetworkTools networkStauts] == NO) {
        [self.tableView.mj_header endRefreshing];
    }
    
    [self loadForType:1 RequestEntity:requestEntity];
    
    [self.tableView.mj_footer resetNoMoreData];
}

/**
 *  上拉刷新
 */
- (void)loadMoreDataWithRequestEntity:(RequestEntity *)requestEntity {
    //网络连接错误的情况下停止刷新
    if ([YWNetworkTools networkStauts] == NO) {
        [self.tableView.mj_footer endRefreshing];
    }
    
    [self loadForType:2 RequestEntity:requestEntity];
}

/**
 *  下拉、上拉刷新
 *
 *  @param type  上拉or下拉
 *  @param model 刷新类别：所有帖、新鲜事、好友动态、关注的话题
 */
- (void)loadForType:(int)type RequestEntity:(RequestEntity *)requestEntity {
    
    @weakify(self);
    [[self.viewModel.fecthTieZiEntityCommand execute:requestEntity] subscribeNext:^(NSArray *messages) {
        @strongify(self);
        
        //这里是倒序获取前10个
        if (messages.count > 0) {
            
            if (type == 1) {
                //   NSLog(@"tiezi:%@",tieZis);
                self.messageArr = [messages mutableCopy];
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
            }else {
                
                [self.messageArr addObjectsFromArray:messages];
                [self.tableView.mj_footer endRefreshing];
                [self.tableView reloadData];
            }
            
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            MessageEntity *lastObject   = [messages objectAtIndex:messages.count-1];
            self.requestEntity.start_id = lastObject.message_id;
            
        }
        else
        {
            //没有任何数据
            if (messages.count == 0 && requestEntity.start_id == 0) {
                
                self.messageArr = nil;
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                
            }
            
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
    
}

#pragma mark - tableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    YWMessageCell *cell      = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                               forIndexPath:indexPath];
    [self.viewModel setupModelOfCell:cell model:self.messageArr[indexPath.row]];
    
    cell.delegate            = self;
    cell.messageEntity       = self.messageArr[indexPath.row];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.messageArr[indexPath.row]];
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.messageArr[indexPath.row]];
                                       }];
    
}

//查看回复或评论的贴子
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if ([self.delegate respondsToSelector:@selector(didSelectMessageWith:)]) {
//        
//        MessageEntity *messageEntity = [self.messageArr objectAtIndex:indexPath.row];
//        messageEntity.type           = MessageTieZi;
//        
//        NSLog(@"source_type:%@",messageEntity.source_type);
//        [self.delegate didSelectMessageWith:messageEntity];
//    }
    self.messageEntity = [self.messageArr objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"detail" sender:self];
    
}

/**
 *  查看原贴
 *
 *  @return
 */
#pragma mark YWMessageCellDelegate

- (void)didSelectedTieZi:(MessageEntity *)messageEntity {
    
    self.messageEntity = messageEntity;
    
    [self performSegueWithIdentifier:@"detail" sender:self];
    
}

-(void)didSelectedDeleteBtn:(UIButton *)deleteBtn withEntity:(MessageEntity *)messageEntity {
    
    if ([deleteBtn.superview.superview.superview.superview isKindOfClass:[YWMessageCell class]]) {
        YWMessageCell *selectedCell = (YWMessageCell *)deleteBtn.superview.superview.superview.superview;
        self.selectedIndexPath = [self.tableView indexPathForCell:selectedCell];
    }
    self.messageEntity = messageEntity;
    [self showDeleteAlertView];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailController class]]) {
        if ([segue.identifier isEqualToString:@"detail"]) {
            DetailController *detailVc = segue.destinationViewController;
            detailVc.model             = self.messageEntity;
        }
    }
}

/**
 *  删除警告
 */
- (void)showDeleteAlertView {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"操作不可恢复，确认删除吗？"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [self deleteReplyOrComment];
                                                        }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel handler:nil]];
    
    alertController.view.tintColor = [UIColor blackColor];
    
    [self.view.window.rootViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}

- (void)deleteReplyOrComment {
    
    //网络请求
    if ([self.messageEntity.follow_type isEqualToString:@"REPLY"]) {
        
        NSDictionary *paramaters = @{@"reply_id":@(self.messageEntity.reply_id)};
        //必须要加载cookie，否则无法请求
        [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
        
        [self.detailViewModel deleteReplyWithUrl:TIEZI_REPLY_DEL_URL
                                      paramaters:paramaters
                                         success:^(StatusEntity *statusEntity) {
                                             if (statusEntity.status == YES) {
                                                 
                                                 //删除该行跟帖数据源
                                                                                              [self.messageArr removeObjectAtIndex:self.selectedIndexPath.row];
                                                                                              //将该行从视图中移除
                                                                                              [self.tableView deleteRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                 [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:HUD_DELAY];
                                             }else if(statusEntity.status == NO){
                                                 
                                                 [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:HUD_DELAY];
                                             }
                                         }
                                         failure:^(NSString *error) {
                                             NSLog(@"error:%@",error);
                                         }];
        
    }else if([self.messageEntity.follow_type isEqualToString:@"COMMENT"]) {
        
        NSDictionary *paramaters = @{@"comment_id":@(self.messageEntity.reply_id)};
        
        //必须要加载cookie，否则无法请求
        [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
        
        [self.detailViewModel deleteCommentWithUrl:TIEZI_COMMENT_DEL_URL
                                        paramaters:paramaters
                                           success:^(StatusEntity *statusEntity) {
                                               if (statusEntity.status == YES) {
                                                   
                                                   //删除该行跟帖数据源
                                                   [self.messageArr removeObjectAtIndex:self.selectedIndexPath.row];
                                                   //将该行从视图中移除
                                                   [self.tableView deleteRowsAtIndexPaths:@[self.selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                                                   [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:HUD_DELAY];
                                               }else if(statusEntity.status == NO){
                                                   
                                                   [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:HUD_DELAY];
                                               }
                                           }
                                           failure:^(NSString *error) {
                                               NSLog(@"error:%@",error);
                                           }];

    }
    

}

//返回个人中心界面
- (void)backToPersonCenterView {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
