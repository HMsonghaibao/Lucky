//
//  HomeViewController.m
//  bccoin
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 bccoinKEJI. All rights reserved.
//

#import "EcologyViewController.h"
#import "messageViewController.h"
#import "JKBannarView.h"
#import "symbolModel.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "bannerModel.h"
#import "CustomSectionHeader.h"
#import "pageScrollView.h"
#import "MineNetManager.h"
#import "PlatformMessageModel.h"
#import "listCell.h"
#import "SecondHeader.h"
#import "ChatGroupMessageViewController.h"
#import "ChatGroupInfoModel.h"
#import "ChatGroupFMDBTool.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "PlatformMessageDetailViewController.h"
#import "Marketmodel.h"
#import "RegisterViewController.h"
#import "ZLGestureLockViewController.h"
#import "GestureViewController.h"
#import "HomeRecommendTableViewCell.h"
#import "NoticeTableViewCell.h"
#import "HelpeCenterViewController.h"
#import "NoticeCenterViewController.h"
#import "VersionUpdateModel.h"
#import "noticeNewsCenterController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "TConversationListViewModel.h"
#import "EcologyTableViewCell.h"
#import "CountTableViewCell.h"
#import "MyteamTableViewCell.h"
#import "BiaogeTableViewCell.h"
#import "MiningmachineController.h"
#import "TeamManagerViewController.h"
@interface EcologyViewController ()<SocketDelegate,chatSocketDelegate>
{
    CGFloat _endDeceleratingOffset;//停止滚动的偏移量
    BOOL _comeIn;
}
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSMutableArray *bannerArr;
@property(nonatomic,strong)JKBannarView *bannerView;
@property(nonatomic,copy)NSMutableArray *platformMessageArr;
@property(nonatomic,strong)ChatGroupInfoModel *groupInfoModel;
@property(nonatomic,strong)UIImageView *tipImageView;
@property (nonatomic,strong)Marketmodel *marketmodel;

@property (nonatomic, strong)SecondHeader *sectionView;
@property (nonatomic, strong)VersionUpdateModel *versionModel;
@property(nonatomic,assign)NSInteger unreadcount;
@property (nonatomic, strong) TConversationListViewModel *viewModel;
@end

@implementation EcologyViewController

- (TConversationListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [TConversationListViewModel new];
        _viewModel.listFilter = ^BOOL(TUIConversationCellData * _Nonnull data) {
            return (data.convType != TIM_SYSTEM);
        };
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生态";
//    [self setTablewViewHeard];
//    [self headRefreshWithScrollerView:self.tableView];
//    [self getBannerData];
//    [self getUSDTToCNYRate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(launchImageViewDismiss) name:@"launchImageViewDismiss" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getunreadmassge) name:@"getunreadmassge" object:nil];
    
    
    @weakify(self)
    [RACObserve(self.viewModel, dataList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self gettencentUnReadCount];
    }];
}


- (void)getunreadmassge{
    [self getinvitationUnReadCount];
    [self getotcUnReadCount];
}


- (void)launchImageViewDismiss{
    [self gesturePassword];
    [self versionUpdate];
}

