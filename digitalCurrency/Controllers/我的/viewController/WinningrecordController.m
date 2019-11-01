//
//  WinningrecordController.m
//  digitalCurrency
//
//  Created by mac on 2019/6/14.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "WinningrecordController.h"
#import "WinningRecordCell.h"
#import "ParterRecordCell.h"
#import "MineNetManager.h"
#import "WinningRecordModel.h"
@interface WinningrecordController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *recordL;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *contextL;
@property (nonatomic, assign)ChildViewType childViewType;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *contentArr1;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger pageNo1;
@end

@implementation WinningrecordController


- (instancetype)initWithChildViewType:(ChildViewType)childViewType
{
    self = [super init];
    if (self) {
        self.childViewType = childViewType;
    }
    return self;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.translucent = YES;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WinningRecordCell" bundle:nil] forCellReuseIdentifier:@"WinningRecordCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ParterRecordCell" bundle:nil] forCellReuseIdentifier:@"ParterRecordCell"];
    self.recordL.text = LocalizationKey(@"Winningrrecord");
    self.title = @"账单明细";
    
    self.pageNo = 1;
    self.pageNo1 = 1;
    
//    if (self.childViewType==ChildViewType_Record) {
//        self.title = LocalizationKey(@"Winningrrecord");
//        [self getData];
//        [self getTotalData];
//    }else{
//        self.title = LocalizationKey(@"Partnerrreward");
//        [self getData1];
//        [self getTotalData1];
//    }
    
    [self languageSetting];
    
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
    
}


//MARK:--上拉加载
- (void)refreshFooterAction{
    if (self.childViewType==ChildViewType_Record) {
        self.pageNo++;
        [self getData];
    }else{
        self.pageNo1++;
        [self getData1];
    }
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    if (self.childViewType==ChildViewType_Record) {
        self.pageNo = 1 ;
        [self getData];
    }else{
        self.pageNo1 = 1 ;
        [self getData1];
    }
}


//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
}


//MARK:--获取数据
-(void)getTotalData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"0" forKey:@"rewardType"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getMemberTotalRewardMoneyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.titleL.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Cumulativeamount"),resPonseObj[@"data"][@"coinId"]];
                self.contextL.text = [NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"totalMoney"] floatValue]];
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
-(void)getTotalData1{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"1" forKey:@"rewardType"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getMemberTotalRewardMoneyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.titleL.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Cumulativeamount"),resPonseObj[@"data"][@"coinId"]];
                self.contextL.text = [NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"totalMoney"] floatValue]];
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
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"0" forKey:@"rewardType"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryMemberLotteryRecordListParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
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
-(void)getData1{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo1];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"1" forKey:@"rewardType"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryMemberLotteryRecordListParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo1 == 1) {
                    [_contentArr1 removeAllObjects];
                }
                
                NSArray *dataArr = [WinningRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.contentArr1 addObjectsFromArray:dataArr];
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


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (self.childViewType==ChildViewType_Record) {
//        return self.contentArr.count;
//    }else{
//        return self.contentArr1.count;
//    }
    
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WinningRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WinningRecordCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    WinningRecordModel *model;
//    model = self.contentArr[indexPath.row];
//    cell.timeL.text = [NSString stringWithFormat:@"%@%@(%@)",model.time,LocalizationKey(@"Session"),model.lotteryDate];
//    cell.timeRecordL.text = [NSString stringWithFormat:@"%@: %@ %@",LocalizationKey(@"Lotterytime"),model.lotteryDate,model.time];
//    cell.moneyL.text = [NSString stringWithFormat:@"+%.2f %@",[model.money floatValue],model.coinId];
    return cell;
    
//    if (self.childViewType==ChildViewType_Record) {
//        WinningRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WinningRecordCell" forIndexPath:indexPath];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        WinningRecordModel *model;
//        model = self.contentArr[indexPath.row];
//        cell.timeL.text = [NSString stringWithFormat:@"%@%@(%@)",model.time,LocalizationKey(@"Session"),model.lotteryDate];
//        cell.timeRecordL.text = [NSString stringWithFormat:@"%@: %@ %@",LocalizationKey(@"Lotterytime"),model.lotteryDate,model.time];
//        cell.moneyL.text = [NSString stringWithFormat:@"+%.2f %@",[model.money floatValue],model.coinId];
//        return cell;
//    }else{
//        ParterRecordCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ParterRecordCell" forIndexPath:indexPath];
//        cell.selectionStyle=UITableViewCellSelectionStyleNone;
//        WinningRecordModel *model;
//        model = self.contentArr1[indexPath.row];
//        cell.timeL.text = [NSString stringWithFormat:@"%@%@",model.time,LocalizationKey(@"Session")];
//        cell.timeLL.text = model.lotteryDate;
//        cell.numL.text = model.fromCount;
//        cell.numberL.text = [NSString stringWithFormat:@"+%.2f",[model.fromMoney floatValue]];
//        cell.incomeNumL.text = [NSString stringWithFormat:@"+%.2f",[model.money floatValue]];
//        cell.timeLabel.text = LocalizationKey(@"Lotterytime");
//        cell.recordCountL.text = LocalizationKey(@"Numberofwinners");
//        cell.recordTotalL.text = LocalizationKey(@"Totalprize");
//        cell.incomeL.text = LocalizationKey(@"income");
////        cell.traL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Settlementtime" value:nil table:@"English"];
////        cell.numL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Quantityrelationship" value:nil table:@"English"];
////        cell.comeL.text = [[ChangeLanguage bundle] localizedStringForKey:@"income" value:nil table:@"English"];
//        return cell;
//    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (self.childViewType==ChildViewType_Record) {
//        return 70;
//    }else{
//        return 90;
//    }
    
    return 65;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}

- (NSMutableArray *)contentArr1
{
    if (!_contentArr1) {
        _contentArr1 = [NSMutableArray array];
    }
    return _contentArr1;
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
