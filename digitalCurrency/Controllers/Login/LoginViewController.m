//
//  LoginViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"
#import "LoginNetManager.h"
#import "YLTabBarController.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "CustomButton.h"
#import <TCWebCodesSDK/TCWebCodesBridge.h>
#import "JPUSHService.h"
#import "MineNetManager.h"
//@interface LoginViewController ()<CaptchaButtonDelegate>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;

@property(nonatomic,copy)NSString *dbPath;//存入数据库的路径
@property(nonatomic,assign)NSInteger sqliteFlag;//判断是否存入
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
//@property (weak, nonatomic) IBOutlet CustomButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPwdBtn;
@property (weak, nonatomic) IBOutlet UIButton *nowRegisterBtn;
@property (weak, nonatomic) IBOutlet UILabel *noAccountlabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomspec;
@property (weak, nonatomic) IBOutlet UILabel *phonelabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordlabel;
@property (weak, nonatomic) IBOutlet UIButton *eyebutton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title=LocalizationKey(@"login");
    self.userNameTF.placeholder = LocalizationKey(@"inputUsername");
    self.passwordTF.placeholder = LocalizationKey(@"inputPwd");
    [self setNavigationControllerStyle];
//    [self leftbutitem];
    self.bottomspec.constant = SafeAreaBottomHeight + 10;
    //通过KVC修改占位文字的颜色
    [_userNameTF setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordTF setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_userNameTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    [_passwordTF setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
    self.bottomDistance.constant=kWindowH == 812.0 ? 34 : 10;
    self.phonelabel.text = LocalizationKey(@"username");
    self.passwordlabel.text = LocalizationKey(@"pwd");
    self.noAccountlabel.text = LocalizationKey(@"noAccount");
    
    // Do any additional setup after loading the view from its nib.
    self.sqliteFlag = NO;
    [self.loginBtn setTitle:LocalizationKey(@"login") forState:UIControlStateNormal];
    [self.forgetPwdBtn setTitle:LocalizationKey(@"forgetPassword") forState:UIControlStateNormal];
    [self.nowRegisterBtn setTitle:LocalizationKey(@"nowregister") forState:UIControlStateNormal];
//    [self.loginBtn setOriginaStyle];
//    self.loginBtn.delegate = self;
    
    
    if (kWindowW==320) {
        self.heightConstraint.constant = 40;
    }else if (kWindowW==375){
        if (kWindowH==812) {
            self.heightConstraint.constant = 120;
        }else{
            self.heightConstraint.constant = 80;
        }
    }else if (kWindowW==414){
        if (kWindowH==896) {
            self.heightConstraint.constant = 120;
        }else{
            self.heightConstraint.constant = 80;
        }
    }else {
        self.heightConstraint.constant = 120;
    }
    
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

//是否显示密码
- (IBAction)openeyeaction:(id)sender {
    self.eyebutton.selected = !self.eyebutton.selected;
    self.passwordTF.secureTextEntry = !self.eyebutton.selected;
}

-(void)leftbutitem{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 44);
    [btn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
    [btn setTitleColor:AppTextColor_333333 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self setnav];
    self.navigationController.navigationBar.translucent = YES;
    
    [self setNavigationControllerStyle];
}


-(void)setnav{
    self.navigationController.navigationBar.translucent = NO;//默认为YES
    //1.可以设置背景色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];//去除导航栏黑线
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //2.可以设置背景图
    self.navigationController.navigationBar.barTintColor = mainColor;
    //4.可以设置标题文字的垂直位置
    [self.navigationController.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    //5.设置导航栏的样式－－影响状态栏中文字的颜色
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    //6.可以设置标题栏文字的样式
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    attributes[NSForegroundColorAttributeName] = AppTextColor_333333;
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.navigationController.navigationBar.tintColor = AppTextColor_333333;
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:AppTextColor_333333} forState:UIControlStateNormal];
    [item setTintColor:AppTextColor_333333];
}


-(void)RighttouchEvent{
    if (self.pushOrPresent) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
//        [self cancelNavigationControllerStyle];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
- (IBAction)touchEvent:(UIButton *)sender {
    switch (sender.tag) {
        case 0://登录
            //[self ToLogin];
            break;
        case 1://忘记密码
            [self.navigationController pushViewController:[[ForgetViewController alloc]initWithNibName:@"ForgetViewController" bundle:nil] animated:YES];
            
            break;
        case 2://注册
            [self.navigationController pushViewController:[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil] animated:YES];
            break;
            
        default:
            break;
    }
}

//MARK:--存入数据库
-(void)saveToSqliteData{
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [doc stringByAppendingPathComponent:@"user.sqlite"];
    self.dbPath = path;
    [self createTable];
}
// 建表
- (void)createTable {
    //NSLog(@"%s", __func__);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.dbPath] == NO) {
        FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
        if ([db open]) {
            NSString *sql = @"CREATE TABLE 'User' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'name' VARCHAR(30), 'password' VARCHAR(30))";
            BOOL res = [db executeUpdate:sql];
            if (!res) {
                NSLog(@"error when creating db table");
            } else {
//                NSLog(@"success to creating db table");
                [self insertData];
            }
            [db close];
        } else {
            NSLog(@"error when open db");
        }
    }else{
        [self queryData];
    }
}
// 查询数据
- (void)queryData {
   // NSLog(@"%s", __func__);
    
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        NSString *sql = @"select *from user";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
           // int userId = [rs intForColumn:@"id"];
            NSString *name = [rs stringForColumn:@"name"];
           // NSString *pass = [rs stringForColumn:@"password"];
            //NSLog(@"user id = %d, name = %@, pass = %@", userId, name, pass);
            if ([name isEqualToString:self.userNameTF.text]) {
                self.sqliteFlag = YES;
            }
        }
        if (self.sqliteFlag == NO) {
            [self insertData];
        }
        [db close];
    }
}
// 插入数据
- (void)insertData {
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        
        NSString *sql = @"insert into user (name, password) values(?, ?) ";
        NSString *name = self.userNameTF.text;
        NSString *password = self.passwordTF.text;
        BOOL res = [db executeUpdate:sql, name, password];
        if (!res) {
            NSLog(@"error to insert data");
        } else {
//            NSLog(@"success to insert data");
        }
        [db close];
    }
}


