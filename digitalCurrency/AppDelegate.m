//
//  AppDelegate.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "YLNavigationController.h"
#import "HomeViewController.h"
#import "YLTabBarController.h"
#import "KSGuaidViewManager.h"
#import "ZLGestureLockViewController.h"
#import "PartnerDetailViewController.h"
#import "MyBillDetail1ViewController.h"
#import "MineNetManager.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "MyBillChatViewController.h"
#import "ChatGroupInfoModel.h"
#import "ChatGroupFMDBTool.h"
#import "UIImage+GIF.h"
#import "BaiduMobStat.h"//百度统计
#import "UMMobClick/MobClick.h"//友盟统计
#import <UserNotifications/UserNotifications.h>
#import "ZLAdvertView.h"
#import <CoreTelephony/CTCellularData.h>
#import <WebKit/WebKit.h>
#import <Bugly/Bugly.h>
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用 idfa 功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "FaceParameterConfig.h"
#import "ConversationViewController.h"
#import "YLNavigationController1.h"
@interface AppDelegate ()<chatSocketDelegate,UNUserNotificationCenterDelegate,JPUSHRegisterDelegate>
{
    NSString*_deviceToken;
}
@end

@implementation AppDelegate

+ (instancetype)sharedAppDelegate
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserStatus:) name:TUIKitNotification_TIMUserStatusListener object:nil];
    // 启动图片延时: 1秒
//    [NSThread sleepForTimeInterval:1];
    self.CNYRate = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    [ChangeLanguage initUserLanguage];//初始化应用语言
    [self initKeyboardManager];//初始化键盘工具
    [CSToastManager setQueueEnabled:NO];
    [EasyShowOptions sharedEasyShowOptions].lodingShowType = LodingShowTypeTurnAroundLeft;
    
    [[SocketManager share] connect];//连接行情socket
    [[ChatSocketManager share] connect];//连接聊天socket
    
    //分享
    [self regShareSDK];
    
    
    //百度人脸识别
    NSString* licensePath = [[NSBundle mainBundle] pathForResource:FACE_LICENSE_NAME ofType:FACE_LICENSE_SUFFIX];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:licensePath], @"license文件路径不对，请仔细查看文档");
    [[FaceSDKManager sharedInstance] setLicenseID:FACE_LICENSE_ID andLocalLicenceFile:licensePath];
    
    
    //集成bugly
    [Bugly startWithAppId:@"e473443fb9"];
    
    
    //集成腾讯云聊天
    [[TUIKit sharedInstance] setupWithAppId:SDKAPPID];
    [self registNotification];
    
    NSNumber *appId = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Appid];
    NSString *identifier = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_User];
    //NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Pwd];
    NSString *userSig = [[NSUserDefaults standardUserDefaults] objectForKey:Key_UserInfo_Sig];
    if([appId integerValue] == SDKAPPID && identifier.length != 0 && userSig.length != 0){
        __weak typeof(self) ws = self;
        TIMLoginParam *param = [[TIMLoginParam alloc] init];
        param.identifier = identifier;
        param.userSig = userSig;
        [[TIMManager sharedInstance] login:param succ:^{
            if (ws.deviceTokenData) {
                TIMTokenParam *param = [[TIMTokenParam alloc] init];
                /* 用户自己到苹果注册开发者证书，在开发者帐号中下载并生成证书(p12 文件)，将生成的 p12 文件传到腾讯证书管理控制台，控制台会自动生成一个证书 ID，将证书 ID 传入一下 busiId 参数中。*/
                //企业证书 ID
                param.busiId = sdkBusiId;
                [param setToken:ws.deviceTokenData];
                [[TIMManager sharedInstance] setToken:param succ:^{
                    NSLog(@"-----> 上传 token 成功 ");
                } fail:^(int code, NSString *msg) {
                    NSLog(@"-----> 上传 token 失败 ");
                }];
            }
            
        } fail:^(int code, NSString *msg) {
            [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:Key_UserInfo_Appid];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_User];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Pwd];
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:Key_UserInfo_Sig];
            
        }];
    }
    else{
        
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor=[UIColor whiteColor];
    //引导页
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        KSGuaidManager.images = @[[UIImage imageNamed:@"1-英文"],
                                  [UIImage imageNamed:@"2-英文"],
                                  [UIImage imageNamed:@"3-英文"]];
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        KSGuaidManager.images = @[[UIImage imageNamed:@"guid01"],
                                  [UIImage imageNamed:@"guid02"],
                                  [UIImage imageNamed:@"guid03"]];
    }
    
    KSGuaidManager.shouldDismissWhenDragging = YES;
    KSGuaidManager.pageIndicatorTintColor=[UIColor whiteColor];
    KSGuaidManager.currentPageIndicatorTintColor=baseColor;