#pragma mark - 版本更新接口请求
//MARK:--版本更新接口请求
-(void)versionUpdate{
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"版本更新接口请求 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                // app当前版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSLog(@"app_Version ---- %@",app_Version);
                if ([app_Version compare:_versionModel.version] == NSOrderedSame ||[app_Version compare:_versionModel.version] == NSOrderedDescending) {
                    //不需要更新
                    
                }else{
                    
                    if ([self.versionModel.isForce isEqualToString:@"0"]) {
                        [LEEAlert alert].config
                        .LeeTitle(LocalizationKey(@"warmPrompt"))
                        .LeeAddContent(^(UILabel *label) {
                            label.text = @"当前有新的版本，请前往下载升级！";
                            label.font = [UIFont systemFontOfSize:16];
                        })
                        .LeeAddAction(^(LEEAction *action) {
                            action.title = LocalizationKey(@"ok");
                            action.titleColor = RGBCOLOR(43, 43, 43);
                            action.font = [UIFont systemFontOfSize:16];
                            action.clickBlock = ^{
                                //版本更新
                                NSURL *url = [NSURL URLWithString:_versionModel.downloadUrl];
                                if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                        if (@available(iOS 10.0, *)) {
                                            [[UIApplication sharedApplication] openURL:url options:@{}
                                                                     completionHandler:^(BOOL success) {
                                                                         
                                                                     }];
                                        } else {
                                            
                                        }
                                    } else {
                                        BOOL success = [[UIApplication sharedApplication] openURL:url];
                                        if (success) {
                                            
                                        }else{
                                            
                                        }
                                    }
                                    
                                } else{
                                    bool can = [[UIApplication sharedApplication] canOpenURL:url];
                                    if(can){
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                }
                            };
                        })
                        
                        .LeeAddAction(^(LEEAction *action){
                            action.title = LocalizationKey(@"cancel");
                            action.titleColor = RGBCOLOR(43, 43, 43);
                            action.font = [UIFont systemFontOfSize:16];
                            action.clickBlock = ^{
                                
                            };
                            
                        })
                        .LeeShow();
                    }else{
                        [LEEAlert alert].config
                        .LeeTitle(LocalizationKey(@"warmPrompt"))
                        .LeeAddContent(^(UILabel *label) {
                            label.text = @"当前有新的版本，请前往下载升级！";
                            label.font = [UIFont systemFontOfSize:16];
                        })
                        .LeeAddAction(^(LEEAction *action) {
                            action.title = LocalizationKey(@"ok");
                            action.titleColor = RGBCOLOR(43, 43, 43);
                            action.font = [UIFont systemFontOfSize:16];
                            action.clickBlock = ^{
                                //版本更新
                                NSURL *url = [NSURL URLWithString:_versionModel.downloadUrl];
                                if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                                    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                                        if (@available(iOS 10.0, *)) {
                                            [[UIApplication sharedApplication] openURL:url options:@{}
                                                                     completionHandler:^(BOOL success) {
                                                                         
                                                                     }];
                                        } else {
                                            
                                        }
                                    } else {
                                        BOOL success = [[UIApplication sharedApplication] openURL:url];
                                        if (success) {
                                            
                                        }else{
                                            
                                        }
                                    }
                                    
                                } else{
                                    bool can = [[UIApplication sharedApplication] canOpenURL:url];
                                    if(can){
                                        [[UIApplication sharedApplication] openURL:url];
                                    }
                                }
                            };
                        })
                        .LeeShow();
                    }
                    
                    
                    
                    
                }
                
            }else if ([resPonseObj[@"code"] integerValue]==4000||[resPonseObj[@"code"] integerValue]==3000){
                
            }else if ([resPonseObj[@"code"] integerValue] == 500) {
                //无版本更新，不提示
            }else{
                
            }
        }else{
            
        }
    }];
    
}


#pragma mark - 提示用户开启手势密码
- (void)gesturePassword{
    if ([ZLGestureLockViewController gesturesPassword].length > 0) {
        //已经创建手势密码
    }else{
        //提示用户开启手势密码
        if (![[NSUserDefaults standardUserDefaults] boolForKey:kShowGesturePassword]) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 0, 200, 20);
            btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [btn setTitle:LocalizationKey(@"noLongerReminding") forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitleColor:RGBOF(0xe6e6e6) forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"walletNoSelect"] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:@"walletSelected"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(Nolongerreminding:) forControlEvents:UIControlEventTouchUpInside];
            
            [LEEAlert alert].config
            .LeeHeaderColor(mainColor)
            .LeeAddTitle(^(UILabel *label) {
                label.text = LocalizationKey(@"warmPrompt");
                label.textColor = RGBOF(0xe6e6e6);
            })
            .LeeAddContent(^(UILabel *label) {
                label.text = LocalizationKey(@"RemindingMessage");
                label.font = [UIFont systemFontOfSize:16];
                label.textColor = RGBOF(0xe6e6e6);
            })
            .LeeAddCustomView(^(LEECustomView *custom) {
                
                custom.view = btn;
                
                custom.positionType = LEECustomViewPositionTypeLeft;
            })
            .LeeItemInsets(UIEdgeInsetsMake(10, 0, -10, 0))
            .LeeAddAction(^(LEEAction *action) {
                action.title = LocalizationKey(@"ok");
                action.titleColor = RGBOF(0xe6e6e6);
                action.font = [UIFont systemFontOfSize:16];
                action.clickBlock = ^{
                    GestureViewController *safeVC = [[GestureViewController alloc] init];
                    safeVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:safeVC animated:YES];
                };
            })
            .LeeAddAction(^(LEEAction *action) {
                action.title = LocalizationKey(@"cancel");
                action.titleColor = RGBOF(0xe6e6e6);
                action.font = [UIFont systemFontOfSize:16];
            })
            .LeeShow();
        }
    }
}

