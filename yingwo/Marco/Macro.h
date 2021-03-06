//
//  Macro.h
//  yingwo
//
//  Created by apple on 16/7/10.
//  Copyright © 2016年 wangxiaofa. All rights reserved.
//

/*
 * 18888880017
 * 111111
 */

/*
 *  全局宏，所有文件共享的宏都放在这里
 */
#ifndef Macro_h
#define Macro_h

/********************************Debug************************************************/

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) strong##type = weak##type;


/********************************Color************************************************/
#define THEME_COLOR_1    @"#1DD2A6"
#define THEME_COLOR_2    @"#3A3A3A" //灰度越来越浅
#define THEME_COLOR_3    @"#8E8E8E"
#define THEME_COLOR_4    @"#BBBBBB"
#define THEME_COLOR_5    @"#DEDFED"
#define THEME_COLOR_6    @"#DCDCDC"

#define BACKGROUND_COLOR @"F3F3F3"
#define RED_COLOR        @"E92D52"
/********************************Color************************************************/

/********************************Notification************************************************/
#define TOKEN_KEY                    @"token"
#define USERINFO_NOTIFICATION        @"userInfoNotification"
#define USERINFO_NOTIFICATION_ACTIVE @"userInfoNotificationActive"
#define PREVIEW_ANNOUNCE_NOTIFICATION @"showAnnounce"

/********************************Notification************************************************/


/********************************短信验证的定时器Count****************************************/
#define COUNT_DOWN_TIME 59
/********************************Count************************************************/


/********************************storyboard identifier************************************************/

#define CONTROLLER_OF_MAINVC_IDENTIFIER         @"MainController"
#define CONTROLLER_OF_LOGINVC_IDENTIFIER        @"LoginController"
#define CONTROLLER_OF_HOME_IDENTIFIER           @"HomeController"
#define CONTROLLER_OF_DETAIL_IDENTIFIER         @"DetailController"
#define CONTROLLER_OF_DISCOVERY_IDENTIFIER      @"DiscoveryController"
#define CONTROLLER_OF_MESSAGE_IDENTIFY          @"MessageController"
#define CONTROLLER_OF_PERSONNAL_CENTER_IDENTIFY @"PersonalCenter"
#define CONTROLLER_OF_ANNOUNCE_IDENTIFIER       @"AnnounceController"
#define CONTROLLER_OF_TOPIC_IDENTIFIER          @"TopicController"
#define CONTROLLER_OF_TOPIC_LIST_IDENTIFIER     @"TopicListController"


/********************************storyboard identifier************************************************/


/********************************segue identify************************************************/
#define SEGUE_IDENTIFY_MAIN           @"main"
#define SEGUE_IDENTIFY_RESET          @"reset"
#define SEGUE_IDENTIFY_REGISTER       @"register"
#define SEGUE_IDENTIFY_VERFIFCATION   @"verification"
#define SEGUE_IDENTIFY_RESETPASSWORD  @"resetPassword"
#define SEGUE_IDENTIFY_WRITENICKNAME  @"writeNickname"
#define SEGUE_IDENTIFY_WRITESIGNATURE @"writeSignature"
#define SEGUE_IDENTIFY_PERFECTINFO    @"perfectInfo"
#define SEGUE_IDENTIFY_CONFIGURATION  @"cofiguration"
#define SEGUE_IDENTIFY_MODIFY         @"modify"
#define SEGUE_IDENTIFY_BASEINFO       @"baseInfo"
#define SEGUE_IDENTIFY_FOLLOW_TIEZI   @"followTieZi"
#define SEGUE_IDENTIFY_TOPICLIST      @"topicList"
#define SEGUE_IDENTIFY_TOPIC          @"topic"
#define SEGUE_IDENTIFY_MYTOPIC        @"myTopic"
#define SEGUE_IDENTIFY_MYTIEZI        @"myTieZi"
#define SEGUE_IDENTIFY_MYLIKE         @"myLike"
#define SEGUE_IDENTIFY_MYCOMMENT      @"myComment"
#define SEGUE_IDENTIFY_MYRELATION     @"myRs"


/********************************segue identify************************************************/

