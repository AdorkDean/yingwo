//
//  AnnounceController.m
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "AnnounceController.h"
#import "YWAnnounceTextView.h"
#import "AnnounceModel.h"
#import "YWKeyboardToolView.h"
#import "YWPhotoDisplayView.h"

@interface AnnounceController ()<LSYAlbumCatalogDelegate,ISEmojiViewDelegate,YWKeyboardToolViewProtocol>

@property (nonatomic, strong) YWAnnounceTextView *announceTextView;
@property (nonatomic, strong) YWKeyboardToolView *keyboardTooView;

@property (nonatomic, strong) UIBarButtonItem    *leftBarItem;
@property (nonatomic, strong) UIBarButtonItem    *rightBarItem;

@property (nonatomic, strong) YWPhotoDisplayView *photoDisplayView;

@property (nonatomic, strong) AnnounceModel      *viewModel;
@property (nonatomic, assign) UIImageView        *lastPhoto;
@property (nonatomic, assign) NSInteger          photoImagesCount;

@property (nonatomic, assign) BOOL               isRelease;

@end

@implementation AnnounceController

- (YWAnnounceTextView *)announceTextView {
    if (_announceTextView == nil ) {
        _announceTextView                             = [[YWAnnounceTextView alloc] init];
        _announceTextView.layer.masksToBounds         = YES;
        _announceTextView.layer.cornerRadius          = 10;
        _announceTextView.contentTextView.placeholder = @"分享身边有趣、有料、有用的校园新鲜事～";
        _announceTextView.keyboardToolView.delegate   = self;
        _announceTextView.contentTextView.font        = [UIFont systemFontOfSize:14];
        _announceTextView.contentTextView.maxHeight   = SCREEN_HEIGHT * 0.32;

    }
    return _announceTextView;
}

- (YWKeyboardToolView *)keyboardTooView {
    if (_keyboardTooView == nil) {
        _keyboardTooView          = [[YWKeyboardToolView alloc] init];
        
        [_keyboardTooView.returnKeyBoard addTarget:self
                                            action:@selector(resignKeyboard)
                                  forControlEvents:UIControlEventTouchUpInside];
        
        [_keyboardTooView.photo addTarget:self
                                   action:@selector(enterIntoAlbumsSelectPhotos)
                         forControlEvents:UIControlEventTouchUpInside];

        _keyboardTooView.delegate = self;
    }
    return _keyboardTooView;
}

- (UIBarButtonItem *)rightBarItem {
    if (_rightBarItem == nil) {
        _rightBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"release"]
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(releaseContent)];
    }
    return _rightBarItem;
}

- (UIBarButtonItem *)leftBarItem {
    if (_leftBarItem == nil) {
        _leftBarItem = [[UIBarButtonItem alloc ]initWithImage:[UIImage imageNamed:@"nva_con"]
                                                        style:UIBarButtonItemStylePlain
                                                       target:self
                                                       action:@selector(backToMainView)];
    }
    return _leftBarItem;

}

- (AnnounceModel *)viewModel {
    if (_viewModel == nil) {
        _viewModel = [[AnnounceModel alloc] init];
    }
    return _viewModel;
}

