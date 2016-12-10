//
//  YWShareView.m
//  yingwo
//
//  Created by 王世杰 on 2016/11/16.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

#import "YWShareView.h"
#import "UMShareMenuItem.h"

static NSString *kUMSplatformType = @"kUMSplatformType";
static NSString *kUMSSharePlatformType = @"kUMSSharePlatformType";
static NSString *kUMSSharePlatformIconName = @"kUMSSharePlatformIconName";
static NSString *kUMSSharePlatformItemView = @"UMSSharePlatformItemView";

@interface YWShareView ()
///半透明背景视图
@property (nonatomic, strong) UIView *backgroundGrayView;
///退出按钮
@property (nonatomic, strong) UIButton *cancelButton;
///列数
@property (nonatomic, assign) NSInteger columnCount;
///按钮大小
@property (nonatomic, assign) CGSize itemSize;//按钮大小
@end

@implementation YWShareView

- (instancetype)init {
    self = [super initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 188)];
    if (self){
        [self addSubview:self.cancelButton];
        self.columnCount = 3;
        self.itemSize = CGSizeMake(70, 70);
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.9;
        //获取可分享平台
        NSMutableArray *platformArray = [[NSMutableArray alloc] init];
        for (NSNumber *platformType in [UMSocialManager defaultManager].platformTypeArray) {
            NSMutableDictionary *dict = [self dictWithPlatformName:platformType];
            [dict setObject:platformType forKey:kUMSSharePlatformType];
            if (dict) {
                [platformArray addObject:dict];
            }
        }
        if (platformArray.count == 0) {//如果没有有效的分享平台，则不创建分享菜单
            UMSocialLogDebug(@"There is no any valid platform");
            return nil;
        }
        
        [platformArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if ([[obj1 valueForKey:kUMSSharePlatformType] integerValue] > [[obj2 valueForKey:kUMSSharePlatformType] integerValue]) {
                return NSOrderedDescending;
            }else{
                return NSOrderedAscending;
            }
        }];
        self.sharePlatformInfoArray = platformArray;
        
        
        [self reloadViewWithitems:self.sharePlatformInfoArray];
        
    }
    return self;
}

- (void)reloadViewWithitems:(NSArray *)items {
    
    CGFloat margin = (SCREEN_WIDTH - (self.itemSize.width * self.columnCount))/(self.columnCount + 1);
    
    for (NSInteger index = 0; index < items.count; index ++) {
        NSLog(@"%@",items[index]);
        NSInteger column = index % self.columnCount;//取余数作为列
        NSInteger line = index / self.columnCount;//取商为行
        UIView *itemView = [items[index] valueForKeyPath:kUMSSharePlatformItemView];
        itemView.frame = CGRectMake((column+1) *margin + column * self.itemSize.width, line * (8 + self.itemSize.height), self.itemSize.width, self.itemSize.height);
        [self addSubview:itemView];
    }
}

#pragma mark - respond event
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundGrayView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.35 animations:^{
        self.y = SCREEN_HEIGHT - self.height;
    }];
    
}

