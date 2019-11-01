//
//  RewardListViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "RewardListViewController.h"
#import "RewardListTableViewCell.h"
#import "RewardRecordTableViewCell.h"
#import "MineNetManager.h"
#import "RepeatListModel.h"
#import "InvestRewardModel.h"
#import "RewardRecordTeamCell.h"
static NSString * const RewardListCellIdentifier = @"RewardListCellIdentifier";
static NSString * const RewardRecordCellIdentifier = @"RewardRecordCellIdentifier";
static NSString * const RewardRecordTeamCellIdentifier = @"RewardRecordTeamCellIdentifier";
@interface RewardListViewController ()<UITableViewDelegate, UITableViewDataSource>{
    NSInteger _pageNo;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *lists;
@property (nonatomic, strong) NSMutableArray *records;

@end

@implementation RewardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _pageNo = 1;
    // Do any additional setup after loading the view from its nib.
    [self UILayout];
    [self requestData];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.view.width = SCREEN_WIDTH_S;
//    NSLog(@"hhhhhhh%f, hhhh%f",SCREEN_WIDTH_S,self.view.size.width);
}

- (void)requestData{
    if (self.listType == 1) {
        [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
        [MineNetManager getRedeliveryList:nil CompleteHandle:^(id resPonseObj, int code) {
            [EasyShowLodingView hidenLoding];
            
            NSLog(@"=====%@",resPonseObj);
            
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    if (_pageNo == 1) {
                        [self.lists removeAllObjects];
                    }
                    NSArray *dataArr = [RepeatListModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                    [self.lists addObjectsFromArray:dataArr];
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

    }else if (self.listType == 2){
        [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
        NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
        
        NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
        [bodydic setValue:pageNoStr forKey:@"pageNo"];
        [bodydic setValue:@"10" forKey:@"pageSize"];
        NSLog(@"=====%@",bodydic);
        
        [MineNetManager getInvestRewardList:bodydic CompleteHandle:^(id resPonseObj, int code) {
            [EasyShowLodingView hidenLoding];
            
            NSLog(@"=====%@",resPonseObj);
            
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    if (_pageNo == 1) {
                        [self.records removeAllObjects];
                    }
                    NSArray *dataArr = [InvestRewardModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
        
                    [self.records addObjectsFromArray:dataArr];
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

    }else{
        
        [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
        NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
        
        NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
        [bodydic setValue:pageNoStr forKey:@"pageNo"];
        [bodydic setValue:@"10" forKey:@"pageSize"];
        NSLog(@"=====%@",bodydic);
        
        [MineNetManager getInvestRewardTeamList:bodydic CompleteHandle:^(id resPonseObj, int code) {
            [EasyShowLodingView hidenLoding];
            
            NSLog(@"=====%@",resPonseObj);
            
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    if (_pageNo == 1) {
                        [self.records removeAllObjects];
                    }
                    NSArray *dataArr = [InvestRewardModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                    
                    [self.records addObjectsFromArray:dataArr];
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
}

- (void)UILayout{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RewardListTableViewCell" bundle:nil] forCellReuseIdentifier:RewardListCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"RewardRecordTableViewCell" bundle:nil] forCellReuseIdentifier:RewardRecordCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"RewardRecordTeamCell" bundle:nil] forCellReuseIdentifier:RewardRecordTeamCellIdentifier];
    
    [self languageSetting];
    
    if (self.listType != 1) {
        [self headRefreshWithScrollerView:self.tableView];
        [self footRefreshWithScrollerView:self.tableView];
    }
   
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
    
}

//MARK:--上拉加载
- (void)refreshFooterAction{
    _pageNo++;
    [self requestData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    _pageNo = 1;
    [self requestData];
}


//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.listType == 1) {
        return self.lists.count;
    }else{
        return self.records.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == 1) {
        RewardListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RewardListCellIdentifier forIndexPath:indexPath];
        tableView.rowHeight = 64;
        [cell refreshUI:self.lists[indexPath.row]];
        return cell;
    }else if (self.listType == 2){
        RewardRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RewardRecordCellIdentifier forIndexPath:indexPath];
        tableView.rowHeight = 66;
        [cell refreshUI:self.records[indexPath.row]];
        return cell;
    }else{
        RewardRecordTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:RewardRecordTeamCellIdentifier forIndexPath:indexPath];
        cell.numL.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
        tableView.rowHeight = 66;
        [cell refreshUI:self.records[indexPath.row]];
        return cell;
    }
        
}

- (NSMutableArray *)lists{
    if (!_lists) {
        _lists = [NSMutableArray array];
    }
    return _lists;
}

- (NSMutableArray *)records{
    if (!_records) {
        _records = [NSMutableArray array];
    }
    return _records;
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
