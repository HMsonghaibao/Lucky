//
//  MineViewController.m
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "AccountSettingViewController.h"
#import "MyBillViewController.h"
#import "MyAdvertisingViewController.h"
#import "SettingCenterViewController.h"
#import "WalletManageViewController.h"
#import "IdentityAuthenticationViewController.h"
#import "GestureViewController.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"
#import "UIImageView+WebCache.h"
#import "WalletManageModel.h"
#import "NSUserDefaultUtil.h"
#import "MyEntrustViewController.h"
#import "VersionUpdateModel.h"
#import "MineTableHeadView.h"
#import "LoginNetManager.h"
#import "MyassetsTableViewCell.h"
#import "MyincomeTableViewCell.h"
#import "CurrencyexchangeTableViewCell.h"
#import "InvitefriendsTableViewCell.h"
#import "TeammanagementTableViewCell.h"
#import "AdministrationTableViewCell.h"
#import "WalletManageDetailViewController.h"
#import "PaymentAccountViewController.h"
#import "EntrustmentRecordViewController.h"
#import "RecommendedRewardController.h"
#import "PartnerincomeController.h"
#import "FeeincomeController.h"
#import "LockwarehouseController.h"
#import "TeamManagerViewController.h"
#import "InvitefriendsViewController.h"
#import "MyteamTableViewCell.h"
#import "MyrewardTableViewCell.h"
#import "WinningrecordController.h"
#import "SweepstakesViewController.h"
#import "LotteryListViewController.h"
#import "RecordDetailController.h"
#import "LotteryInviteViewController.h"
#import "InvitePartnerViewController.h"
#import "PartnerSubViewController.h"
#import "OrdinaryTeamViewController.h"
#import "MyinvestmentTableViewCell.h"
#import "InvestmentIncomeViewController.h"
#import "InvestRecordViewController.h"
#import "InvestmentSubViewController.h"
#import "InvestmentdetailController.h"
#import "MyincomeListController.h"
#import "CommonlistViewCell.h"
#import "MoneyPasswordViewController.h"
#import "MentionCoinInfoModel.h"
#import "AddMentionCoinAddressViewController.h"
#import "YaoqingViewController.h"
#import "TibiaddsViewController.h"
#import "MyLuckyTeamViewController.h"
#import "MyLuckyLockViewController.h"
#import "ForgetView1Controller.h"
#import "ForgetPayViewController.h"
#import "InvitefriendsViewController.h"
#import "LockRecordViewController.h"
#import "PlatformMessageDetailViewController.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,chatSocketDelegate>{
    BOOL updateFlag;
    UIView *_tableHeadView;
    UIView *_tableFootView;
    BOOL _isPush;//防止每次点击进入出现动画
    BOOL _realVerified;
    BOOL _fundsVerified;
    RKNotificationHub *_updateHub;
    dispatch_group_t group;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,strong) NSMutableArray *assetTotalArr;
@property(nonatomic,copy)NSString *assetUSD;
@property(nonatomic,copy)NSString *assetCNY;
@property(nonatomic,copy)NSString *assetUSD1;
@property(nonatomic,copy)NSString *assetCNY1;
@property(nonatomic,strong)VersionUpdateModel *versionModel;
@property(nonatomic,strong) MineTableHeadView *headerView;
@property (nonatomic,assign)NSInteger memberLevel;
@property (nonatomic, assign)NSInteger userType;
@property(nonatomic,strong) NSMutableDictionary *bannerDic;
@property (nonatomic, assign)NSInteger isInvestType;
@property (nonatomic, assign)NSInteger banarIndex;
@property (nonatomic, assign)NSInteger lastIndex;
@property(nonatomic,strong) NSArray *getImageArr;
@property(nonatomic,strong) NSArray *getNameArr;
@property(nonatomic,strong) NSArray *getImageArr1;
@property(nonatomic,strong) NSArray *getNameArr1;
@property(nonatomic,strong)NSMutableArray *mentionCoinArr;
@property(nonatomic,strong)MentionCoinInfoModel *model;
@property(nonatomic,copy)NSString *aboutus;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    group = dispatch_group_create();
    
    self.view.backgroundColor = [UIColor colorWithRed:8/255.0 green:23/255.0 blue:35/255.0 alpha:1/1.0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeState) name:@"pushToMine" object:nil];

    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineTableViewCell class])];
     [self.tableView registerNib:[UINib nibWithNibName:@"MyassetsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyassetsTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyincomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyincomeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyteamTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyteamTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyrewardTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyrewardTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyinvestmentTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyinvestmentTableViewCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"CurrencyexchangeTableViewCell" bundle:nil] forCellReuseIdentifier:@"CurrencyexchangeTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"InvitefriendsTableViewCell" bundle:nil] forCellReuseIdentifier:@"InvitefriendsTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeammanagementTableViewCell" bundle:nil] forCellReuseIdentifier:@"TeammanagementTableViewCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"AdministrationTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdministrationTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommonlistViewCell" bundle:nil] forCellReuseIdentifier:@"CommonlistViewCell"];
    