- (YWPhotoDisplayView *)photoDisplayView {
    if (_photoDisplayView == nil) {
        _photoDisplayView = [[YWPhotoDisplayView alloc] init];
        _photoDisplayView.photoWidth = 80;
        [_photoDisplayView.addMorePhotosBtn addTarget:self
                                               action:@selector(addMorePhotos)
                                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoDisplayView;
}

#pragma mark button action 

- (void)releaseContent {
    
    [self.photoDisplayView putPhotosToImagesArr];
    //发布之前，先小时键盘
    [self.announceTextView.contentTextView resignFirstResponder];
    
    if (self.photoDisplayView.photoImagesCount != 0 || ![self.announceTextView.contentTextView.text isEqualToString:@""]) {
        
//    }else if (self.photoDisplayView.photoImagesCount == 0) {
//        
//        [self postTieZiWithContentWithoutImages:self.announceTextView.contentTextView.text];
//        
//    }else if ([self.announceTextView.contentTextView.text isEqualToString:@""]) {
//        
//        [self postTieZiWithImagesWithoutContent:self.photoDisplayView.photoImageArr];
//        
//    }else {
        
        [self postTieZiWithImages:self.photoDisplayView.photoImageArr andContent:self.announceTextView.contentTextView.text];
        
    }

    
}


CGFloat delay = 2.0f;

/**
 *  只有图片发布
 *
 *  @param photoArr 图片数组
 */
//- (void)postTieZiWithImagesWithoutContent:(NSArray *)photoArr {
//    
//    MBProgressHUD *hud = [MBProgressHUD showProgressViewToView:self.view
//                                                      animated:YES];
//
//    [YWQiNiuUploadTool uploadImages:photoArr
//                           progress:^(CGFloat progress) {
//        
//        hud.progress = progress;
//        
//    } success:^(NSArray *arr) {
//        
//        hud.hidden = YES;
//        [MBProgressHUD showHUDToAddToView:self.view
//                                labelText:@"发布成功"
//                                 animated:YES
//                               afterDelay:delay
//                                  success:^{
//            [self backToMainView];
//        }];
//    } failure:^{
//        
//    }];
//}

/**
 *  只有文字内容
 *
 *  @param content 贴子内容
 */
//- (void)postTieZiWithContentWithoutImages:(NSString *)content {
//    
//    
//    NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
//
//    paramaters[@"topic_id"]         = @0;
//    paramaters[@"content"]          = content;
//
//    [self.viewModel postFreshThingWithUrl:ANNOUNCE_FRESH_THING_URL
//                               paramaters:paramaters
//                                  success:^(NSString *result) {
//        
//        [MBProgressHUD showHUDToAddToView:self.view
//                                labelText:@"发布成功"
//                                 animated:YES
//                               afterDelay:delay
//                                  success:^{
//            [self backToMainView];
//        }];
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//}

/**
 *  既有图片又有内容
 *
 *  @param photoArr 图片数组
 *  @param content  贴子内容
 */
- (void)postTieZiWithImages:(NSArray *)photoArr andContent:(NSString *)content {
    
 //   MBProgressHUD *hud = [MBProgressHUD showProgressViewToView:self.view animated:YES];
    [YWQiNiuUploadTool uploadImages:photoArr
                           progress:^(CGFloat progress) {
        
                               [SVProgressHUD showProgress:progress];
        
    } success:^(NSArray *arr) {
        
        NSString *allUrlString          = [NSArray appendElementToString:arr];

        NSMutableDictionary *paramaters = [[NSMutableDictionary alloc] init];
        NSString *requestUrl            = @"";

        if (self.isFollowTieZi == YES) {
            paramaters[@"post_id"] = @(self.post_id);
            requestUrl             = TIEZI_REPLY;
        }
        else
        {
            paramaters[@"topic_id"] = @0;
            requestUrl              = ANNOUNCE_FRESH_THING_URL;
        }
        paramaters[@"content"]          = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        paramaters[@"img"]              = allUrlString;
        
        [self.viewModel postFreshThingWithUrl:requestUrl
                                   paramaters:paramaters
                                      success:^(NSString *result) {
                                          
                                  //        [hud hide:YES];
                                          
                                          //确认发布完成
                                          self.isRelease = YES;
                                          
                                          [SVProgressHUD showSuccessStatus:@"发布成功" afterDelay:HUD_DELAY];
                                          [[NSNotificationCenter defaultCenter] addObserver:self
                                                                                   selector:@selector(handleNotification:)
                                                                                       name:SVProgressHUDDidDisappearNotification
                                                                                     object:nil];
                                          
            
        } failure:^(NSError *error) {
       //     [hud hide:YES];
            [SVProgressHUD showErrorStatus:@"发布失败" afterDelay:HUD_DELAY];
        }];
        
    } failure:^{
    //    [hud hide:YES];
        [SVProgressHUD showErrorStatus:@"发布失败" afterDelay:HUD_DELAY];

    }];
    
}

- (void)handleNotification:(NSNotification *)notification {
    
    [self backToMainView];
}

/**
 *  进入相册
 */
- (void)enterIntoAlbumsSelectPhotos {

    self.photoDisplayView.selectModel           = FirstSelectPhoto;

    LSYAlbumCatalog *albumCatalog              = [[LSYAlbumCatalog alloc] init];
    albumCatalog.delegate                      = self;
    LSYNavigationController *navigation        = [[LSYNavigationController alloc] initWithRootViewController:albumCatalog];
    //最多选择15张照片
    albumCatalog.maximumNumberOfSelectionMedia = 15;
    
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
}

/**
 *  这里是点击加号，继续添加图片
 */
- (void)addMorePhotos {
    
    self.photoDisplayView.selectModel          = AddMorePhoto;

    LSYAlbumCatalog *albumCatalog              = [[LSYAlbumCatalog alloc] init];
    albumCatalog.delegate                      = self;
    LSYNavigationController *navigation        = [[LSYNavigationController alloc] initWithRootViewController:albumCatalog];
    albumCatalog.maximumNumberOfSelectionMedia = 15-self.photoDisplayView.photoImagesCount;
    
    [self presentViewController:navigation animated:YES completion:^{
        
    }];
    
}

- (void)backToMainView {
    
    [self resignKeyboard];

    if (self.isRelease == YES && self.isFollowTieZi == NO) {
        
        [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(jumpToHomeController)]) {
                [self.delegate jumpToHomeController];
            }
        }];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

}