//签名
-(NSString*)generateSign:(NSDictionary*)dict{
    NSMutableArray*arr = [NSMutableArray array];
    
    NSArray *keys = [dict allKeys];
    NSArray *sortDic = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {        return [obj1 compare:obj2];    }];
    
    for (NSString*dictstr in sortDic) {
        [arr addObject:[NSString stringWithFormat:@"%@",dict[dictstr]]];
    }
    NSString*arraystr = [arr componentsJoinedByString:@""];
    NSLog(@"%@===%@",dict,arraystr);
    NSDate *senddate = [NSDate date];
    NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
    NSString*laststring = [NSString stringWithFormat:@"%@%@%@",arraystr,date2,@"8e44ab09f4ba5df2a90d291b7094107a"];
    NSString*sign = [MD5 md5:laststring];
    return sign;
}



- (IBAction)loginBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    
    if ([NSString stringIsNull:self.userNameTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputMobile") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([NSString stringIsNull:self.passwordTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputPwd") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    // 加载腾讯验证码2040846200
//    [[TCWebCodesBridge sharedBridge] loadTencentCaptcha:self.view appid:@"2055917389" callback:^(NSDictionary *resultJSON) { // appid在验证码接入平台注册申请，
//        if(0==[resultJSON[@"ret"] intValue]) {
            /**
             验证成功
             返回内容：
             resultJSON[@"appid"]为回传的业务appid
             resultJSON[@"ticket"]为验证码票据
             resultJSON[@"randstr"]为随机串
             */
            
            
            [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
            __block NSMutableString *postResult = [[NSMutableString alloc] init];
//            [resultJSON enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
//                [postResult appendFormat:@"%@=%@&",key,obj];
//            }];
            
//            [postResult appendFormat:@"%@", [NSString stringWithFormat:@"userName=%@&pwd=%@&ticket=%@&randstr=%@",self.userNameTF.text,self.passwordTF.text,resultJSON[@"ticket"],resultJSON[@"randstr"]]];
            
            [postResult appendFormat:@"%@", [NSString stringWithFormat:@"userName=%@&pwd=%@",self.userNameTF.text,[MD5 md5:self.passwordTF.text]]];
            
            NSDictionary *headerFields = @{@"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"};
            NSMutableURLRequest *secondaryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",HOST,@"member/login"]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
            secondaryRequest.HTTPMethod = @"POST";
            secondaryRequest.allHTTPHeaderFields = headerFields;
            NSString*md5Str= [MD5 md5:[NSString stringWithFormat:@"%@%@%@",[keychianTool readUserUUID],self.userNameTF.text,self.passwordTF.text]];
            
            NSLog(@"=====%@",md5Str);
            NSDictionary*dict = @{@"userName":self.userNameTF.text,@"pwd":[MD5 md5:self.passwordTF.text]};
            [secondaryRequest addValue: [self generateSign:dict] forHTTPHeaderField:@"sign"];
            NSDate *senddate = [NSDate date];
            NSString *date2 = [NSString stringWithFormat:@"%ld", (long)[senddate timeIntervalSince1970]];
            [secondaryRequest addValue: date2 forHTTPHeaderField:@"time"];
            
            
            [secondaryRequest addValue: md5Str forHTTPHeaderField:@"access-auth-token"];
            secondaryRequest.HTTPBody = [postResult dataUsingEncoding:NSUTF8StringEncoding];
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
            NSURLSessionDataTask *task = [session dataTaskWithRequest:secondaryRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [EasyShowLodingView hidenLoding];
                });
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                //NSLog(@"请求头中%@",httpResponse.allHeaderFields);
                NSLog(@"%@===%@",error,httpResponse);
                
                if (!error && httpResponse.statusCode == 200) {
                    NSError *err;
                    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
                    NSLog(@"===%@",dict);
                    if (!err) {
                        if ([dict[@"status"] integerValue] == 0) {
                            
                            NSLog(@"=====%@====%@",dict,dict[@"data"][@"id"]);
                            
                            //注册极光推送别名
//                            [JPUSHService setAlias:[NSString stringWithFormat:@"%@",dict[@"data"][@"id"]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
////                                NSLog(@"%lu===%@====%lu",iResCode,iAlias,seq);
//                            } seq:[[NSDate date] timeIntervalSince1970]];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [APPLICATION.window makeToast:dict[@"msg"] duration:1.5 position:CSToastPositionCenter];
                            });
                            
                            
                            [YLUserInfo getuserInfoWithDic:dict[@"data"]];//存储登录信息
                            
                            NSLog(@"===%@",[YLUserInfo shareUserInfo].userName);
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [keychianTool saveToKeychainWithUserName:self.userNameTF.text withPassword:self.passwordTF.text];
                            });
                            NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
                            [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];//订阅聊天
                            NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            [defaults setObject:[YLUserInfo shareUserInfo].token forKey:executableFile];
                            [defaults synchronize];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                if (self.enterType==1) {
                                    YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
                                    APPLICATION.window.rootViewController = SectionTabbar;
                                }else{
                                    if (self.pushOrPresent) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                    }else{
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }
                                }
                            });
                        }
                        else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [EasyShowLodingView hidenLoding];
                                
                                [APPLICATION.window makeToast:dict[@"msg"] duration:1.5 position:CSToastPositionCenter];
                            });
                        }
                    }
                }
            }];
            [task resume];
            