//    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 145 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
    
//    if (kWindowW==320) {
//        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 150 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
//    }else if (kWindowW==375){
//        if (kWindowH==812) {
//            _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 125 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
//        }else{
//            _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 150 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
//        }
//    }else if (kWindowW==414){
//        if (kWindowH==896) {
//            _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 150 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
//        }else{
//            _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 150 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
//        }
//    }else {
//        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 125 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
//    }
//    [self mentionCoinInfo];
    
    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, 157 * kWindowWHOne + (kWindowH == 812.0 ? 24 : 0))];
    
    
    self.tableView.tableHeaderView = _tableHeadView;
    self.headerView=[[[MineTableHeadView alloc]init] instancetableHeardViewWithFrame:_tableHeadView.frame];
    _updateHub = [[RKNotificationHub alloc] initWithView:self.headerView.setbutton];
    [_updateHub scaleCircleSizeBy:0.3];
    [_updateHub hideCount];
    [self.headerView.headButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.headButton.tag = 1;
    
    [self.headerView.setbutton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.setbutton.tag = 2;

    [self.headerView.safebutton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.safebutton.tag = 3;
    
    [_tableHeadView addSubview:self.headerView];
    self.assetTotalArr = [[NSMutableArray alloc] init];
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    
}



//MARK:--获取数据
-(void)getParterData{
    //    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        bodydic[@"language"] = @"en_us";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        bodydic[@"language"] = @"zh_cn";
    }
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryMemberPartnerParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        //        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.aboutus = resPonseObj[@"data"];
                [self.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}



#pragma mark - 版本更新接口请求
//MARK:--版本更新接口请求
-(void)versionUpdate{
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"版本更新接口请求 --- %@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"status"] integerValue] == 0) {
                self.versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                // app当前版本
                 NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                NSLog(@"app_Version ---- %@",app_Version);
                if ([app_Version compare:_versionModel.version] == NSOrderedSame ||[app_Version compare:_versionModel.version] == NSOrderedDescending) {
                    //不需要更新
                    updateFlag = NO;
                    [_updateHub decrementBy:0];
                }else{
                    [_updateHub increment];
                    updateFlag = YES;
                }
                if (!kUpdateAppStore) {

                    [self.tableView reloadData];
                }
                
            }else if ([resPonseObj[@"status"] integerValue]==4000||[resPonseObj[@"status"] integerValue]==3000){
                [YLUserInfo logout];
                
            }else if ([resPonseObj[@"status"] integerValue] == 500) {
                //无版本更新，不提示
            }else{
                
            }
        }else{
            
        }
    }];
    
}


-(void)mentionCoinInfo{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager mentionCoinInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"获取提币信息 ---- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //[self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                NSArray *dataArr = [MentionCoinInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.mentionCoinArr addObjectsFromArray:dataArr];
                
                [self arrageData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--整理数据
-(void)arrageData{
    for (MentionCoinInfoModel *mentionModel in self.mentionCoinArr) {
        self.model = mentionModel;
    }
}

- (NSMutableArray *)mentionCoinArr {
    if (!_mentionCoinArr) {
        _mentionCoinArr = [NSMutableArray array];
    }
    return _mentionCoinArr;
}

//MARK:--国际化通知处理事件
- (void)languageSetting{

    [self.tableView reloadData];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LanguageChange object:nil];
}

- (void)changeState{
    _isPush = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self versionUpdate];
    
    if (!_isPush) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    if(![YLUserInfo isLogIn]){
        _tableFootView.hidden = YES;
        //没登录不做处理
        self.headerView.headImage.image = [UIImage imageNamed:@"defaultImage"];
        self.headerView.userName.text = [[ChangeLanguage bundle] localizedStringForKey:@"userName" value:nil table:@"English"];
        self.headerView.account.text = [[ChangeLanguage bundle] localizedStringForKey:@"accounting" value:nil table:@"English"];
      
    }else{
         _tableFootView.hidden = NO;
        [self accountSettingData];
        [self getTotalAssets];
        [self getTotalData];
        [self businessstatus];
        [self getParterData];
//        [self getTotalReward];
//        [self getRecommandRewardTotal];
//        [self getqueryMemberAssetTotal];
//        [self isInvest];
        
    }
    
//    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
//        if (self.lastIndex > 0) {
//            MyassetsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//            [cell scrollTopPage: self.lastIndex];
//        }
    });
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    if (self.banarIndex > 0) {
//        MyassetsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//        [cell scrollTopPage:self.banarIndex];
//    }
}

