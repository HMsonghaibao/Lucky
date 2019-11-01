//
//  LotteryListViewController.m
//  digitalCurrency
//
//  Created by mac on 2019/6/15.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "LotteryListViewController.h"
#import "LotteryListCell.h"
#import "MineNetManager.h"
#import "WinningRecordModel.h"
@interface LotteryListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *listL;
@property (weak, nonatomic) IBOutlet UILabel *banlceL;
@property (weak, nonatomic) IBOutlet UILabel *sysmolL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *getL;
@property (weak, nonatomic) IBOutlet UILabel *getNorecordL;
@property (weak, nonatomic) IBOutlet UILabel *thankL;
@property (weak, nonatomic) IBOutlet UILabel *carryL;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,assign)NSInteger pageNo;
@end

@implementation LotteryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"Lotterydetails");
    self.listL.text = LocalizationKey(@"Lotteryleaderboard");
    self.getL.text = LocalizationKey(@"Congratulationsonwinning");
    self.banlceL.text = LocalizationKey(@"Willdepositthebalance");
    self.getNorecordL.text = LocalizationKey(@"Notawarded");
    self.thankL.text = LocalizationKey(@"Thankyouforparticipation");
    self.carryL.text = LocalizationKey(@"Continuetocheer");
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LotteryListCell" bundle:nil] forCellReuseIdentifier:@"LotteryListCell"];
    
    self.numL.hidden = YES;
    self.banlceL.hidden = YES;
    self.sysmolL.hidden = YES;
    self.getL.hidden = YES;
    self.getNorecordL.hidden = YES;
    self.thankL.hidden = YES;
    self.carryL.hidden = YES;
    
    
    self.pageNo = 1;
    
    [self getData];
    [self getRecordData];
    
    
    [self languageSetting];
    
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK:--上拉加载
- (void)refreshFooterAction{
    self.pageNo++;
    [self getData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1 ;
    [self getData];
}


//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
}


//MARK:--获取数据
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:self.time forKey:@"time"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryLotteryRankListByTimeParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_contentArr removeAllObjects];
                }
                
                NSArray *dataArr = [WinningRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.contentArr addObjectsFromArray:dataArr];
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


//MARK:--获取数据
-(void)getRecordData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:self.time forKey:@"time"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getMemberTimeRewardMoneyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.numL.text = [NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"totalMoney"] floatValue]];
                self.sysmolL.text = resPonseObj[@"data"][@"coinId"];
                if ([resPonseObj[@"data"][@"totalMoney"] isEqualToString:@"0.00000000"]) {
                    self.numL.hidden = YES;
                    self.banlceL.hidden = YES;
                    self.sysmolL.hidden = YES;
                    self.getL.hidden = YES;
                    self.getNorecordL.hidden = NO;
                    self.thankL.hidden = NO;
                    self.carryL.hidden = NO;
                }else{
                    self.numL.hidden = NO;
                    self.banlceL.hidden = NO;
                    self.sysmolL.hidden = NO;
                    self.getL.hidden = NO;
                    self.getNorecordL.hidden = YES;
                    self.thankL.hidden = YES;
                    self.carryL.hidden = YES;
                }
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


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LotteryListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"LotteryListCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        [cell.leverL setImage:[UIImage imageNamed:@"Lotteryranking-1"] forState:0];
        cell.centerConstraint.constant = -3;
        cell.numberL.textColor = [UIColor colorWithRed:223/255.0 green:64/255.0 blue:40/255.0 alpha:1.0];
    }else if (indexPath.row==1){
        [cell.leverL setImage:[UIImage imageNamed:@"Lotteryranking-2"] forState:0];
        cell.centerConstraint.constant = -3;
        cell.numberL.textColor = [UIColor colorWithRed:138/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
    }else if (indexPath.row==2){
        [cell.leverL setImage:[UIImage imageNamed:@"Lotteryranking-3"] forState:0];
        cell.centerConstraint.constant = -3;
        cell.numberL.textColor = [UIColor colorWithRed:157/255.0 green:117/255.0 blue:57/255.0 alpha:1.0];
    }else{
        [cell.leverL setImage:[UIImage imageNamed:@"route-3"] forState:0];
        cell.centerConstraint.constant = 0;
        cell.numberL.textColor = [UIColor colorWithRed:157/255.0 green:117/255.0 blue:57/255.0 alpha:1.0];
    }
    cell.numberL.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    WinningRecordModel *model;
    model = self.contentArr[indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    cell.nameL.text = model.userName;
    cell.numL.text = [NSString stringWithFormat:@"+%.2f %@",[model.money floatValue],model.coinId];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 47;
    
}


- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
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