//    [KSGuaidManager begin];
    
    if (![YLUserInfo isLogIn]) {//未登录
        LoginViewController*loginVC=[[LoginViewController alloc]init];
        loginVC.enterType=1;
        YLNavigationController1 *nav = [[YLNavigationController1 alloc]initWithRootViewController:loginVC];
        self.window.rootViewController = nav;
    }else{
        YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
        self.window.rootViewController = SectionTabbar;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self PresentGestureLockViewController];
    });
    // 设置您在百度移动统计网站上添加的APP的AppKey, 此处AppId即为应用的AppKey
    [[BaiduMobStat defaultStat] startWithAppId:@"56c52deab9"];
    UMConfigInstance.appKey = @"5b2dfec38f4a9d645a00003f";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick setLogEnabled:YES];
    
    
    //注册极光推送====================================================
    //Required
    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        // Fallback on earlier versions
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义 categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    
    // Required
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
    [JPUSHService setupWithOption:launchOptions appKey:@"c215269a3d32c30a9f8d3957"
                          channel:@"AppStore"
                 apsForProduction:0
            advertisingIdentifier:@""];
    //=================================================================
    
    
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
////    注册远程通知服务
//    if (@available(iOS 10.0, *)) {
//        //iOS 10 later
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        //必须写代理，不然无法监听通知的接收与点击事件
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (!error && granted) {
//                //用户点击允许
////                NSLog(@"注册成功");
//            }else{
//                //用户点击不允许
//                NSLog(@"注册失败");
//            }
//        }];
//
//        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
//        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
//        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
////            NSLog(@"========%@",settings);
//        }];
//    }else {
//        //iOS 8 - iOS 10系统
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//
//
//    [[UIApplication sharedApplication]registerForRemoteNotifications];
    
    
    
    
    [self.window makeKeyAndVisible];
    if ([self isFirstLauch]) {

    }else{
        //启动动画
//        [self customLaunchImageView];
    }
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    return YES;
}

#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"];
    //版本升级或首次登录
    if (version == nil || ![version isEqualToString:currentAppVersion]) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:@"appVersion"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}

//分享
-(void)regShareSDK {
    
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        //QQ
        [platformsRegister setupQQWithAppId:QQAppID appkey:QQAppKey];
        
        //微信
        [platformsRegister setupWeChatWithAppId:WeChatAppID appSecret:WeChatSecret];
        
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:WeiBoAppID appSecret:WeiBoSecret redirectUrl:WeiBoRedirectUri];
        
    }];
    
    
    