-(NSArray *)getImageArr{
    NSArray * imageArr = @[@"my-lock",@"my-notice",@"my-info",@"my-team",@"my-share",@"my-loginp",@"my-payp",@"my-about"];
    return imageArr;
}
-(NSArray *)getNameArr{
    
    NSArray * nameArr = @[LocalizationKey(@"Releaseassets"),LocalizationKey(@"Noticetttt"),LocalizationKey(@"Personalinformation"),LocalizationKey(@"myteam"),LocalizationKey(@"Iwanttoshare"),LocalizationKey(@"Modifytheloginpassword"),LocalizationKey(@"Modifypaymentpassword"),LocalizationKey(@"aboutus")];
    return nameArr;
}


-(NSArray *)getImageArr1{
    NSArray * imageArr = @[@"my-notice",@"my-info",@"my-team",@"my-share",@"my-loginp",@"my-payp",@"my-about"];
    return imageArr;
}
-(NSArray *)getNameArr1{
    
    NSArray * nameArr = @[LocalizationKey(@"Noticetttt"),LocalizationKey(@"Personalinformation"),LocalizationKey(@"myteam"),LocalizationKey(@"Iwanttoshare"),LocalizationKey(@"Modifytheloginpassword"),LocalizationKey(@"Modifypaymentpassword"),LocalizationKey(@"aboutus")];
    return nameArr;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.lastIndex = self.banarIndex;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(![YLUserInfo isLogIn]){
        return 7;
    }else{
        if ([self.accountInfo.noteLevel isEqualToString:@"0"]) {
            return 7;
        }else{
            return 8;
        }
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonlistViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonlistViewCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    
    if(![YLUserInfo isLogIn]){
        NSArray*imagearr = self.getImageArr1;
        [cell.imageBtn setImage:[UIImage imageNamed:imagearr[indexPath.row]] forState:0];
        NSArray*titlearr = self.getNameArr1;
        cell.titleL.text = titlearr[indexPath.row];
    }else{
        if ([self.accountInfo.noteLevel isEqualToString:@"0"]) {
            NSArray*imagearr = self.getImageArr1;
            [cell.imageBtn setImage:[UIImage imageNamed:imagearr[indexPath.row]] forState:0];
            NSArray*titlearr = self.getNameArr1;
            cell.titleL.text = titlearr[indexPath.row];
        }else{
            NSArray*imagearr = self.getImageArr;
            [cell.imageBtn setImage:[UIImage imageNamed:imagearr[indexPath.row]] forState:0];
            NSArray*titlearr = self.getNameArr;
            cell.titleL.text = titlearr[indexPath.row];
        }
    }
    
    
    
    return cell;
}

//MARK:--头像点击事件  账号设置
- (IBAction)btnClick:(UIButton *)sender {
  
   
        //判断用户是否已经登录
        if(![YLUserInfo isLogIn]){
            [self showLoginViewController];
        }else{
            
        }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
    }else{
        
        if ([self.accountInfo.noteLevel isEqualToString:@"0"]) {
            if (indexPath.row == 0){
                //身份认证
                LockRecordViewController *walletVC = [LockRecordViewController new];
                walletVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:walletVC animated:YES];
            }else if (indexPath.row == 1){
                AccountSettingViewController *addressVC = [[AccountSettingViewController alloc] init];
                addressVC.hidesBottomBarWhenPushed = YES;
                //                addressVC.delegate = self;
                
                //        NSMutableArray*arr = [NSMutableArray mj_keyValuesArrayWithObjectArray:self.model.addresses];
                
                //        addressVC.addressInfoArr = self.model.addresses;
                [self.navigationController pushViewController:addressVC animated:YES];
            }else if (indexPath.row == 2){
                MyLuckyTeamViewController *payVC = [[MyLuckyTeamViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:payVC];
                
            }else if (indexPath.row == 3){
                InvitefriendsViewController *accountVC = [[InvitefriendsViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:accountVC];
            }else if (indexPath.row == 4){
                ForgetView1Controller *billVC = [[ForgetView1Controller alloc] init];
                billVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:billVC animated:YES];
            }else if (indexPath.row == 5){
                ForgetPayViewController *billVC = [[ForgetPayViewController alloc] init];
                billVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:billVC animated:YES];
            }else{
                PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
                detailVC.type = @"1";
                detailVC.content = self.aboutus;
                detailVC.navtitle = @"关于我们";
                [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
            }
        }else{
            if (indexPath.row == 0) {
                //我的资产
                MyLuckyLockViewController *walletVC = [MyLuckyLockViewController new];
                walletVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:walletVC animated:YES];
            }else if (indexPath.row == 1){
                //身份认证
                LockRecordViewController *walletVC = [LockRecordViewController new];
                walletVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:walletVC animated:YES];
            }else if (indexPath.row == 2){
                AccountSettingViewController *addressVC = [[AccountSettingViewController alloc] init];
                addressVC.hidesBottomBarWhenPushed = YES;
                //                addressVC.delegate = self;
                
                //        NSMutableArray*arr = [NSMutableArray mj_keyValuesArrayWithObjectArray:self.model.addresses];
                
                //        addressVC.addressInfoArr = self.model.addresses;
                [self.navigationController pushViewController:addressVC animated:YES];
            }else if (indexPath.row == 3){
                MyLuckyTeamViewController *payVC = [[MyLuckyTeamViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:payVC];
                
            }else if (indexPath.row == 4){
                InvitefriendsViewController *accountVC = [[InvitefriendsViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:accountVC];
            }else if (indexPath.row == 5){
                ForgetView1Controller *billVC = [[ForgetView1Controller alloc] init];
                billVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:billVC animated:YES];
            }else if (indexPath.row == 6){
                ForgetPayViewController *billVC = [[ForgetPayViewController alloc] init];
                billVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:billVC animated:YES];
            }else{
                PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
                detailVC.type = @"1";
                detailVC.content = self.aboutus;
                detailVC.navtitle = @"关于我们";
                [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
            }
        }
        
        
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52;
}


