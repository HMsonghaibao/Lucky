//
//  EcologyController.m
//  digitalCurrency
//
//  Created by Apple on 2019/9/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "EcologyController.h"
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
@interface EcologyController ()

@end

@implementation EcologyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"生态";
    [self rightButton];
    [self.tableView registerNib:[UINib nibWithNibName:@"EcologyTableViewCell" bundle:nil] forCellReuseIdentifier:@"EcologyTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountTableViewCell" bundle:nil] forCellReuseIdentifier:@"CountTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyteamTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyteamTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BiaogeTableViewCell" bundle:nil] forCellReuseIdentifier:@"BiaogeTableViewCell"];
    // Do any additional setup after loading the view from its nib.
}


//MARK:--自定义导航栏消息按钮
-(void)rightButton{
    UIButton * issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    //    [issueButton setBackgroundImage:[UIImage imageNamed:@"xiaoxi"] forState:UIControlStateNormal];
    [issueButton setTitle:@"账单" forState:0];
    [issueButton addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}

-(void)RighttouchEvent{
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
        return;
    }
    
    TeamManagerViewController *groupVC = [[TeamManagerViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        BiaogeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BiaogeTableViewCell"];
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
        return cell;
    }else{
        MyteamTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyteamTableViewCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==2) {
        MiningmachineController*klineVC=[[MiningmachineController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:klineVC];
        
    }
}
#pragma mark-获取首页推荐信息

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
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