//        }
    
        
//    }];
}




#pragma mark - CaptchaButtonDelegate

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    if ([NSString stringIsNull:self.userNameTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputMobileEmail") duration:1.5 position:CSToastPositionCenter];
        return NO;
    }
    if ([NSString stringIsNull:self.passwordTF.text]) {
        [self.view makeToast:LocalizationKey(@"inputLoginPassword") duration:1.5 position:CSToastPositionCenter];
        return NO;
    }else{
        return YES;
    }
}
#pragma mark-二次验证返回数据
- (void)delegateGtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    __block NSMutableString *postResult = [[NSMutableString alloc] init];
    [result enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL * stop) {
        [postResult appendFormat:@"%@=%@&",key,obj];
    }];
    [postResult appendFormat:@"%@", [NSString stringWithFormat:@"username=%@&password=%@",self.userNameTF.text,self.passwordTF.text]];
    
    NSLog(@"====%@",postResult);
    
    NSDictionary *headerFields = @{@"Content-Type":@"application/x-www-form-urlencoded;charset=UTF-8"};
    NSMutableURLRequest *secondaryRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",HOST,@"uc/login"]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    secondaryRequest.HTTPMethod = @"POST";
    secondaryRequest.allHTTPHeaderFields = headerFields;
    NSString*md5Str= [MD5 md5:[NSString stringWithFormat:@"%@%@%@",[keychianTool readUserUUID],self.userNameTF.text,self.passwordTF.text]];
    [secondaryRequest addValue: md5Str forHTTPHeaderField:@"access-auth-token"];
    secondaryRequest.HTTPBody = [postResult dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:secondaryRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [EasyShowLodingView hidenLoding];
        });
        [manager closeGTViewIfIsOpen];
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        //NSLog(@"请求头中%@",httpResponse.allHeaderFields);
        if (!error && httpResponse.statusCode == 200) {
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
            if (!err) {
                if ([dict[@"code"] integerValue] == 0) {
                    [YLUserInfo getuserInfoWithDic:dict[@"data"]];//存储登录信息
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [keychianTool saveToKeychainWithUserName:self.userNameTF.text withPassword:self.passwordTF.text];
                    });
                    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
                    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];//订阅聊天
                    NSString *executableFile = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];//获取项目名称
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[YLUserInfo shareUserInfo].token forKey:executableFile];
                    [defaults synchronize];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if (self.enterType==1) {
                            YLTabBarController *SectionTabbar = [[YLTabBarController alloc] init];
                            APPLICATION.window.rootViewController = SectionTabbar;
                        }else{
                            if (self.pushOrPresent) {
                                [self.navigationController popViewControllerAnimated:YES];
                            }else{
                                [self dismissViewControllerAnimated:YES completion:nil];
                            }
                        }
                    });
                }
                else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [APPLICATION.window makeToast:dict[@"message"] duration:1.5 position:CSToastPositionCenter];
                    });
                }
            }
        }
    }];
    [task resume];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
