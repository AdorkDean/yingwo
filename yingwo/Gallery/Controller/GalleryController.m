//
//  ViewController.m
//  YWGalleryView
//
//  Created by apple on 2017/1/4.
//  Copyright © 2017年 wangxiaofa. All rights reserved.
//

#import "GalleryController.h"

#import "YWGalleryCellOfNone.h"
#import "YWGalleryCellOfOne.h"
#import "YWGalleryCellOfTwo.h"
#import "YWGalleryCellOfThree.h"
#import "YWGalleryCellOfFour.h"
#import "YWGalleryCellOfSix.h"
#import "YWGalleryCellOfNine.h"
#import "YWGalleryCellOfMoreNine.h"

#import "YWGalleryView.h"


@interface GalleryController ()<UITableViewDelegate,UITableViewDataSource,YWGalleryViewDelegate,YWGalleryCellBottomViewDelegate,YWTitleDelegate,YWGalleryCellBottomViewDelegate,YWAlertButtonProtocol,YWSpringButtonDelegate, TTTAttributedLabelDelegate>

@property (nonatomic, strong) UIAlertController *alertView;
@property (nonatomic, strong) UIAlertController *compliantAlertView;

//点击查看话题内容
@property (nonatomic, assign) int               tap_topic_id;
//点击查看用户详情
@property (nonatomic, assign) int               tap_ta_id;
//推送到帖子详情
@property (nonatomic, assign) int               push_detail_id;

@property (nonatomic, assign) int               badgeCount;

@property (nonatomic, strong) YWPhotoCotentView *contentView;

@property (nonatomic, strong) NSArray           *images;

@property (nonatomic, strong) UILabel           *tieziLabel;

@end

@implementation GalleryController

- (UITableView *)tableView {
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
                                                                   SCREEN_WIDTH,
                                                                   SCREEN_HEIGHT)
                                                  style:UITableViewStylePlain];
        _tableView.delegate            = self;
        _tableView.dataSource          = self;
        _tableView.backgroundColor     = [UIColor clearColor];
        _tableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 50;

        [_tableView registerClass:[YWGalleryCellOfNone class] forCellReuseIdentifier:@"noImageCell"];
        [_tableView registerClass:[YWGalleryCellOfOne class] forCellReuseIdentifier:@"oneImageCell"];
        [_tableView registerClass:[YWGalleryCellOfTwo class] forCellReuseIdentifier:@"twoImageCell"];
        [_tableView registerClass:[YWGalleryCellOfThree class] forCellReuseIdentifier:@"threeImageCell"];
        [_tableView registerClass:[YWGalleryCellOfFour class] forCellReuseIdentifier:@"fourImageCell"];
        [_tableView registerClass:[YWGalleryCellOfSix class] forCellReuseIdentifier:@"sixImageCell"];
        [_tableView registerClass:[YWGalleryCellOfNine class] forCellReuseIdentifier:@"nineImageCell"];
        [_tableView registerClass:[YWGalleryCellOfMoreNine class] forCellReuseIdentifier:@"moreNineImageCell"];

        
    }
    
    
    
    return _tableView;
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


- (GalleryViewModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[GalleryViewModel alloc] init];
    }
    return _viewModel;
}

