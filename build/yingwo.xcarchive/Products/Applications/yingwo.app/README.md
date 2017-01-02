
应我校园 iOS版 app 项目介绍

/*
 * app UI适配为iphone5、iphone6、iphone6s、iphone6 plus、iphone6s plus
 * 系统要求最低 ios8.0及以上，并且目前只支持iphone（竖屏），暂时不支持其它iOS设备
 * 最初iOS版本开发者：南京工业大学 计算机科学与技术学院 汪小发 -------联系邮箱：451518849@qq.com
*/

*******************************************************************************************************
******************************************项目架构以及目录介绍*********************************************

1.CoreData  中存放数据表以及数据模型
2.Prefix    项目共享头文件（.h）都放在里面
3.Macro     所有宏定义放在里面
4.Tools     自定义工具类
5.CustomSegue   自定义跳转动画，show跳转
6.AppDelegate   存放AppDelegate文件

下面是 Controller
7.Main          存放app主要的TabBarController
8.Configuration 存放配置页面，如：密码重置，忘记密码，修改绑定手机号
9.Login         登录页面
10.Register     注册页面
11.PerfectInfo  完善个人信息页面，perfect：完善的意思，有道词典翻译
12.PersonalCenter       我的信息页面

注：详细功能及逻辑请看源代码中的注释

*******************************************************************************************************
******************************************开发采用的设计框架模式******************************************

开发采用的设计框架模式为:MVVM，页面文件夹模块分为：Controller（M），View（V），ViewModel（VM），Entity 模型类


*******************************************************************************************************
****************************************第三方框架****************************************************

（Pods导入）：
platform :ios, ‘8.0’

pod 'Masonry', '1.0.1'
pod 'ReactiveCocoa','4.2.1'
pod 'AFNetworking', ‘3.1.0’
pod 'MJExtension', '3.0.11'
pod 'MJRefresh','3.1.0'
pod 'SDWebImage','3.7.5'
pod 'FDFullscreenPopGesture','1.1'
pod 'UITableView+FDTemplateLayoutCell'
pod 'MBProgressHUD', '~> 0.9.2'
pod 'MagicalRecord', '~> 2.3.2'

*******************************************************************************************************
************************************Tools中自定义工具类介绍：*********************************************

1.CroppingController 头像上传及参见工具类
1.UIImage+(Copping) 头像裁剪成圆形
2.UIViewController+Camera 调用相册
3.YWSandBoxTool 后去沙盒路径
4.UIColor+Hex 十六进制颜色
5.Validate 验证工具类，密码，手机号等
6.UILabel+Wonderful ULabel分类
7.UIView+Frame UIView分类
8.YWNetworkTools AFNetworking 自定义工具类，暂时没用着
9.MBProgressHUD+Dispaly MBProgressHUD 分类，封装更方便的使用
10.MD5  md5加密
11.User+CURD Customer数据表的增、删、改、查
12.UINavigationBar+HideBottomLine 去掉导航栏下的下划线

*******************************************************************************************************
*******************************************************************************************************













