//
//  MessageController.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessageController.h"
#import "CommentController.h"
#import "FavorController.h"
#import "MessageDetailController.h"

@interface MessageController ()<SMPagerTabViewDelegate,MessageControllerDelegate>

@property (nonatomic, strong) UIView            *messageSectionView;

@property (nonatomic, strong) NSMutableArray    *catalogVcArr;

@property (nonatomic, strong) CommentController *commentVc;
@property (nonatomic, strong) FavorController   *favorVc;

@property (nonatomic, strong) MessageEntity     *messageEntity;

@property (nonatomic, strong) TieZi             *tieZiModel;

@end

@implementation MessageController

- (SMPagerTabView *)topicPgaeView {
    if (_messagePgaeView == nil) {
        
        _messagePgaeView          = [[SMPagerTabView alloc] initWithFrame:CGRectMake(0,
                                                                                   40,
                                                                                   SCREEN_WIDTH,
                                                                                   SCREEN_HEIGHT)];
        _messagePgaeView.delegate = self;
        
        
        [self.catalogVcArr addObject:self.commentVc];
        [self.catalogVcArr addObject:self.favorVc];
        
        //开始构建UI
        [_messagePgaeView buildUI];
        //起始选择一个tab
        [_messagePgaeView selectTabWithIndex:0 animate:NO];
    }
    return _messagePgaeView;
}

- (UIView *)messageSectionView {
    if (_messageSectionView == nil) {
        _messageSectionView = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                                     0,
                                                                     SCREEN_WIDTH,
                                                                     40)];
        
        [_messageSectionView addSubview:self.topicPgaeView.tabView];
    }
    return _messageSectionView;
}

- (CommentController *)commentVc {
    
    if (_commentVc == nil) {
        _commentVc          = [[CommentController alloc] init];
        _commentVc.delegate = self;
    }
    return _commentVc;
    
}

- (FavorController *)favorVc {
    
    if (_favorVc == nil) {
        _favorVc          = [[FavorController alloc] init];
        _favorVc.delegate = self;
    }
    return _favorVc;
    
}

- (NSMutableArray *)catalogVcArr {
    if (_catalogVcArr == nil) {
        _catalogVcArr = [[NSMutableArray alloc] init];
    }
    return _catalogVcArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.topicPgaeView];
    [self.view addSubview:self.messageSectionView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];    
    self.title = @"我的消息";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DBPagerTabView Delegate
- (NSUInteger)numberOfPagers:(SMPagerTabView *)view {
    
    return [self.catalogVcArr count];
}
- (UIViewController *)pagerViewOfPagers:(SMPagerTabView *)view indexOfPagers:(NSUInteger)number {
    
    UIViewController *vc = self.catalogVcArr[number];
    
    return vc;
}

- (void)whenSelectOnPager:(NSUInteger)number {
    
    NSLog(@"页面 %lu",(unsigned long)number);
    
    if (number == 0) {
        UIView *redDot = [self.messagePgaeView.tabRedDots objectAtIndex:0];
        if (redDot.hidden == NO) {
            [self.commentVc.tableView.mj_header beginRefreshing];
            [self.messagePgaeView hideRedDotWithIndex:0];
        }
    }

    if (number == 1) {
        
        UIView *redDot = [self.messagePgaeView.tabRedDots objectAtIndex:1];
        if (redDot.hidden == NO) {
            [self.favorVc.tableView.mj_header beginRefreshing];
            [self.messagePgaeView hideRedDotWithIndex:1];
        }
    }
}

#pragma mark MessageControllerDelegate

- (void)didSelectMessageWith:(MessageEntity *)model{
    
    self.messageEntity = model;
    TieZi *tieZiModel = [[TieZi alloc] init];
    tieZiModel.tieZi_id = self.messageEntity.post_detail_id;
    tieZiModel.topic_id = self.messageEntity.post_detail_topic_id;
    tieZiModel.user_id  = self.messageEntity.post_detail_user_id;
    tieZiModel.create_time = self.messageEntity.post_detail_create_time;
    tieZiModel.topic_title = self.messageEntity.post_detail_topic_title;
    tieZiModel.user_name = self.messageEntity.post_detail_user_name;
    tieZiModel.content = self.messageEntity.post_detail_content;
    tieZiModel.img = self.messageEntity.post_detail_img;
    tieZiModel.user_face_img = self.messageEntity.post_detail_user_face_img;
    tieZiModel.like_cnt = self.messageEntity.post_detail_like_cnt;
    tieZiModel.reply_cnt = self.messageEntity.post_detail_reply_cnt;
    tieZiModel.user_post_like = self.messageEntity.post_detail_user_post_like;
    tieZiModel.imageUrlArrEntity = self.messageEntity.post_detail_imageUrlArrEntity;

    self.tieZiModel = tieZiModel;
    
    [self performSegueWithIdentifier:@"detail" sender:self];

    
//    if (([model.source_type isEqualToString:@"POST"] && model.type == 0) ||
//        [model.follow_type isEqualToString:@"LIKE_POST"]) {
//        
//        [self performSegueWithIdentifier:@"detail" sender:self];
//
//    }
//    else
//    {
//        [self performSegueWithIdentifier:@"messageDetail" sender:self];
//
//    }
    
}

- (void)didSelectHeadImageWith:(MessageEntity *)model {

    self.messageEntity = model;
    [self performSegueWithIdentifier:@"ta" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[MessageDetailController class]]) {
        if ([segue.identifier isEqualToString:@"messageDetail"]) {
            
            MessageDetailController *messageDetailVc = segue.destinationViewController;
            messageDetailVc.model                    = self.messageEntity;

        }
    }else if ([segue.destinationViewController isKindOfClass:[DetailController class]]) {
        
        if([segue.identifier isEqualToString:@"detail"]) {
        DetailController *detailVc = segue.destinationViewController;
        detailVc.model             = self.tieZiModel;
            
        }
    }else if ([segue.destinationViewController isKindOfClass:[TAController class]]) {
        
        if ([segue.identifier isEqualToString:@"ta"]) {
            TAController *taVc = segue.destinationViewController;
            taVc.ta_id = [self.messageEntity.follow_user_id intValue];
        }
    }
    
}



@end