//    NSArray * activePlatforms = @[@(SSDKPlatformTypeSinaWeibo),     //新浪微博
//                                  @(SSDKPlatformTypeQQ),            //QQ
//                                  @(SSDKPlatformTypeWechat)];       //微信
//    [ShareSDK registerActivePlatforms:activePlatforms onImport:^(SSDKPlatformType platformType) {
//        switch (platformType) {
//            case SSDKPlatformTypeWechat: {
//                [ShareSDKConnector connectWeChat:[WXApi class]];
//            } break;
//            case SSDKPlatformTypeQQ: {
//                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
//            } break;
//            case SSDKPlatformTypeSinaWeibo: {
//                [ShareSDKConnector connectWeibo:[WeiboSDK class]];
//            } break;
//            default:
//                break;
//        }
//    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//        switch (platformType) {
//            case SSDKPlatformTypeSinaWeibo: {
//                [appInfo SSDKSetupSinaWeiboByAppKey:WeiBoAppID
//                                          appSecret:WeiBoSecret
//                                        redirectUri:WeiBoRedirectUri
//                                           authType:SSDKAuthTypeBoth];
//            } break;
//            case SSDKPlatformTypeWechat: {
//                [appInfo SSDKSetupWeChatByAppId:WeChatAppID
//                                      appSecret:WeChatSecret];
//            } break;
//            case SSDKPlatformTypeQQ: {
//                [appInfo SSDKSetupQQByAppId:QQAppID
//                                     appKey:QQAppKey
//                                   authType:SSDKAuthTypeBoth];
//            } break;
//            default:
//                break;
//        }
//    }];
}


#pragma  mark-设置已读
-(void)setMessageRead:(NSString*)msgId{
    [MineNetManager setMessageReadForMsgid:msgId CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"===%@",resPonseObj);
        
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                
            }else{
//                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
//            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}


-(void)customLaunchImageView{
    
    UIImageView *launchImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
    launchImageView.image = [self getLaunchImage];
    [self.window addSubview:launchImageView];
    [self.window bringSubviewToFront:launchImageView];

//    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kWindowH == 812.0 ? 64 : 0, 288 * kWindowWHOne, kWindowH - (kWindowH == 812.0 ? 145 : 0 ))];
    UIImageView *gifImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 144, 422)];
    gifImageView.center = self.window.center;
    NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"启动页.gif" ofType:nil];
    NSData  *imageData = [NSData dataWithContentsOfFile:filePath];
//    gifImageView.image = [UIImage sd_animatedGIFWithData:imageData];
    gifImageView.image = [UIImage sd_imageWithGIFData:imageData];
    [launchImageView addSubview:gifImageView];
  
    [UIView animateWithDuration:0.5f delay:5.0f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
          launchImageView.alpha = 0;

    } completion:^(BOOL finished) {
        //         设置启动页广告
//        [self setupAdvert];
        [launchImageView removeFromSuperview];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"launchImageViewDismiss" object:nil];
    }];

    
}


- (UIImage *)getLaunchImage
{
    UIImage *lauchImage = nil;
    NSString *viewOrientation = nil;
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        
        viewOrientation = @"Landscape";
        
    } else {
        
        viewOrientation = @"Portrait";
    }
    
    NSArray *imagesDictionary = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDictionary) {
        
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            
            lauchImage = [UIImage imageNamed:dict[@"UILaunchImageName"]];
        }
    }
    return lauchImage;
}

/**
 *  设置启动页广告
 */
