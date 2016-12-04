//
//  YWTaTieziView.m
//  yingwo
//
//  Created by 王世杰 on 2016/10/26.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWTaTieziView.h"
#import "TieZi.h"
#import "DetailController.h"
#import "TopicController.h"


#import "YWHomeTableViewCellNoImage.h"
#import "YWHomeTableViewCellOneImage.h"
#import "YWHomeTableViewCellTwoImage.h"
#import "YWHomeTableViewCellThreeImage.h"
#import "YWHomeTableViewCellFourImage.h"
#import "YWHomeTableViewCellSixImage.h"
#import "YWHomeTableViewCellNineImage.h"
#import "YWHomeTableViewCellMoreNineImage.h"

//刷新的初始值
static int start_id = 0;

@protocol  YWHomeCellMiddleViewBaseProtocol;
@interface YWTaTieziView()<UITableViewDataSource,UITableViewDelegate,YWHomeCellMiddleViewBaseProtocol,GalleryViewDelegate,YWAlertButtonProtocol,YWSpringButtonDelegate,YWLabelDelegate, YWHomeCellBottomViewDelegate,TTTAttributedLabelDelegate>


@property (nonatomic, strong) TieZi             *model;
@property (nonatomic, strong) RequestEntity     *requestEntity;
@property (nonatomic, strong) UIAlertController *alertView;
@property (nonatomic, strong) UIAlertController *compliantAlertView;

@property (nonatomic, strong) NSMutableArray    *tieZiList;
//保存首页的小图的数组(UIImageView数组)
@property (nonatomic, strong) NSMutableArray    *cellNewImageArr;
@property (nonatomic,strong ) NSArray           *images;

@property (nonatomic, strong) GalleryView       *galleryView;
@property (nonatomic,assign ) CGFloat           navgationBarHeight;



@end

@implementation YWTaTieziView

- (TieZi *)model {
    if (_model == nil) {
        
        _model = [[TieZi alloc] init];
    }
    return _model;
}

- (TieZiViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[TieZiViewModel alloc] init];
    }
    return _viewModel;
}

- (RequestEntity *)requestEntity {
    if (_requestEntity  == nil) {
        _requestEntity            = [[RequestEntity alloc] init];
        //贴子请求url
        _requestEntity.requestUrl = MY_TIEZI_URL;
        //请求的事新鲜事
        _requestEntity.topic_id   = AllThingModel;
        //偏移量开始为0
        _requestEntity.start_id  = start_id;
    }
    return _requestEntity;
}

- (NSMutableArray *)tieZiList {
    if (_tieZiList == nil) {
        _tieZiList = [[NSMutableArray alloc] init];
    }
    return _tieZiList;
}

- (NSMutableArray *)cellNewImageArr {
    if (_cellNewImageArr == nil) {
        _cellNewImageArr = [[NSMutableArray alloc] init];
    }
    return _cellNewImageArr;
}

- (UIAlertController *)compliantAlertView {
    if (_compliantAlertView == nil) {
        
        _compliantAlertView = [UIAlertController alertControllerWithTitle:@"举报"
                                                                  message:nil
                                                           preferredStyle:UIAlertControllerStyleActionSheet];
        
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"广告"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"色情"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"反动"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"其他"
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        [_compliantAlertView addAction:[UIAlertAction actionWithTitle:@"取消"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                                  
                                                              }]];
        
        _compliantAlertView.view.tintColor = [UIColor blackColor];
        
    }
    return _compliantAlertView;
}

-(NSMutableArray *)rowHeightArr {
    if (_rowHeightArr == nil) {
        _rowHeightArr = [[NSMutableArray alloc] init];
        _rowHeightArr = [NSMutableArray arrayWithCapacity:2];
    }
    return _rowHeightArr;
}

- (GalleryView *)galleryView {
    if (_galleryView == nil) {
        _galleryView                 = [[GalleryView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _galleryView.backgroundColor = [UIColor blackColor];
        _galleryView.delegate        = self;
    }
    return _galleryView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor                = [UIColor whiteColor];
        UILabel *taTopicLabel               = [[UILabel alloc] init];
        taTopicLabel.text                   = @"TA的贴子";
        taTopicLabel.textColor              = [UIColor colorWithHexString:THEME_COLOR_4];
        taTopicLabel.font                   = [UIFont systemFontOfSize:SCREEN_HEIGHT / 667 * 16];
        
        UILabel *moreLabel                  = [[UILabel alloc] init];
        moreLabel.text                      = @"更多";
        moreLabel.textColor                 = [UIColor colorWithHexString:THEME_COLOR_4];
        moreLabel.font                      = [UIFont systemFontOfSize:SCREEN_HEIGHT / 667 * 16];
        
        UIView *separator                   = [[UIView alloc] init];
        separator.backgroundColor           = [UIColor colorWithHexString:@"#F5F5F5"];

        
        UIImageView *rightImageView         = [[UIImageView alloc] init];
        rightImageView.image                = [UIImage imageNamed:@"Row"];
        rightImageView.contentMode          = UIViewContentModeScaleAspectFill;
        
        [self addSubview:taTopicLabel];
        [self addSubview:rightImageView];
        [self addSubview:separator];
        [self addSubview:moreLabel];
        
        [taTopicLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(10);
            make.left.equalTo(self).offset(10);
        }];
        
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-10);
            make.centerY.equalTo(taTopicLabel);
        }];
        
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(taTopicLabel.mas_bottom).offset(5);
            make.right.width.equalTo(self);
            make.height.equalTo(@1);
        }];
        
        [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(rightImageView.mas_left).offset(-10);
            make.top.equalTo(taTopicLabel);
        }];
        
        [self loadData];
        
    }
    return self;
}