- (void)Nolongerreminding:(UIButton *)sender{
    sender.selected = !sender.selected;
    [[NSUserDefaults standardUserDefaults] setBool:sender.selected forKey:kShowGesturePassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//MARK:--自定义导航栏消息按钮
-(void)rightButton{
    UIButton * issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
//    [issueButton setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [issueButton setTitle:@"账单" forState:0];
    [issueButton addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    self.tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 10, 10)];
    self.tipImageView.hidden = YES;
    self.tipImageView.image = [UIImage imageNamed:@"chatTipImage"];
    [issueButton addSubview:self.tipImageView];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}

- (void)leftItem{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 116, 44)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = [UIImage imageNamed:@"logo-huite"];
    //添加到导航条
//    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:imageView];
//    self.navigationItem.leftBarButtonItem = leftBarButtomItem;
    self.navigationItem.titleView = imageView;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self rightButton];
//    [self leftItem];
    [self getData];
    [self getNotice];
    [self getindex_infodata];
    
    self.unreadcount = 0;
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmassge) name:@"getmassge" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmassgeendStr:) name:@"getmassgeendStr" object:nil];
    
    //获取未读数
    [self getinvitationUnReadCount];
    [self getotcUnReadCount];
    [self gettencentUnReadCount];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self gettencentUnReadCount];
//    });
}



#pragma  mark-获取未读数
-(void)getinvitationUnReadCount{
    
    if (![YLUserInfo isLogIn]) {//未登录
        return;
    }
    
    [MineNetManager getUnReadCountFortype:@"INVITATION" nameid:[YLUserInfo shareUserInfo].ID CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"===%@",resPonseObj);
        
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSInteger unreadcount = [resPonseObj[@"data"] integerValue];
                self.unreadcount = self.unreadcount + unreadcount;
                if (self.unreadcount > 0) {
                    self.tipImageView.hidden = NO;
                }else{
                    self.tipImageView.hidden = YES;
                }
                
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}

-(void)getotcUnReadCount{
    
    if (![YLUserInfo isLogIn]) {//未登录
        return;
    }
    
    [MineNetManager getUnReadCountFortype:@"NOTICE_OTC" nameid:[YLUserInfo shareUserInfo].ID CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"===%@",resPonseObj);
        
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSInteger unreadcount = [resPonseObj[@"data"] integerValue];
                self.unreadcount = self.unreadcount + unreadcount;
                if (self.unreadcount > 0) {
                    self.tipImageView.hidden = NO;
                }else{
                    self.tipImageView.hidden = YES;
                }
                
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}


//MARK:--国际化通知处理事件
- (void)languageSetting{
    [self getBannerData];
    [self getNotice];
}


-(void)getmassgeendStr:(NSNotification*)noti{
    NSMutableArray *chatGroupArr = [ChatGroupFMDBTool getChatGroupDataArr];
    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
        if ([infoModel.flagIndex isEqualToString:@"1"]) {
            self.tipImageView.hidden = NO;
        }
    }
    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
        if (![infoModel.flagIndex isEqualToString:@"1"]) {
            self.tipImageView.hidden = YES;
        }
    }
    [self setSound];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (!_comeIn) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"launchImageViewDismiss" object:nil];
        _comeIn = YES;
    }
    
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=self;
    if ([YLUserInfo isLogIn]) {
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
        [ChatSocketManager share].delegate = self;
    }
//    NSMutableArray *chatGroupArr = [ChatGroupFMDBTool getChatGroupDataArr];
//    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
//        if ([infoModel.flagIndex isEqualToString:@"1"]) {
//            self.tipImageView.hidden = NO;
//
//            self.unreadcount = self.unreadcount + 1;
//        }
//    }
//    for (ChatGroupInfoModel *infoModel in chatGroupArr) {
//        if (![infoModel.flagIndex isEqualToString:@"1"]) {
//            self.tipImageView.hidden = YES;
//        }
//    }
    
    
    
    
    
}


-(void)gettencentUnReadCount{
    
    if (![YLUserInfo isLogIn]) {//未登录
        return;
    }
    
    //获取未读计数
    int unReadCount = 0;
    NSArray *convs = [[TIMManager sharedInstance] getConversationList];
    for (TIMConversation *conv in convs) {
        if([conv getType] == TIM_SYSTEM){
            continue;
        }
        unReadCount += [conv getUnReadMessageNum];
    }
    self.unreadcount = self.unreadcount + unReadCount;
    NSLog(@"===%d===%ld",unReadCount,self.unreadcount);
    if (self.unreadcount > 0) {
        self.tipImageView.hidden = NO;
    }else{
        self.tipImageView.hidden = YES;
    }
}



