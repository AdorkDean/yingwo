//
//  AnnounceController.m
//  yingwo
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "AnnounceController.h"
#import "DetailController.h"

#import "YWKeyboardToolView.h"
#import "YWPhotoDisplayView.h"

@interface AnnounceController ()<ISEmojiViewDelegate,YWKeyboardToolViewProtocol, UIImagePickerControllerDelegate, UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) YWKeyboardToolView *keyboardToolView;

@property (nonatomic, strong) UIBarButtonItem    *rightBarItem;

@property (nonatomic, strong) YWPhotoDisplayView *photoDisplayView;

//发帖时候的参数
@property (nonatomic, strong) NSDictionary      *tieZiParamaters;

@property (nonatomic, assign) UIImageView        *lastPhoto;
@property (nonatomic, assign) NSInteger          photoImagesCount;

@end

@implementation AnnounceController

- (instancetype)initWithTieZiId:(int)postId title:(NSString *)title {
    self = [super init];
    
    if (self) {
        self.post_id = postId;
        self.title = title;
    }
    return self;
}

- (YWAnnounceTextView *)announceTextView {
    if (_announceTextView == nil ) {
        _announceTextView                             = [[YWAnnounceTextView alloc] init];
        _announceTextView.layer.masksToBounds         = YES;
        _announceTextView.layer.cornerRadius          = 10;
        _announceTextView.contentTextView.placeholder = @"分享身边有趣、有料、有用的校园新鲜事～";
        _announceTextView.keyboardToolView.delegate   = self;
        _announceTextView.contentTextView.font        = [UIFont systemFontOfSize:15];
        _announceTextView.contentTextView.maxHeight   = SCREEN_HEIGHT * 0.32;
        UITapGestureRecognizer *tap                   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(makeKeybordBecomeFirstResponder)];
        _announceTextView.userInteractionEnabled      = YES;
        [_announceTextView addGestureRecognizer:tap];

    }
    return _announceTextView;
}

- (YWKeyboardToolView *)keyboardToolView {
    if (_keyboardToolView == nil) {
        _keyboardToolView          = [[YWKeyboardToolView alloc] init];
        
        [_keyboardToolView.returnKeyBoard addTarget:self
                                            action:@selector(resignKeyboard)
                                  forControlEvents:UIControlEventTouchUpInside];
        
        [_keyboardToolView.photo addTarget:self
                                   action:@selector(enterIntoAlbumsSelectPhotos)
                         forControlEvents:UIControlEventTouchUpInside];
        
        _keyboardToolView.delegate = self;
    }
    return _keyboardToolView;
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
                                               action:@selector(enterIntoAlbumsSelectPhotos)
                                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _photoDisplayView;
}

#pragma mark button action 

- (void)releaseContent {
    [self.photoDisplayView putPhotosToImagesArr];
    //发布之前，先消失键盘
    [self.announceTextView.contentTextView resignFirstResponder];
    
    if (self.photoDisplayView.photoImagesCount != 0 || ![self.announceTextView.contentTextView.text isEqualToString:@""]) {
        
        [SVProgressHUD showWithStatus:@"正在发布..."];
        
        [self postTieZiWithImages:self.photoDisplayView.photoImageArr andContent:self.announceTextView.contentTextView.text];
        
    }
    
}

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

        RequestEntity *request = [[RequestEntity alloc] init];
        
        request.URLString = ANNOUNCE_URL;
        request.parameter = @{@"topic_id":@(self.post_id),@"content":content,@"img":allUrlString};

        [self.viewModel postTieZiWithRequest:request
                                     success:^(id content) {
                                                                                  
                                         [SVProgressHUD showSuccessStatus:@"发布成功" afterDelay:HUD_DELAY];
                                         
                                         [self backToForwardView];
                                         

        } failure:^(id error) {
            [SVProgressHUD showErrorStatus:@"发布失败" afterDelay:HUD_DELAY];

        }];
        
    } failure:^{
        [SVProgressHUD showErrorStatus:@"发布失败" afterDelay:HUD_DELAY];

    }];
    
}

/**
 *  进入相册
 */
- (void)enterIntoAlbumsSelectPhotos {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:15 - self.photoDisplayView.photoImagesCount delegate:self];
    imagePickerVc.navigationBar.barTintColor = [UIColor colorWithHexString:THEME_COLOR_1];

    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


- (void)backToForwardView {
    
    [self resignKeyboard];
    
    self.announceTextView.contentTextView.text = @"";
    [self removeDisplayPhotos];
    

    if ([self.delegate respondsToSelector:@selector(jumpToHomeController)]) {
        [self.delegate jumpToHomeController];
    }
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];

}


#pragma mark setLayout

- (void)setDisplyViewLayout {
    
    [self.photoDisplayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.announceTextView.mas_bottom).offset(20);
        make.left.equalTo(self.announceTextView.mas_left);
        make.right.equalTo(self.announceTextView.mas_right);
        make.height.equalTo(@100);
    }];
    
}

- (void)layoutSubviews {
    

    [self.view addSubview:self.announceTextView];

    [self.view addSubview:self.photoDisplayView];

    [self.view addSubview:self.keyboardToolView];
    

    [self.announceTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.view).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@(self.view.height * 0.38));
    }];
    
    [self.keyboardToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@45);
    }];

    [self setDisplyViewLayout];

}

- (void)removeDisplayPhotos {
    
    [self.photoDisplayView removeFromSuperview];
    
    self.photoDisplayView = nil;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //特别注意！！
    //这里布局的顺序不能乱了，keyboardToolView 要在photoDisplayView上面，否则键盘弹出时无法点击keyboardToolView

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = self.rightBarItem;
    self.navigationItem.leftBarButtonItem  = self.leftBarItem;
    
    [self layoutSubviews];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

}

- (void)backToFarword {
    
    [self resignKeyboard];
    
    self.announceTextView.contentTextView.text = @"";
    [self removeDisplayPhotos];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)makeKeybordBecomeFirstResponder {
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
    
    [self.keyboardToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(bottom);
    }];
    
    // 告诉self.view约束需要更新
    [self.view setNeedsUpdateConstraints];
    // 调用此方法告诉self.view检测是否需要更新约束，若需要则更新，下面添加动画效果才起作用
    [self.view updateConstraintsIfNeeded];
    
    [self.keyboardToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-bottom);
    }];
    
    // 约束动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

#pragma mark ISEmojiViewDelegate

-(void)emojiView:(ISEmojiView *)emojiView didSelectEmoji:(NSString *)emoji{
    NSRange insertRange = self.announceTextView.contentTextView.selectedRange;
    self.announceTextView.contentTextView.text = [self.announceTextView.contentTextView.text stringByReplacingCharactersInRange:insertRange withString:emoji];
     //插入后光标仍在插入后的位置
     self.announceTextView.contentTextView.selectedRange = NSMakeRange(insertRange.location + emoji.length, 0);
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


#pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {

    [self.photoDisplayView addImages:assets];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
