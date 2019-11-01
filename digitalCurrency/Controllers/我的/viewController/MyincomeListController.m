//
//  MyincomeListController.m
//  digitalCurrency
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "MyincomeListController.h"
#import "MyincomeListTableCell.h"
#import "MineNetManager.h"
#import "myincomeListModel.h"
#import "InvitefriendsViewController.h"
#import "SweepstakesViewController.h"
#import "YLTabBarController.h"
#import "AccountSettingViewController.h"
#import "WalletManageDetailViewController.h"
@interface MyincomeListController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *yestL;
@property (weak, nonatomic) IBOutlet UILabel *yest;
@property (weak, nonatomic) IBOutlet UILabel *shengyuL;
@property (weak, nonatomic) IBOutlet UILabel *shengyu;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *taskArr;
@property (nonatomic,strong)NSMutableArray *doneArr;
@end

@implementation MyincomeListController

- (NSMutableArray *)taskArr {
    if (!_taskArr) {
        _taskArr = [NSMutableArray array];
    }
    return _taskArr;
}

- (NSMutableArray *)doneArr {
    if (!_doneArr) {
        _doneArr = [NSMutableArray array];
    }
    return _doneArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = LocalizationKey(@"MyIncome");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyincomeListTableCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyincomeListTableCell class])];
    
    self.titleL.text = [NSString stringWithFormat:@"%@(%.2fUSDT)",LocalizationKey(@"MyIncome"),[self.bannerdic[@"myReward"][@"usdtTotal"] doubleValue]];
    self.moneyL.text = [NSString stringWithFormat:@"¥%.2f",[self.bannerdic[@"myReward"][@"cnyTotal"] doubleValue]];
    self.yestL.text = LocalizationKey(@"Yesterdayearnings");
    self.yest.text = [NSString stringWithFormat:@"%.2fUSDT",[self.bannerdic[@"myReward"][@"yesterdayUsdtTotal"] doubleValue]];
    self.shengyuL.text = LocalizationKey(@"Remainingbonus");
    self.shengyu.text = [NSString stringWithFormat:@"%@NBTC",self.bannerdic[@"myReward"][@"maxLottery"]];
    [self getTaskList];
    
    [self rightBarItemWithTitle:LocalizationKey(@"Assetflow")];
}