#pragma mark setLayout

- (void)setAllLayout {
    
    [self.announceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(self.view.height * 0.33));
    }];
    
    [self.keyboardTooView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    
    
    
}

- (void)setLayoutDisplayPhotos {
    
    [self.photoDisplayView removeFromSuperview];
    
    self.photoDisplayView = nil;
    
    _photoDisplayView = [[YWPhotoDisplayView alloc] init];
    _photoDisplayView.photoWidth = 80;
    [_photoDisplayView.addMorePhotosBtn addTarget:self
                                           action:@selector(addMorePhotos)
                                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.photoDisplayView];

    [self.photoDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.announceTextView.mas_bottom).offset(20);
        make.left.equalTo(self.announceTextView.mas_left);
        make.right.equalTo(self.announceTextView.mas_right);
        make.height.equalTo(@100);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.announceTextView];
    
    [self setLayoutDisplayPhotos];
    //特别注意！！
    //这里布局的顺序不能乱了，keyboardTooView 要在photoDisplayView上面，否则键盘弹出时无法点击keyboardTooView
    [self.view addSubview:self.keyboardTooView];

    [self setAllLayout];

//
  /*  [self.viewModel requestForQiNiuCertificateSerialNumberWithUrl:QINIU_CERTIFICSTE_URL sucess:^(NSString *certfifcate) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];*/
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFollowTieZi == YES) {
        self.title = @"跟贴";
    }
    else
    {
        self.title = @"新鲜事";
    }
    
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    //监听键盘frame改变事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChangeFrame:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    //进入页面直接弹出键盘
    [self.announceTextView.contentTextView becomeFirstResponder];
}

//收起键盘
- (void)resignKeyboard {
    [self.announceTextView.contentTextView resignFirstResponder];
}

//键盘弹出后调用
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    
    //获取键盘的frame
    CGRect endFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //获取键盘弹出时长
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    //修改底部视图高度
    CGFloat bottom = endFrame.origin.y != SCREEN_HEIGHT ? endFrame.size.height:0;
    
    [self.keyboardTooView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottom);
    }];
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [self.keyboardTooView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottom);
    }];
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}



#pragma mark -- LSYAlbumCatalogDelegate

-(void)AlbumDidFinishPick:(NSArray *)assets {
    
    if (self.photoDisplayView.selectModel == FirstSelectPhoto) {
        
        [self.photoDisplayView addImages:assets];
        
    }else if (self.photoDisplayView.selectModel == AddMorePhoto) {
        
        [self.photoDisplayView addMoreImages:assets];
        
    }
}


#pragma mark ISEmojiViewDelegate

-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
    self.announceTextView.contentTextView.text = [self.announceTextView.contentTextView.text stringByAppendingString:emoji];
}

-(void)emojiView:(ISEmojiView *)emojiView didPressDeleteButton:(UIButton *)deletebutton{
    if (self.announceTextView.contentTextView.text.length > 0) {
        NSRange lastRange = [self.announceTextView.contentTextView.text rangeOfComposedCharacterSequenceAtIndex:self.announceTextView.contentTextView.text.length-1];
        self.announceTextView.contentTextView.text = [self.announceTextView.contentTextView.text substringToIndex:lastRange.location];
    }
}


#pragma mark YWKeyboardToolViewProtocol

- (void)didSelectedEmoji {
    
    [self.announceTextView.contentTextView becomeFirstResponder];

    ISEmojiView *emojiView = [[ISEmojiView alloc] initWithTextField:self.announceTextView.contentTextView delegate:self];
    self.announceTextView.contentTextView.internalTextView.inputView = emojiView;
    [self.announceTextView.contentTextView.internalTextView reloadInputViews];
}

- (void)didSelectedKeyboard {
    
    [self.announceTextView.contentTextView becomeFirstResponder];
    
    //先去出表情包的所占的inputView，否则弹不出键盘
    self.announceTextView.contentTextView.internalTextView.inputView = nil;
    
    self.announceTextView.contentTextView.internalTextView.keyboardType = UIKeyboardTypeDefault;
    [self.announceTextView.contentTextView.internalTextView reloadInputViews];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