- (void)setupAdvert {
    
//    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
//    NSString *filePath = [self getFilePathWithImageName:[kUserDefaults valueForKey:adImageName]];
//
//    BOOL isExist = [self isFileExistWithFilePath:filePath];
//    if (isExist) { // 图片存在
//
       NSString  *filePath = [[NSBundle bundleWithPath:[[NSBundle mainBundle] bundlePath]] pathForResource:@"广告.png" ofType:nil];
        ZLAdvertView *advertView = [[ZLAdvertView alloc] initWithFrame:self.window.bounds];
        advertView.filePath = filePath;
        [advertView show];
//    }
//
//    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
//    [self getAdvertisingImage];
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

///**
// *  初始化广告页面
// */
//- (void)getAdvertisingImage {
//
//    // TODO 请求广告接口
//    // 这里原本应该采用广告接口，现在用一些固定的网络图片url代替
//    NSArray *imageArray = @[
//                            @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//                            @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//
//                            @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
//                            ];
//    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
//
//    // 获取图片名:43-130P5122Z60-50.jpg
//    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
//    NSString *imageName = stringArr.lastObject;
//
//    // 拼接沙盒路径
//    NSString *filePath = [self getFilePathWithImageName:imageName];
//    BOOL isExist = [self isFileExistWithFilePath:filePath];
//    if (!isExist){ // 如果该图片不存在，则删除老图片，下载新图片
//
//        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
//    }
//}
//
///**
// *  下载新图片
// */
//- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName {
//
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//        UIImage *image = [UIImage imageWithData:data];
//
//        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
//
//        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
//            NSLog(@"保存成功");
//            [self deleteOldImage];
//            [kUserDefaults setValue:imageName forKey:adImageName];
//            [kUserDefaults synchronize];
//            // 如果有广告链接，将广告链接也保存下来
//        }else{
//            NSLog(@"保存失败");
//        }
//
//    });
//}
//
///**
// *  删除旧图片
// */
//- (void)deleteOldImage {
//
//    NSString *imageName = [kUserDefaults valueForKey:adImageName];
//    if (imageName) {
//        NSString *filePath = [self getFilePathWithImageName:imageName];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        [fileManager removeItemAtPath:filePath error:nil];
//    }
//}
//
///**
// *  根据图片名拼接文件路径
// */
//- (NSString *)getFilePathWithImageName:(NSString *)imageName {
//
//    if (imageName) {
//
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
//        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:imageName];
//
//        return filePath;
//    }
//
//    return nil;
//}


#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
//}


// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    NSLog(@"远程推送的信息是--%@",userInfo);
    if (userInfo[@"addition"]) {
        NSData *jsonData = [userInfo[@"addition"] dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        NSString*str= [NSString stringWithFormat:@"%@",dic[@"messageType"]];
        if ([str isEqualToString:@"NORMAL_CHAT"]) {
            YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
            ChatGroupInfoModel*model=[ChatGroupInfoModel mj_objectWithKeyValues:userInfo[@"addition"]];
            MyBillChatViewController *chatVC = [[MyBillChatViewController alloc] init];
            chatVC.hidesBottomBarWhenPushed = YES;
            chatVC.clickIndex = 1;
            chatVC.groupModel= model;
            [[SectionTabbar selectedViewController] pushViewController:chatVC animated:YES];
        }else if ([str isEqualToString:@"INVITATION"]){
            YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
            PartnerDetailViewController *chatVC = [[PartnerDetailViewController alloc] init];
            chatVC.hidesBottomBarWhenPushed = YES;
            NSData *jsonData = [dic[@"content"] dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            chatVC.applyType = [dict[@"applyType"] integerValue];
            chatVC.uidFrom= dic[@"uidFrom"];
            chatVC.nameFrom= dic[@"nameFrom"];
            [[SectionTabbar selectedViewController] pushViewController:chatVC animated:YES];
            [self setMessageRead:dic[@"msgId"]];
        }else if ([str isEqualToString:@"NOTICE_OTC"]){
            YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
            MyBillDetail1ViewController *detailVC = [[MyBillDetail1ViewController alloc] init];
            detailVC.orderId = dic[@"orderId"];
            detailVC.avatar = dic[@"fromAvatar"];
            detailVC.hidesBottomBarWhenPushed = YES;
            [[SectionTabbar selectedViewController] pushViewController:detailVC animated:YES];
            [self setMessageRead:dic[@"msgId"]];
        }
    }else{
        YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
        ConversationViewController *ConversationVC = [[ConversationViewController alloc] init];
        ConversationVC.hidesBottomBarWhenPushed = YES;
        [[SectionTabbar selectedViewController] pushViewController:ConversationVC animated:YES];
    }
    
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive){//点击通知栏进来
        YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
        NSLog(@"远程推送的信息是--%@",userInfo);
        ChatGroupInfoModel*model=[ChatGroupInfoModel mj_objectWithKeyValues:userInfo[@"addition"]];
        MyBillChatViewController *chatVC = [[MyBillChatViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        chatVC.clickIndex = 1;
        chatVC.groupModel= model;
        [[SectionTabbar selectedViewController] pushViewController:chatVC animated:YES];
        
        
//        TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:[NSString stringWithFormat:@"%@NTEX",_detailModel.hisId]];
//        TUIChatController *vc = [[TUIChatController alloc] initWithConversation:conv];
//        vc.title = _detailModel.otherSide;
//        [self.navigationController pushViewController:vc animated:YES];

    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required, For systems with less than or equal to iOS 6
    [JPUSHService handleRemoteNotification:userInfo];
}



#pragma mark-注册远程通知
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    _deviceTokenData = deviceToken;
    
    //获取deviceToken
//    _deviceToken= [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"withString:@""]
//                                     stringByReplacingOccurrencesOfString:@">" withString:@""]
//                                    stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self PresentGestureLockViewController];
//     NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",_deviceToken, @"token",nil];
//    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
//    [ChatSocketManager share].delegate=self;//先取消订阅
//    NSLog(@"注册远程推送成功——————%@",_deviceToken);
}
#pragma mark-注册远程通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"注册失败--%@",[error description]);
}

//#pragma mark-收到远程推送(点击通知栏进入App或者App在前台时触发)
//- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler
//{
//    if ([UIApplication sharedApplication].applicationState==UIApplicationStateInactive){//点击通知栏进来
//        YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
////        NSLog(@"远程推送的信息是--%@",userInfo);
//        ChatGroupInfoModel*model=[ChatGroupInfoModel mj_objectWithKeyValues:userInfo[@"addition"]];
//        MyBillChatViewController *chatVC = [[MyBillChatViewController alloc] init];
//        chatVC.hidesBottomBarWhenPushed = YES;
//        chatVC.clickIndex = 1;
//        chatVC.groupModel= model;
//        [[SectionTabbar selectedViewController] pushViewController:chatVC animated:YES];
//        [ChatGroupFMDBTool createTable:model withIndex:0];
//    }
//}

-(void)initKeyboardManager
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;// 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES;// 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES;// 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews;// 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = YES;// 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = NO;// 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 10.0f;

}


- (void)registNotification
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark-home键或者锁屏进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    __block UIBackgroundTaskIdentifier bgTaskID;
    bgTaskID = [application beginBackgroundTaskWithExpirationHandler:^ {
        //不管有没有完成，结束 background_task 任务
        [application endBackgroundTask: bgTaskID];
        bgTaskID = UIBackgroundTaskInvalid;
    }];
    
    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = unReadCount;
    
    //doBackground
    TIMBackgroundParam  *param = [[TIMBackgroundParam alloc] init];
    [param setC2cUnread:unReadCount];
    [[TIMManager sharedInstance] doBackground:param succ:^() {
        NSLog(@"doBackgroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//    if ([YLUserInfo isLogIn]) {
//         NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",_deviceToken, @"token",nil];
//        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
//        [ChatSocketManager share].delegate=self;
////        [[NSNotificationCenter defaultCenter] postNotificationName:@"getmassge" object:nil];
//    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"getunreadmassge" object:nil];
    
    YLTabBarController *SectionTabbar=(YLTabBarController *) APPLICATION.window.rootViewController;
    YLNavigationController*nvc=[SectionTabbar.childViewControllers firstObject];
    HomeViewController*homevc= [nvc.childViewControllers firstObject];
    [homevc getotcUnReadCount];
    [homevc getinvitationUnReadCount];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [homevc gettencentUnReadCount];
//    });
    
    
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    [self PresentGestureLockViewController];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[TIMManager sharedInstance] doForeground:^() {
        NSLog(@"doForegroud Succ");
    } fail:^(int code, NSString * err) {
        NSLog(@"Fail: %d->%@", code, err);
    }];
}


- (void)onUserStatus:(NSNotification *)notification
{
    TUIUserStatus status = [notification.object integerValue];
    switch (status) {
        case TUser_Status_ForceOffline:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"下线通知" message:@"您的帐号于另一台手机上登录。" delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"重新登录", nil];
            [alertView show];
        }
            break;
        case TUser_Status_ReConnFailed:
        {
            NSLog(@"连网失败");
        }
            break;
        case TUser_Status_SigExpired:
        {
            NSLog(@"userSig过期");
        }
            break;
        default:
            break;
    }
}