#pragma mark-首页累计数据
-(void)getindex_infodata{
    [MineNetManager Getindex_infoCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"首页累计数据 ---- %@", resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSDictionary *dic = [resPonseObj objectForKey:@"data"];
                self.marketmodel = [Marketmodel mj_objectWithKeyValues:dic];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

#pragma mark-获取平台消息
-(void)getNotice{
    [MineNetManager getPlatformMessageForCompleteHandleWithPageNo:@"1" withPageSize:@"20" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.platformMessageArr removeAllObjects];
                NSArray *arr = resPonseObj[@"data"][@"content"];
                NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
                for (NSDictionary *dic in arr) {
                    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
                        if (![self hasChinese:dic[@"title"]]) {
                            [muArr addObject:dic];
                        }
                    }else{
                        if ([self hasChinese:dic[@"title"]]) {
                            [muArr addObject:dic];
                        }
                    }
                }
                NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:muArr];
                [self.platformMessageArr addObjectsFromArray:dataArr];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}

- (BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

-(void)RighttouchEvent{
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
        return;
    }
    self.tipImageView.hidden = YES;
//    ChatGroupMessageViewController *groupVC = [[ChatGroupMessageViewController alloc] init];
//    groupVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:groupVC animated:YES];
    
    TeamManagerViewController *groupVC = [[TeamManagerViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
    
    
}
-(void)setTablewViewHeard{
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeRecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell1"];
    [self.tableView registerNib:[UINib nibWithNibName:@"listCell" bundle:nil] forCellReuseIdentifier:@"Cell2"];
     [self.tableView registerNib:[UINib nibWithNibName:@"NoticeTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoticeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"EcologyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EcologyTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyteamTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyteamTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BiaogeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BiaogeTableViewCell"];
    
    UIView *hedaview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW,  170 * kWindowWHOne )];
    hedaview.backgroundColor = mainColor;
    self.bannerView = [[JKBannarView alloc]initWithFrame:CGRectMake(0, 10 * kWindowWHOne, kWindowW, 150 * kWindowWHOne) viewSize:CGSizeMake(kWindowW,150 * kWindowWHOne)];
    if (self.bannerArr.count > 0) {
        NSMutableArray *muArr = [NSMutableArray arrayWithCapacity:0];
        for (bannerModel *model in self.bannerArr) {
            [muArr addObject:model.url];
        }
        self.bannerView.items = muArr;
    }
//    [hedaview addSubview:self.bannerView];
    //轮播图事件方法
    __weak typeof(self)weakself = self;
    [self.bannerView  imageViewClick:^(JKBannarView * _Nonnull barnerview, NSInteger index) {
        bannerModel *banner = weakself.bannerArr[index];
        if (banner.linkUrl) {
            NSURL *url = [NSURL URLWithString:banner.linkUrl];
            if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{}
                                                 completionHandler:^(BOOL success) {
                                                     
                                                 }];
                    } else {
                        
                    }
                } else {
                    BOOL success = [[UIApplication sharedApplication] openURL:url];
                    if (success) {
                        
                    }else{
                        
                    }
                }
                
            } else {
                bool can = [[UIApplication sharedApplication] canOpenURL:url];
                if(can){
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }
        
    }];
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
//    self.tableView.tableHeaderView=hedaview ;
    self.tableView.tableFooterView=[UIView new];

    if (@available(iOS 11.0, *)){
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;//防止刷新指定行时，偏移量改变
    }
    
}


