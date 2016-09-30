//
//  CroppingController.m
//  YWPhoto
//
//  Created by apple on 16/7/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "CroppingController.h"
#import "UIViewController+Camera.h"

@interface CroppingController (){
    
    __block void(^cropCompleteBlock)(UIImage*img);
    UIView *contentView;
    CGFloat imageScale;//default zoomscale
    UIImage *originImage;
    UIImageView *originImageView;//原图view
    CGRect originImageViewFrame;//默认的图片frame
    UIImageView *dashedBoxView;//裁剪框
    UIButton *confirmButton;//确定按钮
    UIView *bottomView;//底部框
}
@end

@implementation CroppingController

- (id)initWithCompleteBlock:(void (^)(UIImage *img))block{
    self = [super init];
    if (self) {
        cropCompleteBlock = block;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] keyWindow].backgroundColor = [UIColor whiteColor];

    // 从相册选图片
    [self startMediaBrowserFromViewController:self];
}

- (void)albumImageChoosed:(UIImage*)img{
    
    originImage = img;
    contentView = [[UIView alloc] init];
    contentView.clipsToBounds = YES;
    contentView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.6);
    contentView.backgroundColor = [UIColor blackColor];
   // contentView.transform = CGAffineTransformMakeRotation(M_PI/2.0);

    [self.view addSubview:contentView];
    
    originImageView = [[UIImageView alloc] init];
    originImageView.image = originImage;
    originImageView.clipsToBounds = NO;
    originImageView.userInteractionEnabled = YES;
    imageScale = contentView.frame.size.height/originImage.size.height;
    originImageView.frame = CGRectMake(0, 0, originImage.size.width*imageScale, originImage.size.height*imageScale);
    originImageView.center = contentView.center;
    [contentView addSubview:originImageView];
    
    //给图片添加手势
    [self addGestrue];
    
    //裁剪圆
    dashedBoxView = [[UIImageView alloc] init];
    dashedBoxView.userInteractionEnabled = NO;
    dashedBoxView.image = [UIImage imageNamed:@"Round"];
    dashedBoxView.center = self.view.center;
    [contentView addSubview:dashedBoxView];

    [dashedBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(40);
        make.centerX.equalTo(self.view);
    }];
    
    confirmButton = [[UIButton alloc] init];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [confirmButton setBackgroundImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    [confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:confirmButton];
    
    [confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView.mas_bottom).offset(20);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
}


- (void)addGestrue {
    UIPinchGestureRecognizer *scaleGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleImage:)];
    scaleGes.delegate = self;
    [originImageView addGestureRecognizer:scaleGes];
    
    
    UIPanGestureRecognizer *moveGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveImage:)];
    [moveGes setMinimumNumberOfTouches:1];
    [moveGes setMaximumNumberOfTouches:1];
    [originImageView addGestureRecognizer:moveGes];
}

// 处理缩放
float _lastScale = 1.0;
- (void)scaleImage:(UIPinchGestureRecognizer *)sender
{
  //  [self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];

    if([sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
        return;
    }
    
    
//    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
//    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
//    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
//    [[(UIPinchGestureRecognizer*) sender view]setTransform:newTransform];
//    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
    CGFloat scale = [sender scale]/_lastScale;
    
    
    CGAffineTransform currentTransform = originImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [originImageView setTransform:newTransform];
    
    
    _lastScale = [sender scale];
}

// 处理移动
float _lastTransX = 0.0, _lastTransY = 0.0;
- (void)moveImage:(UIPanGestureRecognizer *)sender
{
    CGPoint translatedPoint = [sender translationInView:contentView];
    
    if([sender state] == UIGestureRecognizerStateBegan) {
        _lastTransX = 0.0;
        _lastTransY = 0.0;
    }
    
    
    CGAffineTransform trans = CGAffineTransformMakeTranslation(translatedPoint.x - _lastTransX, translatedPoint.y - _lastTransY);
    CGAffineTransform newTransform = CGAffineTransformConcat(originImageView.transform, trans);
    _lastTransX = translatedPoint.x;
    _lastTransY = translatedPoint.y;
    
    originImageView.transform = newTransform;
}

// 裁剪
- (void)coppingImageView{
    float zoomScale = originImageView.frame.size.height/originImage.size.height;
    CGFloat originX = dashedBoxView.frame.origin.x-originImageView.frame.origin.x;
    CGFloat originY = dashedBoxView.frame.origin.y-originImageView.frame.origin.y;
    CGSize cropSize = CGSizeMake(dashedBoxView.frame.size.width/zoomScale, dashedBoxView.frame.size.height/zoomScale);
    
    
    CGRect cropRect = CGRectMake(originX/zoomScale, originY/zoomScale, cropSize.width, cropSize.height);
    
    CGImageRef tmp = CGImageCreateWithImageInRect([originImage CGImage], cropRect);
    
    self.croppedImage = [UIImage imageWithCGImage:tmp scale:originImage.scale orientation:originImage.imageOrientation];
    
    if (self.croppedImage.size.width > 130) {
        
        self.croppedImage = [self scaleImage:self.croppedImage toSize:CGSizeMake(130, 130)];

    }

    
    // 隐藏原图
    originImageView.hidden = YES;
    // 显示确定按钮
    confirmButton.hidden = NO;
}

//等比例缩放
-(UIImage*)scaleImage:(UIImage*)image toSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

// 确定按钮
- (void)confirmButtonAction{
    //回调
    [self coppingImageView];
    
    if (self.croppedImage != nil) {
        cropCompleteBlock(self.croppedImage);
    }
    
    [self backButtonAction];
}

// 返回
- (void)backButtonAction{
    [self.navigationController  popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