#pragma mark-检测到程序被杀死
- (void)applicationWillTerminate:(UIApplication *)application {
    
//    if ([YLUserInfo isLogIn]) {
//        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",_deviceToken, @"token",nil];
//        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_APNS withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
//         [ChatSocketManager share].delegate=self;
//    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEable) {
       
        return UIInterfaceOrientationMaskLandscape;
        
    } else {
       
        return UIInterfaceOrientationMaskPortrait;
    }
}
#pragma mark-弹出手势密码解锁
-(void)PresentGestureLockViewController{
    if([YLUserInfo isLogIn]&&[ZLGestureLockViewController gesturesPassword].length > 0){
        [EasyShowLodingView hidenLoding];
        ZLGestureLockViewController *vc = [[ZLGestureLockViewController alloc] initWithUnlockType:ZLUnlockTypeValidatePsw];
        [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
    }
}
#pragma mark - SocketDelegate Delegate,点击icon进来会触发
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    NSLog(@"==%hu",cmd);
    if (cmd==SUBSCRIBE_APNS) {
        NSLog(@"订阅APNS");
    
    }else if (cmd==UNSUBSCRIBE_APNS)
    {
        NSLog(@"取消订阅APNS");
    }
    else{
        NSLog(@"聊天消息-%@--%d",endStr,cmd);
        NSDictionary *dic =[SocketUtils dictionaryWithJsonString:endStr];
        ChatGroupInfoModel*model = [ChatGroupInfoModel mj_objectWithKeyValues:dic];
        //存入数据库
        [ChatGroupFMDBTool createTable:model withIndex:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"getmassgeendStr" object:endStr];
     }
    NSLog(@"APNS消息-%@--%d",endStr,cmd);
    
}