/**
 *  cell identifier
 */
static NSString *YWHomeCellNoImageIdentifier       = @"noImageCell";
static NSString *YWHomeCellOneImageIdentifier      = @"oneImageCell";
static NSString *YWHomeCellTwoImageIdentifier      = @"twoImageCell";
static NSString *YWHomeCellThreeImageIdentifier    = @"threeImageCell";
static NSString *YWHomeCellFourImageIdentifier     = @"fourImageCell";
static NSString *YWHomeCellSixImageIdentifier      = @"sixImageCell";
static NSString *YWHomeCellNineImageIdentifier     = @"nineImageCell";
static NSString *YWHomeCellMoreNineImageIdentifier = @"moreNineImageCell";


- (UITableView *)homeTableview {
    if (_homeTableview == nil) {
        _homeTableview                 = [[UITableView alloc] initWithFrame:self.bounds
                                                                      style:UITableViewStyleGrouped];
        _homeTableview.delegate        = self;
        _homeTableview.dataSource      = self;
        _homeTableview.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        _homeTableview.separatorColor  = [UIColor colorWithHexString:@"#F5F5F5"];
        _homeTableview.separatorInset  = UIEdgeInsetsMake(0, 0, 0, 0);
        _homeTableview.backgroundColor = [UIColor clearColor];
        _homeTableview.scrollEnabled   = NO;
        
        [_homeTableview registerClass:[YWHomeTableViewCellNoImage class]
               forCellReuseIdentifier:YWHomeCellNoImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellOneImage class]
               forCellReuseIdentifier:YWHomeCellOneImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellTwoImage class]
               forCellReuseIdentifier:YWHomeCellTwoImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellThreeImage class]
               forCellReuseIdentifier:YWHomeCellThreeImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellFourImage class]
               forCellReuseIdentifier:YWHomeCellFourImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellSixImage class]
               forCellReuseIdentifier:YWHomeCellSixImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellNineImage class]
               forCellReuseIdentifier:YWHomeCellNineImageIdentifier];
        [_homeTableview registerClass:[YWHomeTableViewCellMoreNineImage class]
               forCellReuseIdentifier:YWHomeCellMoreNineImageIdentifier];
        
    }
    return _homeTableview;
}

/**
 *  删除警告
 */
- (void)showDeleteAlertView:(UIButton *)more {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告"
                                                                             message:@"操作不可恢复，确认删除吗？"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确认"
                                                        style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                                            [self deleteTieZi:more];
                                                        }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleCancel
                                                      handler:nil]];
    
    alertController.view.tintColor = [UIColor blackColor];
    
    [self.window.rootViewController presentViewController:alertController
                                                 animated:YES
                                               completion:nil];
    
}

/**
 *  删除帖子
 */
- (void)deleteTieZi:(UIButton *)more {
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)more.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
    TieZi *selectedModel                  = self.tieZiList[indexPath.row];
    
    int postId = selectedModel.tieZi_id;
    //网络请求
    NSDictionary *paramaters = @{@"post_id":@(postId)};
    
    //必须要加载cookie，否则无法请求
    [YWNetworkTools loadCookiesWithKey:LOGIN_COOKIE];
    
    [self.viewModel deleteTieZiWithUrl:TIEZI_DEL_URL
                            paramaters:paramaters
                               success:^(StatusEntity *statusEntity) {
                                   
                                   if (statusEntity.status == YES) {
                                       //删除该行数据源
                                       [self.tieZiList removeObjectAtIndex:indexPath.row];
                                       //将该行从视图中移除
                                       [self.homeTableview deleteRowsAtIndexPaths:@[indexPath]
                                                                 withRowAnimation:UITableViewRowAnimationFade];
                                       [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:1.0];
                                   }else if (statusEntity.status == NO){
                                       [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:1.0];
                                   }
                                   
                               } failure:^(NSString *error) {
                                   NSLog(@"error:%@",error);
                               }];
    
}