- (TieZi *)model {
    if (_model == nil) {
        
        _model = [[TieZi alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.tieZiList.count;
}

- (YWGalleryBaseCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.model               = [self.tieZiList objectAtIndex:indexPath.row];

    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.model];

    YWGalleryBaseCell *cell  = [tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                               forIndexPath:indexPath];

    cell.selectionStyle             = UITableViewCellSelectionStyleNone;

    [self.viewModel setupModelOfCell:cell
                               model:self.tieZiList[indexPath.row]];
    
    cell.bottemView.delegate        = self;
    cell.titleView.title.delegate   = self;
    cell.bottemView.favour.delegate = self;
    
    //回调block实现点击图片放大
    cell.middleView.imageTapBlock = ^(UIImageView *imageView, ImageViewItem *imagesItem) {
            
        YWGalleryView *galleryView  = [[YWGalleryView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        galleryView.backgroundColor = [UIColor blackColor];
        galleryView.delegate = self;
        
        [galleryView setImagesItem:imagesItem showAtIndex:imageView.tag-1];
        [self.view.window.rootViewController.view addSubview:galleryView];
    };
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    self.model = self.tieZiList[indexPath.row];
    
    [self performSegueWithIdentifier:@"detail" sender:self];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [self.viewModel idForRowByModel:self.tieZiList[indexPath.row]];
    
    return [tableView fd_heightForCellWithIdentifier:cellIdentifier
                                    cacheByIndexPath:indexPath
                                       configuration:^(id cell) {
                                           
                                           [self.viewModel setupModelOfCell:cell
                                                                      model:self.tieZiList[indexPath.row]];
                                       }];
    
}


#pragma YWSpringButtonDelegate

- (void)didSelectSpringButtonOnView:(UIView *)view postId:(int)postId model:(int)model {
    
    
    //点赞数量的改变，这里要注意的是，无论是否可以网络请求，本地数据都要显示改变
    UILabel *favour = [view viewWithTag:101];
    
    NSDictionary *parameter = @{@"post_id":@(postId),@"value":@(model)};
    
    WeakSelf(self);
    
    [self.viewModel setLikeSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            [weakself setLikeCountWithModel:model countLabel:favour saveWithId:postId];
            
        }
        
        
    } likeFailureBlock:^(id likeFailureBlock) {
        
    }];
    
    RequestEntity *requestEntity = [[RequestEntity alloc] init];
    requestEntity.URLString = TIEZI_LIKE_URL;
    requestEntity.parameter = parameter;
    
    [self.viewModel requestForLikeTieZiWithRequest:requestEntity];
    
}

- (void)setLikeCountWithModel:(Boolean)model countLabel:(UILabel *)label saveWithId:(int)postId{
    
    int count       = [label.text intValue];

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
        label.text = [NSString stringWithFormat:@"%d",count];
    }else {
        label.text = [NSString stringWithFormat:@"%d",0];
    }
    
}


#pragma mark YWGalleryCellBottomViewDelegate
- (void)didSelecteMessageWithBtn:(UIButton *)message {
    
    YWGalleryBaseCell *selectedCell = (YWGalleryBaseCell *)message.superview.superview.superview.superview;
    NSIndexPath *indexPath                = [self.tableView indexPathForCell:selectedCell];
    self.model                            = self.tieZiList[indexPath.row];
    
    [self performSegueWithIdentifier:@"detail" sender:self];
    
}

- (void)didSelectBottomView:(YWGalleryCellBottomView *)bottomView {
    
    self.tap_ta_id = bottomView.user_id;
    [self performSegueWithIdentifier:@"ta" sender:self];
}

#pragma mark YWAlertButtonProtocol

- (void)seletedAlertView:(UIAlertController *)alertView
               onMoreBtn:(UIButton *)more
                 atIndex:(NSInteger)index {
    
    if (index == 0) {
        [self copyTiZiText:more];
        
    }else if (index == 1) {
        self.alertView = alertView;
        [self showCompliantAlertView];
        
    }else if (index == 2) {
        [self showDeleteAlertView:more];
        
    }

    
}

#pragma mark YWTitleDelegate

- (void)didSelectLabel:(YWTitle *)label {
    
    
    self.tap_topic_id = label.topic_id;
    
    [self performSegueWithIdentifier:@"topic" sender:self];
    
}


#pragma mark segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    //查看贴子详情
    if ([segue.destinationViewController isKindOfClass:[DetailController class]])
    {
        
        if ([segue.identifier isEqualToString:@"detail"]) {
            DetailController *detailVc = segue.destinationViewController;
            detailVc.model             = self.model;
        }
    }
    
    //查看所有话题
    else if ([segue.destinationViewController isKindOfClass:[TopicController class]])
    {
        if ([segue.identifier isEqualToString:@"topic"]) {
            TopicController *topicVc = segue.destinationViewController;
            topicVc.topic_id         = self.tap_topic_id;
            
        }
        
    }else if ([segue.destinationViewController isKindOfClass:[TAController class]])
    {
        if ([segue.identifier isEqualToString:@"ta"]) {
            TAController *taVc = segue.destinationViewController;
            taVc.ta_id         = self.tap_ta_id;
        }
    }
}


#pragma mark 网络监测
/**
 *  网路监测
 */
- (void)judgeNetworkStatus {
    [YWNetworkTools networkStauts];
}

#pragma mark private method

/**
 *  举报弹出框
 */
- (void)showCompliantAlertView {
    [self.view.window.rootViewController presentViewController:self.compliantAlertView
                                                      animated:YES
                                                    completion:nil];
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
    
    [self.view.window.rootViewController presentViewController:alertController
                                                      animated:YES
                                                    completion:nil];
}

/**
 *  删除帖子
 */
- (void)deleteTieZi:(UIButton *)more {
    
    YWGalleryBaseCell *selectedCell = (YWGalleryBaseCell *)more.superview.superview.superview.superview;
    NSIndexPath *indexPath          = [self.tableView indexPathForCell:selectedCell];
    TieZi *selectedModel            = self.tieZiList[indexPath.row];
    
    
    //网络请求
    NSDictionary *parameter = @{@"post_id":@(selectedModel.tieZi_id)};
    
    RequestEntity *request = [[RequestEntity alloc] init];
    
    request.URLString = TIEZI_DEL_URL;
    request.parameter = parameter;
    
    WeakSelf(self);
    
    [self.viewModel setDeleteSuccessBlock:^(StatusEntity *statusEntity) {
        
        if (statusEntity.status == YES) {
            
            [weakself deleteTieZiByIndexPath:indexPath];

            [SVProgressHUD showSuccessStatus:@"删除成功" afterDelay:1.0];
            
        }else if (statusEntity.status == NO){
            
            [SVProgressHUD showSuccessStatus:@"删除失败" afterDelay:1.0];
        }

        
    } failureBlock:^(id deleteFailureBlock) {
        
    }];
    
    [self.viewModel deleteTieZiWithRequest:request];
    
}

- (void)deleteTieZiByIndexPath:(NSIndexPath *)indexPath {
    
    //删除该行数据源
    [self.tieZiList removeObjectAtIndex:indexPath.row];
    //将该行从视图中移除
    [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
    
}

/**
 *  复制帖子文字内容
 */
- (void)copyTiZiText:(UIButton *)more {
    UIPasteboard *pasteboard              = [UIPasteboard generalPasteboard];
    //复制内容 获取帖子文字内容
    YWGalleryBaseCell *selectedCell = (YWGalleryBaseCell *)more.superview.superview.superview.superview;
    NSString *copyString            = selectedCell.contentText.text;
    //复制到剪切板
    pasteboard.string               = copyString;

    [SVProgressHUD showSuccessStatus:@"已复制" afterDelay:HUD_DELAY];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
