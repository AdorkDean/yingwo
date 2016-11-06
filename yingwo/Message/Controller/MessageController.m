//
//  MessageController.m
//  yingwo
//
//  Created by apple on 2016/11/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "MessageController.h"
#import "CommentController.h"
#import "MessageDetailController.h"

#import "FavorController.h"

#import "SMPagerTabView.h"

@interface MessageController ()<SMPagerTabViewDelegate,MessageControllerDelegate>

@property (nonatomic, strong) SMPagerTabView    *messagePgaeView;
@property (nonatomic, strong) UIView            *messageSectionView;

@property (nonatomic, strong) NSMutableArray    *catalogVcArr;

@property (nonatomic, strong) CommentController *commentVc;
@property (nonatomic, strong) FavorController   *favorVc;

@property (nonatomic, strong) MessageEntity     *messageEntity;

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
}


#pragma mark MessageControllerDelegate

- (void)didSelectMessageWith:(MessageEntity *)model{
    
    self.messageEntity = model;
    
    if (model.type == MessageTieZi) {
        
        [self performSegueWithIdentifier:@"messageDetail" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"detail" sender:self];
    }
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass:[MessageDetailController class]]) {
        if ([segue.identifier isEqualToString:@"messageDetail"]) {
            
            MessageDetailController *messageDetailVc = segue.destinationViewController;
            messageDetailVc.model                    = self.messageEntity;

            
        }
    }
    else
    {
        DetailController *detailVc = segue.destinationViewController;
        detailVc.model             = self.messageEntity;

    }
    
}



@end