/**
 *  复制帖子文字内容
 */
- (void)copyTiZiText:(UIButton *)more {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    //复制内容 获取帖子文字内容
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)more.superview.superview.superview.superview;
    NSString *copyString = selectedCell.contentText.text;
    //复制到剪切板
    pasteboard.string = copyString;
    
    [SVProgressHUD showSuccessStatus:@"已复制" afterDelay:HUD_DELAY];
    
}

- (void)loadData {
    
    //偏移量开始为0
    self.requestEntity.start_id = start_id;
    
    @weakify(self);
    [[self.viewModel.fecthTieZiEntityCommand execute:self.requestEntity] subscribeNext:^(NSArray *tieZis) {
        @strongify(self);
        
        //这里是倒序获取前10个
        if (tieZis.count > 0) {
                self.tieZiList = [tieZis mutableCopy];
                [self.homeTableview reloadData];
                [self addSubview:self.homeTableview];
            //获得最后一个帖子的id,有了这个id才能向前继续获取model
            TieZi *lastObject           = [tieZis objectAtIndex:tieZis.count-1];
            self.requestEntity.start_id = lastObject.tieZi_id;
            
        }
        else
        {
            //没有任何数据
            if (tieZis.count == 0 && self.requestEntity.start_id == 0) {
                
                self.tieZiList = nil;
                [self.homeTableview reloadData];
                [self addSubview:self.homeTableview];
            }
            
//            [self.homeTableview.mj_footer endRefreshingWithNoMoreData];
        }
        
    } error:^(NSError *error) {
        NSLog(@"%@",error.userInfo);
    }];
}

#pragma mark YWAlertButtonProtocol

- (void)seletedAlertView:(UIAlertController *)alertView onMoreBtn:(UIButton *)more atIndex:(NSInteger)index{
    if (index == 0) {
        [self copyTiZiText:more];
        
    }else if (index == 1) {
        self.alertView = alertView;
        [self showCompliantAlertView];
        
    }else if (index == 2) {
        [self showDeleteAlertView:more];
        
    }
}

#pragma YWSpringButtonDelegate

- (void)didSelectSpringButtonOnView:(UIView *)view postId:(int)postId model:(int)model {
    
    //点赞数量的改变，这里要注意的是，无论是否可以网络请求，本地数据都要显示改变
    UILabel *favour = [view viewWithTag:101];
    __block int count       = [favour.text intValue];
        
    //网络请求
    NSDictionary *paramaters = @{@"post_id":@(postId),@"value":@(model)};
    
    [self.viewModel postTieZiLIkeWithUrl:TIEZI_LIKE_URL
                              paramaters:paramaters
                                 success:^(StatusEntity *statusEntity) {
                                     
                                     if (statusEntity.status == YES) {
                                         
                                         if (model == YES) {
                                             count ++;
                                             [self.viewModel saveLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                                         }
                                         else
                                         {
                                             count --;
                                             [self.viewModel deleteLikeCookieWithPostId:[NSNumber numberWithInt:postId]];
                                         }
                                         if (count >= 0) {
                                             favour.text = [NSString stringWithFormat:@"%d",count];
                                         }else {
                                             favour.text = [NSString stringWithFormat:@"%d",0];
                                         }
                                         
                                     }
                                     
                                 } failure:^(NSString *error) {
                                     
                                 }];
    
}


#pragma mark button action

/**
 *  举报弹出框
 */
- (void)showCompliantAlertView {
    [self.window.rootViewController presentViewController:self.compliantAlertView
                                                      animated:YES
                                                    completion:nil];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.tieZiList.count < 2) {
        if (self.tieZiList.count == 0) {
            UILabel *noTieziLabel               = [[UILabel alloc] init];
            noTieziLabel.text                   = @"TA还未发布过贴子哦~";
            noTieziLabel.font                   = [UIFont systemFontOfSize:14];
            noTieziLabel.textAlignment          = NSTextAlignmentCenter;
            noTieziLabel.textColor              = [UIColor colorWithHexString:THEME_COLOR_3];
            
            [self addSubview:noTieziLabel];
            
            [noTieziLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.centerY.equalTo(self);
            }];
        }
        return self.tieZiList.count;
    }else {
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    self.model                      = [self.tieZiList objectAtIndex:indexPath.row];
    NSString *cellIdentifier        = [self.viewModel idForRowByModel:self.model];
    YWHomeTableViewCellBase *cell   = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                      forIndexPath:indexPath];
    cell.selectionStyle             = UITableViewCellSelectionStyleNone;
    
    cell.labelView.title.delegate   = self;
    cell.middleView.delegate        = self;
    cell.bottemView.more.delegate   = self;
    cell.bottemView.favour.delegate = self;
    cell.bottemView.delegate        = self;
    cell.contentText.delegate       = self;
    
    [self.viewModel setupModelOfCell:cell model:self.model];
    cell.backgroundView.layer.cornerRadius      = 0;