// new api 139.198.190.240 http://api.yingwoo.com/api/v1
// old api http://yw.zhibaizhi.com/yingwophp/api/v1
/********************************* URL ******************************************************/
#define BASE_URL                @"https://api.yingwoo.com/api/v1"
//#define BASE_URL                @"http://yw.zhibaizhi.com/yingwophp/api/v1"
//#define BASE_URL                @"http://yw.zhibaizhi.com:8081"

#define LOGIN_URL               @"/User/Login"
#define REGISTER_URL            @"/User/Register"
#define SMS_URL                 @"/Sms/Send"
#define SMS_CHECK               @"/Sms/Check"
#define MOBILE_CHECK_URL        @"/User/Check_mobile"
#define RESET_PASSWORD_URL      @"/User/reset_password"

#define HEADIMAGE_URL           @"/Public/uploads/"
#define SCHOOL_URL              @"/school/school_list"
#define ACADEMY_URL             @"/school/academy_list"

#define BASE_INFO_URL           @"/User/Base_info"
#define UPDATE_INFO_URL         @"/User/Update"

#define ANNOUNCE_URL            @"/Post/add_new"

//贴子
#define HOME_URL                @"/Post/index"
#define TIEZI_URL               @"/Post/get_list"
#define TIEZI_REPLY             @"/Post/reply"
#define TIEZI_COMMENT_LIST_URL  @"/Post/Comment_list"
#define TIEZI_COMMENT_MERGE_URL @"/Post/Comment_list_merged"
#define TIEZI_COMMENT_URL       @"/Post/Comment"
#define TIEZI_RELPY_URL         @"/Post/reply_list"
#define TIEZI_LIKE_URL          @"/Post/like"
#define MY_TIEZI_URL            @"/Post/my_list"
#define MY_LIKE_URL             @"/Post/my_like_list"
#define TIEZI_DEL_URL           @"/Post/del"
#define TIEZI_REPLY_DEL_URL     @"/Post/reply_del"
#define TIEZI_COMMENT_DEL_URL   @"/Post/comment_del"
#define TIEZI_REPLY_LIKE        @"/Post/reply_like"
#define HOME_INDEX_CNT_URL      @"/Post/index_cnt"
#define MESSAGE_COMMENT_CNT_URL @"/Post/my_reply_and_comment_cnt"
#define MESSAGE_LIKE_CNT_URL    @"/Post/my_liked_cnt"
#define TIEZI_DETAIL            @"/Post/detail"

//发现
#define HOT_DISCUSS_URL         @"/Discover/post"

//话题
#define TOPIC_FIELD_URL         @"/Field/get_list"
#define TOPIC_SUBJECT_URL       @"/Subject/get_list"
#define TOPIC_LIST_URL          @"/Topic/get_list"
#define TOPIC_DETAIL_URL        @"/Topic/detail"
#define TOPIC_LIKE_LIST_URL     @"/Topic/like_list"
#define TOPIC_LIKE_URL          @"/Topic/like"
#define HOT_TOPIC_URL           @"/Topic/hot_list"
#define RECOMMENDED_TOPIC_URL   @"/Topic/recommended_list_fixed"
#define RECOMMEND_TOPIC_URL     @"/Topic/recommended_list"
#define RECOMMEND_ALLTOPIC_URL  @"/Topic/recommended_list_v2" //获取所有

//用户
#define TA_INFO_URL             @"/User/info"
#define TA_USER_LIKE_URL        @"/User/like"
#define TA_USER_LIKE_LIST_URL   @"/User/like_list"
#define TA_USER_LIKED_LIST_URL  @"/User/liked_list"
#define TA_USER_FRIEND_LIST_URL @"/User/friend_list"
#define TA_USER_BACKGROUND_URL  @"/User/background_img"
#define QINIU_BASE_URL          @"http://obabu2buy.bkt.clouddn.com"
#define QINIU_TOKEN_URL         @"/Qiniu/UploadToken"

//消息
#define MESSAGE_REPLY_AND_COMMENT_URL @"/Post/my_reply_and_comment_list"
#define MY_REPLY_AND_COMMENT_URL      @"/Post/reply_and_comment_list"
#define MY_LIKED_URL                  @"/Post/my_liked_list"