// 获取当前活动的navigationcontroller
- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    }
    else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        if ([selectVc isKindOfClass:[UINavigationController class]])
        {
            return (UINavigationController *)selectVc;
        }
    }
    return nil;
}

- (UIViewController *)topViewController
{
    UINavigationController *nav = [self navigationViewController];
    return nav.topViewController;
}

- (void)pushViewController:(UIViewController *)viewController
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController animated:YES];
    }
}

- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController withBackTitle:title animated:YES];
    }
}

- (void)pushViewController:(UIViewController *)viewController withBackTitle:(NSString *)title backAction:(CommonVoidBlock)action
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController withBackTitle:title action:action animated:NO];
    }
}

- (UIViewController *)popViewController
{
    return [[self navigationViewController] popViewControllerAnimated:YES];
}
- (NSArray *)popToRootViewController
{
    return [[self navigationViewController] popToRootViewControllerAnimated:YES];
}

- (NSArray *)popToViewController:(UIViewController *)viewController
{
    return [[self navigationViewController] popToViewController:viewController animated:YES];
}

- (void)presentViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    UIViewController *top = [self topViewController];
    
    if (vc.navigationController == nil)
    {
        if ([vc isKindOfClass:NSClassFromString(@"PGDatePickManager")] || [vc isKindOfClass:NSClassFromString(@"ZLGestureLockViewController")]) {
            [top presentViewController:vc animated:animated completion:completion];
        }else{
            YLNavigationController *nav = [[YLNavigationController alloc] initWithRootViewController:vc];
            [top presentViewController:nav animated:animated completion:completion];
        }
    }
    else
    {
        [top presentViewController:vc animated:animated completion:completion];
    }
}

- (void)dismissViewController:(UIViewController *)vc animated:(BOOL)animated completion:(void (^)(void))completion
{
    if (vc.navigationController != [AppDelegate sharedAppDelegate].navigationViewController)
    {
        [vc dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [vc.navigationController popViewControllerAnimated:YES];
    }
}

@end