///隐藏视图
- (void)hiddenShareMenuView {
    [UIView animateWithDuration:0.35 animations:^{
        //向下移动
        self.y = SCREEN_HEIGHT;
    } completion:^(BOOL finished) {
        [self.backgroundGrayView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - lazy load
///半透明背景视图
- (UIView *)backgroundGrayView {
    if (!_backgroundGrayView) {
        _backgroundGrayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _backgroundGrayView.backgroundColor = [UIColor blackColor];
        _backgroundGrayView.alpha = 0.3;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareMenuView)];
        [_backgroundGrayView addGestureRecognizer:tap];
    }
    return _backgroundGrayView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, self.height - 40, self.frame.size.width, 40);
        [_cancelButton addTarget:self action:@selector(hiddenShareMenuView) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _cancelButton;
}

#pragma mark - get platform Info
- (NSMutableDictionary *)dictWithPlatformName:(NSNumber *)platformType
{
    UMSocialPlatformType platformType_int = [platformType integerValue];
    NSString *imageName = nil;
    NSString *platformName = nil;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:1];
    switch (platformType_int) {
        case UMSocialPlatformType_Sina:
            imageName = @"UMS_sina_icon";
            platformName = UMLocalizedString(@"sina",@"新浪微博");
            break;
        case UMSocialPlatformType_WechatSession:
            imageName = @"UMS_wechat_session_icon";
            platformName = UMLocalizedString(@"wechat",@"微信");
            break;
        case UMSocialPlatformType_WechatTimeLine:
            imageName = @"UMS_wechat_timeline_icon";
            platformName = UMLocalizedString(@"wechat_timeline",@"微信朋友圈");
            break;
        case UMSocialPlatformType_CopyLink:
            imageName = @"icon_link";
            platformName = UMLocalizedString(@"copyLink", @"复制链接");
            break;
        case UMSocialPlatformType_WechatFavorite:
            imageName = @"UMS_wechat_favorite_icon";
            platformName = UMLocalizedString(@"wechat_favorite",@"微信收藏");
            break;
        case UMSocialPlatformType_QQ:
            imageName = @"UMS_qq_icon";
            platformName = UMLocalizedString(@"qq",@"QQ");
            break;
        case UMSocialPlatformType_Qzone:
            imageName = @"UMS_qzone_icon";
            platformName = UMLocalizedString(@"qzone",@"QQ空间");
            break;
        case UMSocialPlatformType_TencentWb:
            imageName = @"UMS_tencent_icon";
            platformName = UMLocalizedString(@"tencentWB",@"腾讯微博");
            break;
        case UMSocialPlatformType_AlipaySession:
            imageName = @"UMS_alipay_session_icon";
            platformName = UMLocalizedString(@"alipay",@"支付宝");
            break;
        case UMSocialPlatformType_LaiWangSession:
            imageName = @"UMS_laiwang_session";
            platformName = UMLocalizedString(@"lw_session",@"点点虫");
            break;
        case UMSocialPlatformType_LaiWangTimeLine:
            imageName = @"UMS_laiwang_timeline";
            platformName = UMLocalizedString(@"lw_timeline",@"点点虫动态");
            break;
        case UMSocialPlatformType_YixinSession:
            imageName = @"UMS_yixin_session";
            platformName = UMLocalizedString(@"yixin_session",@"易信");
            break;
        case UMSocialPlatformType_YixinTimeLine:
            imageName = @"UMS_yixin_timeline";
            platformName = UMLocalizedString(@"yixin_timeline",@"易信朋友圈");
            break;
        case UMSocialPlatformType_YixinFavorite:
            imageName = @"UMS_yixin_favorite";
            platformName = UMLocalizedString(@"yixin_favorite",@"易信收藏");
            break;
        case UMSocialPlatformType_Douban:
            imageName = @"UMS_douban_icon";
            platformName = UMLocalizedString(@"douban",@"豆瓣");
            break;
        case UMSocialPlatformType_Renren:
            imageName = @"UMS_renren_icon";
            platformName = UMLocalizedString(@"renren",@"人人");
            break;
        case UMSocialPlatformType_Email:
            imageName = @"UMS_email_icon";
            platformName = UMLocalizedString(@"email",@"邮箱");
            break;
        case UMSocialPlatformType_Sms:
            imageName = @"UMS_sms_icon";
            platformName = UMLocalizedString(@"sms",@"短信");
            break;
        case UMSocialPlatformType_Facebook:
            imageName = @"UMS_facebook_icon";
            platformName = UMLocalizedString(@"facebook",@"Facebook");
            break;
        case UMSocialPlatformType_Twitter:
            imageName = @"UMS_twitter_icon";
            platformName = UMLocalizedString(@"twitter",@"Twitter");
            break;
        case UMSocialPlatformType_Instagram:
            imageName = @"UMS_instagram_icon";
            platformName = UMLocalizedString(@"instagram",@"Instagram");
            break;
        case UMSocialPlatformType_Line:
            imageName = @"UMS_line_icon";
            platformName = UMLocalizedString(@"line",@"Line");
            break;
        case UMSocialPlatformType_Flickr:
            imageName = @"UMS_flickr_icon";
            platformName = UMLocalizedString(@"flickr",@"Flickr");
            break;
        case UMSocialPlatformType_KakaoTalk:
            imageName = @"UMS_kakao_icon";
            platformName = UMLocalizedString(@"kakaoTalk",@"KakaoTalk");
            break;
        case UMSocialPlatformType_Pinterest:
            imageName = @"UMS_pinterest_icon";
            platformName = UMLocalizedString(@"pinterest",@"Pinterest");
            break;
        case UMSocialPlatformType_Tumblr:
            imageName = @"UMS_tumblr_icon";
            platformName = UMLocalizedString(@"tumblr",@"Tumblr");
            break;
        case UMSocialPlatformType_Linkedin:
            imageName = @"UMS_linkedin_icon";
            platformName = UMLocalizedString(@"linkedin",@"Linkedin");
            break;
        case UMSocialPlatformType_Whatsapp:
            imageName = @"UMS_whatsapp_icon";
            platformName = UMLocalizedString(@"whatsapp",@"Whatsapp");
            break;
            
        default:
            break;
    }
    
    [dict setObject:UMSocialPlatformIconWithName(imageName) forKey:kUMSSharePlatformIconName];
    [dict setObject:platformName forKey:kUMSplatformType];
    //为各平台创建按钮
    UMShareMenuItem *cell = [[UMShareMenuItem alloc] init];
    [cell reloadDataWithImage:[UIImage imageNamed:UMSocialPlatformIconWithName(imageName)] platformName:platformName];
    cell.index = platformType_int;
    
    __weak typeof(self) weakSelf = self;
    cell.tapActionBlock = ^(NSInteger index){
        __strong typeof(YWShareView *)strongSelf = weakSelf;
        strongSelf.selectionPlatform = index;
        if (strongSelf.shareSelectionBlock) {
            [strongSelf hiddenShareMenuView];
            strongSelf.shareSelectionBlock(strongSelf, index);
        }
    };
    [dict setObject:cell forKey:kUMSSharePlatformItemView];
    
    return dict;
}

@end