//MARK:--资金流水
-(void)RighttouchEvent{
    //资产流水
    WalletManageDetailViewController *detailVC = [[WalletManageDetailViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}


//MARK:--任务列表
-(void)getTaskList{
    [MineNetManager getTaskListForCompleteHandle:^(id resPonseObj, int code) {
        
        NSLog(@"===%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                NSArray *taskArr = [myincomeListModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"taskList"]];
                [self.taskArr addObjectsFromArray:taskArr];
                NSArray *doneArr = [myincomeListModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"finishList"]];
                [self.doneArr addObjectsFromArray:doneArr];
                [self.tableView reloadData];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.taskArr.count;
    }else{
        return self.doneArr.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MyincomeListTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyincomeListTableCell" forIndexPath:indexPath];
    cell.selectionStyle = 0;
    if (indexPath.section == 0) {
        myincomeListModel *model = self.taskArr[indexPath.row];
        if ([model.taskNo isEqualToString:@"1002"]) {
            NSData *jsonData = [model.taskProperty dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            NSInteger inviterCount = [dict[@"inviterCount"] integerValue];
            NSInteger needCount = [dict[@"needCount"] integerValue];
            for (NSInteger i = 0; i < needCount; i++) {
                if (inviterCount == i) {
                    cell.heightConstraint.constant = (65/needCount)*i;
                }
            }
            cell.lineView.hidden = NO;
//            cell.titleL.text = [NSString stringWithFormat:@"%@ (%@/%@)",model.taskName,dict[@"inviterCount"],dict[@"needCount"]];
            NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ (%@/%@)",model.taskName,dict[@"inviterCount"],dict[@"needCount"]]];
            NSInteger numint = 0;
            if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
                numint = 23;
            }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
            {
                numint = 6;
            }
            NSRange rangel = [[textColor string] rangeOfString:[[NSString stringWithFormat:@"%@ (%@/%@)",model.taskName,dict[@"inviterCount"],dict[@"needCount"]] substringFromIndex:numint]];
            [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:126/255.0 green:83/255.0 blue:254/255.0 alpha:1.0] range:NSMakeRange(rangel.location, 1)];
            [cell.titleL setAttributedText:textColor];
        }else{
            cell.lineView.hidden = YES;
            cell.titleL.text = model.taskName;
        }
        if ([model.taskNo isEqualToString:@"1001"]) {
            cell.headImage.image = [UIImage imageNamed:@"myincome1"];
        }else if ([model.taskNo isEqualToString:@"1002"]){
            cell.headImage.image = [UIImage imageNamed:@"myincome2"];
        }else if ([model.taskNo isEqualToString:@"1003"]){
            cell.headImage.image = [UIImage imageNamed:@"myincome3"];
        }else{
            cell.headImage.image = [UIImage imageNamed:@"myincome4"];
        }
        cell.descL.text = model.taskSub;
        [cell.leftbtn setTitle:[NSString stringWithFormat:@"   %@   ",model.buttonText] forState:0];
        cell.leftbtn.alpha = 1;
        cell.leftbtn.enabled = YES;
        cell.MyincomeListBlock = ^(NSInteger aa) {
            if ([model.taskNo isEqualToString:@"1001"]) {
                AccountSettingViewController *accountVC = [[AccountSettingViewController alloc] init];
                [[AppDelegate sharedAppDelegate] pushViewController:accountVC];
            }else if ([model.taskNo isEqualToString:@"1002"]){
                InvitefriendsViewController *detailVC = [[InvitefriendsViewController alloc] init];
                detailVC.hidesBottomBarWhenPushed = YES;
                [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
            }else if ([model.taskNo isEqualToString:@"1003"]){
                YLTabBarController*tabVC=(YLTabBarController*)APPLICATION.window.rootViewController;
                tabVC.selectedIndex=3;
            }else{
                //报名开奖
                SweepstakesViewController *sweepsVC = [[SweepstakesViewController alloc] init];
                sweepsVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sweepsVC animated:YES];
            }
        };
    }else{
        myincomeListModel *model = self.doneArr[indexPath.row];
        if ([model.taskNo isEqualToString:@"1001"]) {
            cell.headImage.image = [UIImage imageNamed:@"myincome1"];
        }else if ([model.taskNo isEqualToString:@"1002"]){
            cell.headImage.image = [UIImage imageNamed:@"myincome2"];
        }else if ([model.taskNo isEqualToString:@"1003"]){
            cell.headImage.image = [UIImage imageNamed:@"myincome3"];
        }else{
            cell.headImage.image = [UIImage imageNamed:@"myincome4"];
        }
        
        if ([model.taskNo isEqualToString:@"1002"]) {
            NSData *jsonData = [model.taskProperty dataUsingEncoding:NSUTF8StringEncoding];
            NSError *err;
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:NSJSONReadingMutableContainers
                                                                   error:&err];
            cell.lineView.hidden = NO;
//            cell.titleL.text = [NSString stringWithFormat:@"%@ (%@/%@)",model.taskName,dict[@"inviterCount"],dict[@"needCount"]];
            NSMutableAttributedString *textColor = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ (%@/%@)",model.taskName,dict[@"inviterCount"],dict[@"needCount"]]];
            NSInteger numint = 0;
            if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
                numint = 23;
            }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
            {
                numint = 6;
            }
            NSRange rangel = [[textColor string] rangeOfString:[[NSString stringWithFormat:@"%@ (%@/%@)",model.taskName,dict[@"inviterCount"],dict[@"needCount"]] substringFromIndex:numint]];
            [textColor addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:126/255.0 green:83/255.0 blue:254/255.0 alpha:1.0] range:NSMakeRange(rangel.location, 1)];
            [cell.titleL setAttributedText:textColor];
        }else{
            cell.lineView.hidden = YES;
            cell.titleL.text = model.taskName;
        }
        cell.descL.text = model.taskSub;
        [cell.leftbtn setTitle:[NSString stringWithFormat:@"   %@   ",LocalizationKey(@"completed")] forState:0];
        cell.leftbtn.alpha = 0.5;
        cell.leftbtn.enabled = NO;
        cell.lineView.hidden = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
    
}

#pragma mark - 自定义headerView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_S, 30)];
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_S, 30)];
    if (section == 0) {
        lab.text = LocalizationKey(@"Activitytask");
    }else{
        lab.text = LocalizationKey(@"Completed");
    }
    lab.textColor = [UIColor whiteColor];
    lab.textAlignment = NSTextAlignmentLeft;
    lab.font = [UIFont systemFontOfSize:15];
    [header addSubview:lab];
    header.backgroundColor = [UIColor colorWithRed:18/255.0 green:22/255.0 blue:28/255.0 alpha:1.0];
    
    return header;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}
#pragma mark - 自定义footerView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView*view=[UIView new];
    view.backgroundColor = [UIColor colorWithRed:18/255.0 green:22/255.0 blue:28/255.0 alpha:1.0];
    return view;
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