#define DEVICE_TOKEN_URL        @"/User/update_device_token"
/********************************* errorCode ******************************************************/
//未登录
#define ERROR_UNLOGIN_CODE 5001
//为完善信息
#define ERROR_UNFINISHED_CODE 5002
//重复注册
#define ERROR_REGISTERED_CODE 5003

/********************************* errorCode ******************************************************/


/********************************* 七牛图片模式 imageView2 model**************************/
//居中裁剪图片的模式，网络较差时图片渐进显示
#define QINIU_SQUARE_IMAGE_MODEL @"?imageView2/1/w/%d/interlace/1"
//模糊居中
#define QINIU_BLUR_IMAGE_MODEL @"?imageMogr2/thumbnail/%dx%d/interlace/1/auto-orient"
//图片等比缩放,这里我限定宽度和长度，替2g网节省流量😊，其中参数中的长和宽都是像素值！(1pt=2px)
#define QINIU_PROPORTION_IMAGE_MODEL @"?imageView2/0/w/%d/h/%d/interlace/1"
/********************************* 七牛图片模式 imageView2 model**************************/

/***************************************融云 URL***********************************************/

#define RongCloud_Key       @"pkfcgjstpkqm8"

#define RongCloud_App_Secret @"J89Lo3z46y6e8"

#define RongCloud_Token_URL @"https://api.cn.ronghub.com/user/getToken.json"

#define RongCloud_Refresh_URL @"https://api.cn.ronghub.com/user/refresh.json"

/********************************* network status code ******************************************/
#define SUCCESS_STATUS 200
#define FAILURE_STATUS 403
#define ILLEGAL_TOKEN_STATUS 401
/********************************* network status code ******************************************/

/********************************* key ******************************************************/
//登录、注册
#define USERNAME     @"name"
#define PASSWORD     @"password"
#define DEVICE_TOEKN @"device"
#define VERFIFCATION @"verification"
#define MOBILE       @"mobile"
#define RN           @"rn"
#define SIGN         @"sign"
#define SMS_MODEL    @"mode"
#define SMS_CODE     @"code"

//贴子
#define CAT_ID @"cat_id"
/********************************* key ******************************************************/

/********************************* cookie ******************************************************/
#define LOGIN_COOKIE            @"loginCookie"
#define REGISTER_COOKIE         @"registerCookie"
#define TIEZI_LIKE_COOKIE       @"tieZiLike"
#define TIEZI_REPLY_LIKE_COOKIE @"tieZiReplyLike"
/********************************* cookie ******************************************************/

/********************************* 魔数 ******************************************************/
#define MOSHU @"123456789"

/********************************* 设备物理尺寸 ************************************************/
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width   //屏幕宽度
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height   //屏幕高度
#define INPUTTEXTFIELD_WIDTH ([[UIScreen mainScreen] bounds].size.width - 20 ) //输入框宽度
#define IPHONE_5_INPUTTEXTFIELD_HEIGHT 40    //iphone5上的输入框高度
/********************************* 设备物理尺寸 ************************************************/


/********************************* 设备类别 ************************************************/
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )568) < DBL_EPSILON )
#define IS_IPHONE_6 (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )667) < DBL_EPSILON )
#define IS_IPHONE_6_PLUS (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double )960) < DBL_EPSILON )
/********************************* 设备类别 ************************************************/


/******************************* 第三方框架需要尺寸，有些数据会与之前定义的宏重复 ****************************/
#define ScreenSize [UIScreen mainScreen].bounds.size
#define kThumbnailLength    ([UIScreen mainScreen].bounds.size.width - 5*5)/4
#define kThumbnailSize      CGSizeMake(kThumbnailLength, kThumbnailLength)
#define DistanceFromTopGuiden(view) (view.frame.origin.y + view.frame.size.height)
#define DistanceFromLeftGuiden(view) (view.frame.origin.x + view.frame.size.width)
#define ViewOrigin(view)   (view.frame.origin)
#define ViewSize(view)  (view.frame.size)
/******************************* 第三方框架需要尺寸，有些数据会与之前定义的宏重复 ****************************/

/********************************* SVProgressHUD Delay ************************************************/

#define HUD_DELAY 0.8

#endif /* Macro_h */