-(void)getBannerData{

    NSString*language=@"";
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        language = @"en_us";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        language = @"zh_cn";
    }
    
    [HomeNetManager advertiseBanner:(NSString*)language CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"首页轮播图 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.bannerArr removeAllObjects];
                [self.bannerArr addObjectsFromArray:[bannerModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]]];
                if (self.bannerArr.count>0) {
                    [self configUrlArrayWithModelArray:self.bannerArr];
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section==0) {
        return 146 * kWindowWHOne;
    }else if (indexPath.section == 1){
        return 190;
    }else if (indexPath.section == 2){
        return 129;
    }else{
        return 121;
    }
}
-(void)configUrlArrayWithModelArray:(NSMutableArray*)array{
    NSMutableArray*urlArray=[NSMutableArray arrayWithCapacity:0];
    for (int i=0; i<array.count; i++) {
        bannerModel*model=array[i];
        [urlArray addObject:model.url];
    }
    self.bannerView.items=urlArray;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        BiaogeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BiaogeTableViewCell"];
        cell.backgroundColor = [UIColor redColor];
        return cell;

    }else if (indexPath.section == 1){

        EcologyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EcologyTableViewCell" forIndexPath:indexPath];
//        cell.transactionlabel.text = LocalizationKey(@"Currencyexchange");
//        cell.safelabel.text = LocalizationKey(@"buyingandsellingmoney");
//        cell.helplebel.text = LocalizationKey(@"Helpcenter");
//        cell.problemlabel.text = LocalizationKey(@"Findmeproblem");
//
//        cell.noticelabel.text = LocalizationKey(@"Noticecenter");
//        cell.noticecontentlabel.text = LocalizationKey(@"BulletinBoard");

        cell.CtoCBlock = ^{
            [self.tabBarController setSelectedIndex:3];
        };
        cell.backgroundColor = [UIColor blueColor];
        return cell;
    }else if (indexPath.section == 2){
        
        CountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CountTableViewCell" forIndexPath:indexPath];
        //        cell.transactionlabel.text = LocalizationKey(@"Currencyexchange");
        //        cell.safelabel.text = LocalizationKey(@"buyingandsellingmoney");
        //        cell.helplebel.text = LocalizationKey(@"Helpcenter");
        //        cell.problemlabel.text = LocalizationKey(@"Findmeproblem");
        //
        //        cell.noticelabel.text = LocalizationKey(@"Noticecenter");
        //        cell.noticecontentlabel.text = LocalizationKey(@"BulletinBoard");
        cell.backgroundColor = [UIColor yellowColor];
        return cell;
    }else{
        MyteamTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyteamTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor brownColor];
        return cell;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section==2) {
        MiningmachineController*klineVC=[[MiningmachineController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:klineVC];
        
    }
}
#pragma mark-获取首页推荐信息
-(void)getData{
    [HomeNetManager HomeDataCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取首页推荐信息 --- %@",resPonseObj);
        [self.contentArr removeAllObjects];
        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
            NSArray *recommendArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"recommend"]];
            NSArray *changeRankArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"changeRank"]];
            if (changeRankArr&&recommendArr) {
                [self.contentArr addObject:recommendArr];//推荐
                [self.contentArr addObject:changeRankArr];//涨幅榜
                
                [self.tableView reloadData];
            }
            symbolModel*model = [recommendArr firstObject];
            if (![marketManager shareInstance].symbol) {
                [marketManager shareInstance].symbol=model.symbol;//默认第一个
            }
        }else{
            
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
#pragma mark-自定义section头部的高度
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 1 ) {
//        return  10;
//    }
//    if (section == 0) {
//        return 40;
//    }
//    return 45;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        if (self.platformMessageArr.count>0) {
//            NSMutableArray*titleArray=[[NSMutableArray alloc]init];
//            [self.platformMessageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                PlatformMessageModel*model=self.platformMessageArr[idx];
//                [titleArray addObject:model.title];
//            }];
//            CustomSectionHeader*sectionView=[CustomSectionHeader instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 30)];
//            [sectionView.morebut setTitle:[NSString stringWithFormat:@"%@>>", LocalizationKey(@"morekline")] forState:UIControlStateNormal];
//            pageScrollView *noticeView = [[pageScrollView alloc] initWithFrame:CGRectMake(40, 0, kWindowW-110, 30)];
//            noticeView.BGColor = mainColor;
//            noticeView.titleArray =titleArray;
//            __weak EcologyViewController*weakSelf=self;
//            [noticeView clickTitleLabel:^(NSInteger index,NSString *titleString) {
//                PlatformMessageModel*model=self.platformMessageArr[index-100];
//                PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
//                detailVC.hidesBottomBarWhenPushed = YES;
//                detailVC.content = model.content;
//                detailVC.type = @"1";
//                detailVC.navtitle = model.title;
//                [weakSelf.navigationController pushViewController:detailVC animated:YES];
//
//            }];
//            [sectionView addSubview:noticeView];
//
//            sectionView.moreBlock = ^{
//                NoticeCenterViewController *helpVC = [NoticeCenterViewController new];
//                helpVC.hidesBottomBarWhenPushed = YES;
//                [self.navigationController pushViewController:helpVC animated:YES];
//
//            };
//
//            return sectionView;
//        }else{
//            UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 30)];
//            view.backgroundColor=mainColor;
//            return view;
//        }
//    }else if (section == 1 ){
//
//        UIView * headview = [[UIView alloc]init];
//        return headview;
//    }
//
//    else{
////        SecondHeader*sectionView=[SecondHeader instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 45)];
//        [self.sectionView.upbutton setTitle:LocalizationKey(@"Top") forState:UIControlStateNormal];
//        return self.sectionView;
//
//    }
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (section == 1) {
//        return 10;
//    }
//    return 0.01;
//
//}

-(SecondHeader *)sectionView{
    if (!_sectionView) {
        _sectionView = [SecondHeader instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 45)];
    }
    return _sectionView;
}
#pragma mark-下拉刷新数据
- (void)refreshHeaderAction{
    [self getBannerData];
    [self getData];
    [self getindex_infodata];

}

- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
#pragma mark - SocketDelegate Delegate
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    if (cmd==SUBSCRIBE_GROUP_CHAT) {
        NSLog(@"订阅聊天组成功");
    }
    else if (cmd==UNSUBSCRIBE_GROUP_CHAT) {
        NSLog(@"取消订阅聊天组成功");
    }
    else if (cmd==SEND_CHAT) {//发送消息
        if (endStr) {
            NSLog(@"发送消息--%@-收到的回复命令--%d",endStr,cmd);
        }
    }
    else if (cmd==PUSH_GROUP_CHAT)//收到消息
    {
        
        if (endStr) {
            NSDictionary *dic =[SocketUtils dictionaryWithJsonString:endStr];
            //            NSLog(@"接受消息--收到的回复-%@--%d--",dic,cmd);
            _groupInfoModel = [ChatGroupInfoModel mj_objectWithKeyValues:dic];
            //存入数据库
            //NSLog(@"--%@",_groupInfoModel.content);
            [ChatGroupFMDBTool createTable:_groupInfoModel withIndex:1];
//            [self setSound];
            self.tipImageView.hidden = NO;
        }
    }else{
        //        NSLog(@"首页聊天消息-%@--%d",endStr,cmd);
    }
}
//MARK:--设置音效
-(void)setSound{
    NSURL *url = [[NSBundle mainBundle]URLForResource:@"m_click" withExtension:@"wav"];
    //对该音效标记SoundID
    SystemSoundID soundID1 = 0;
    //加载该音效
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID1);
    //播放该音效
    AudioServicesPlaySystemSound(soundID1);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.y;
    _endDeceleratingOffset = offsetX;
}
#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{

    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {

        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
        //推荐
        if (self.contentArr.count>0) {
            NSMutableArray*recommendArr=(NSMutableArray*)self.contentArr[0];
            [recommendArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqualToString:model.symbol]) {
                    [recommendArr  replaceObjectAtIndex:idx withObject:model];
                    *stop = YES;
                   
                    [self.tableView reloadData];
                }
            }];
            //涨幅榜
            if (self.contentArr.count < 1) {
                return;
            } NSMutableArray*changeRankArr=(NSMutableArray*)self.contentArr[1];
            [changeRankArr enumerateObjectsUsingBlock:^(symbolModel*  obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.symbol isEqualToString:model.symbol]) {
                    [changeRankArr  replaceObjectAtIndex:idx withObject:model];
                    *stop = YES;
                    [self.tableView reloadData];
                }
            }];
        }
    }else if (cmd==UNSUBSCRIBE_SYMBOL_THUMB){
        NSLog(@"取消订阅首页消息");
        
    }else{
        
    }
    //    NSLog(@"首页消息-%@--%d",endStr,cmd);
}

#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    [MarketNetManager getusdTocnyRateCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate = [NSDecimalNumber decimalNumberWithString:[resPonseObj[@"data"] stringValue]];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (NSMutableArray *)platformMessageArr {
    if (!_platformMessageArr) {
        _platformMessageArr = [NSMutableArray array];
    }
    return _platformMessageArr;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=nil;
    
    
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [ChatSocketManager share].delegate=nil;
    
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getmassgeendStr" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSMutableArray *)bannerArr{
    if (!_bannerArr) {
        _bannerArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _bannerArr;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