-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView*footView = [UIView new];
    footView.backgroundColor = [UIColor colorWithRed:8/255.0 green:23/255.0 blue:35/255.0 alpha:1/1.0];
    return footView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


//MARK:--滚动列表
-(void)getqueryMemberAssetTotal{
    dispatch_group_enter(group);
    [MineNetManager getqueryMemberAssetTotalForCompleteHandle:^(id resPonseObj, int code) {
        
        NSLog(@"===%@",resPonseObj);
        dispatch_group_leave(group);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                self.bannerDic = resPonseObj[@"data"];
                NSLog(@"===%@",self.bannerDic);
//                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--是否已投过资
-(void)isInvest{
    dispatch_group_enter(group);
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager isInvestParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        dispatch_group_leave(group);
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.isInvestType = [resPonseObj[@"data"] integerValue];
//                [self.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--我的收益
-(void)getTotalReward{
    [MineNetManager getTotalRewardForCompleteHandle:^(id resPonseObj, int code) {
        
        NSLog(@"===%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                self.assetUSD1 = [NSString stringWithFormat:@"%.6f",[resPonseObj[@"data"][@"usdtTotal"] doubleValue]];
                self.assetCNY1  = [NSString stringWithFormat:@"≈%.2fCNY",[resPonseObj[@"data"][@"cnyTotal"] doubleValue]];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--推荐奖励
-(void)getRecommandRewardTotal{
    [MineNetManager getRecommandRewardTotalForCompleteHandle:^(id resPonseObj, int code) {
        
        NSLog(@"===%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                self.assetUSD1 = [NSString stringWithFormat:@"%.6f",[resPonseObj[@"data"][@"usdtTotal"] doubleValue]];
                self.assetCNY1  = [NSString stringWithFormat:@"≈%.2fCNY",[resPonseObj[@"data"][@"cnyTotal"] doubleValue]];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--请求总资产
-(void)getTotalData{
    dispatch_group_enter(group);
    [MineNetManager getMyTotalInfoForCompleteHandle:^(id resPonseObj, int code) {
        dispatch_group_leave(group);
        NSLog(@"===%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                self.assetUSD1 = [NSString stringWithFormat:@"%.6f",[resPonseObj[@"data"][@"usdtTotal"] doubleValue]];
                self.assetCNY1  = [NSString stringWithFormat:@"≈%.2fCNY",[resPonseObj[@"data"][@"cnyTotal"] doubleValue]];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--请求总资产的接口
-(void)getTotalAssets{
    dispatch_group_enter(group);
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
        dispatch_group_leave(group);
        NSLog(@"===%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.assetTotalArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                CGFloat ass1 = 0.0;
                CGFloat ass2 = 0.0;
                for (WalletManageModel *walletModel in dataArr) {
                    //计算总资产
                    ass1 = ass1 +[walletModel.balance floatValue]*[walletModel.coin.usdRate floatValue];
                    ass2 = ass2 +[walletModel.balance floatValue]*[walletModel.coin.cnyRate floatValue];
                    
                    [self.assetTotalArr addObject:walletModel];
                }
                
                self.assetUSD = [NSString stringWithFormat:@"%f",ass1];
                self.assetCNY  = [NSString stringWithFormat:@"≈%.2fCNY",ass2];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
//    dispatch_group_enter(group);
//    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
//        [EasyShowLodingView hidenLoding];
//        dispatch_group_leave(group);
        NSLog(@"===%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                //保存国家
//                [YLUserInfo shareUserInfo].country = resPonseObj[@"data"][@"country"][@"zhName"];
//                [YLUserInfo saveUser:[YLUserInfo shareUserInfo]];
                
                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                
                if (![self.accountInfo.avatar isEqualToString:[YLUserInfo shareUserInfo].avatar]) {
                  //保存头像
                    [YLUserInfo shareUserInfo].avatar = self.accountInfo.avatar;
                    [YLUserInfo saveUser:[YLUserInfo shareUserInfo]];
                }
                
                [YLUserInfo shareUserInfo].jyPwd = self.accountInfo.jyPwd;
                [YLUserInfo saveUser:[YLUserInfo shareUserInfo]];
                
                [self getAccountSettingStatus];
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [YLUserInfo logout];
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//验证用户是否为验证商家
-(void)businessstatus{

    dispatch_group_enter(group);
    [MineNetManager userbusinessstatus:^(id resPonseObj, int code) {
        dispatch_group_leave(group);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                self.memberLevel = [[[resPonseObj objectForKey:@"data"] objectForKey:@"certifiedBusinessStatus"] integerValue];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:LocalizationKey(@"noNetworkStatus") duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

//MARK:--整理账号设置的信息状态
-(void)getAccountSettingStatus{
    if (self.accountInfo.avatar == nil || [self.accountInfo.avatar isEqualToString:@""]) {
    }else{
        NSURL *headUrl = [NSURL URLWithString:self.accountInfo.avatar];
//        [self.headerView.headImage sd_setImageWithURL:headUrl];
        [self.headerView.headImage sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    }
    if (self.accountInfo.nickName) {
        self.headerView.userName.text = self.accountInfo.nickName;
    }else{
        self.headerView.userName.text = LocalizationKey(@"Youhavenotsetanicknameyet");
    }
    
    if ([self.accountInfo.noteLevel isEqualToString:@"0"]) {
        self.headerView.account.text = LocalizationKey(@"generaluser");
    }else if ([self.accountInfo.noteLevel isEqualToString:@"1"]){
        self.headerView.account.text = LocalizationKey(@"Advancednode");
    }else{
        self.headerView.account.text = LocalizationKey(@"Supernode");
    }
    
    
    
    if ([_accountInfo.fundsVerified isEqualToString:@"1"]) {
        _fundsVerified = YES;
    }else{
        _fundsVerified = NO;
    }
    
    if ([_accountInfo.realVerified isEqualToString:@"1"]) {
        //审核成功
        _realVerified = YES;
    }else{
        _realVerified = NO;
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.lastIndex = self.banarIndex;

    _isPush = YES;
    
//    MyassetsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
//    cell.pageFlowView.dataSource= nil;
//    cell.pageFlowView.delegate= nil;
//    [cell.pageFlowView stopTimer];
    
    NSLog(@"===%@",self.parentViewController.childViewControllers);
    
    if (self.parentViewController.childViewControllers.count == 1) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = NO;
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