//    cell.backgroundView.layer.frame             = CGRectMake(0, 0, self.width, cell.backgroundView.layer.frame.size.height);
    return cell;

}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark UITableViewDelegate 自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.model               = [self.tieZiList objectAtIndex:indexPath.row];
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.model];
    
    CGFloat rowHeight = [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                                 cacheByIndexPath:indexPath
                                                    configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.model];
                                       }];
    if (self.tieZiList.count != 1) {
        if (self.rowHeightArr.count < 2) {
            [self.rowHeightArr addObject:@(rowHeight)];
        }
    } else {
        if (self.rowHeightArr.count < 1) {
            [self.rowHeightArr addObject:@(rowHeight)];
        }
    }
    
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    self.model = [self.tieZiList objectAtIndex:indexPath.row];
//    
//    [self performSegueWithIdentifier:@"detail" sender:self];
    
}

#pragma mark YWHomeCellBottomViewDelegate
- (void)didSelecteMessageWithBtn:(UIButton *)message {
    
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)message.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
    self.model                            = self.tieZiList[indexPath.row];
    
    //点击跳转到详情里面
//    [self performSegueWithIdentifier:@"detail" sender:self];
}

#pragma mark AvatarImageView

- (void)showImage:(UIImageView *)avatarImageView WithImageViewArr:(NSArray *)imageViewArr{
    
//    [self.galleryView setImages:self.cellNewImageArr showAtIndex:avatarImageView.tag-1];
//    
//    [self.navigationController.view addSubview:self.galleryView];
}


#pragma mark - GalleryView Delegate

- (void)galleryView:(GalleryView *)galleryView didShowPageAtIndex:(NSInteger)pageIndex
{
}

- (void)galleryView:(GalleryView *)galleryView didSelectPageAtIndex:(NSInteger)pageIndex
{
    [self.galleryView removeImageView];
    
}

- (void)galleryView:(GalleryView *)galleryView removePageAtIndex:(NSInteger)pageIndex {
    self.galleryView = nil;
    
    //开启滑动手势
//    [self openSystemPopGestureRecognizer];
}

#pragma mark TTTAttributedLabelDelegate
-(void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    
    
//    YWWebViewController *webVc = [[YWWebViewController alloc] initWithURL:url];
    
//    [self.navigationController pushViewController:webVc animated:YES];
}


#pragma mark YWLabelDelegate

- (void)didSelectLabel:(YWLabel *)label {
    
    if (label.topic_id != 0) {
//        
//        self.tap_topic_id = label.topic_id;
//        
//        [self performSegueWithIdentifier:@"topic" sender:self];
        
    }
    
}


#define mark - YWHomeCellMiddleViewBaseProtocol

- (void)didSelectedAvatarImageViewOfMiddleView:(UIImageView *)imageView imageArr:(NSMutableArray *)imageViewArr {
    
    if (imageView.image == nil) {
        return;
    }
    
    YWHomeTableViewCellBase *selectedCell = (YWHomeTableViewCellBase *)imageView.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.homeTableview indexPathForCell:selectedCell];
    TieZi *selectedModel                  = self.tieZiList[indexPath.row];
    
    [self.cellNewImageArr removeAllObjects];
    
    [self covertRectFromOldImageViewArr:imageViewArr];
    
    [self.galleryView setImageViews:self.cellNewImageArr
              withImageUrlArrEntity:selectedModel.imageUrlArrEntity
                        showAtIndex:imageView.tag-1];
    
//    [self.navigationController.view addSubview:self.galleryView];
    
    
}

- (void)covertRectFromOldImageViewArr:(NSArray *)imageViewArr{
    
    for (int i = 0; i < imageViewArr.count; i ++) {
        
        //保存imageView在cell上的位置
        UIImageView *oldImageView = [imageViewArr objectAtIndex:i];
        
        //oldImageView有可能是空的，只是个占位imageView
        if (oldImageView.image == nil) {
            return;
        }
        UIImageView *newImageView = [[UIImageView alloc] init];
        newImageView.image        = oldImageView.image;
        newImageView.tag          = oldImageView.tag;
        newImageView.frame        = [oldImageView.superview convertRect:oldImageView.frame toView:self];
        newImageView.y            += self.navgationBarHeight;
        [self.cellNewImageArr addObject:newImageView];
        
    }
}

#pragma mark 网络监测
/**
 *  网路监测
 */
- (void)judgeNetworkStatus {
    [YWNetworkTools networkStauts];
}

@end








