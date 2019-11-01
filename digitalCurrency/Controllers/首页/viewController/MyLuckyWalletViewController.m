//
//  MyRedPacketViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "MyLuckyWalletViewController.h"
#import "MineNetManager.h"
#import "RedPacketModel.h"
#import "RedPacketTableViewCell.h"
#import "RedPacketTotalModel.h"
#import "LuckyWalletTableViewCell.h"
#import "LuckyTibiViewController.h"
#import "ChargeMoneyViewController.h"
#import "MyLuckyExchangeViewController.h"
#import "walletModel.h"
#import "LuckyTranViewController.h"
@interface MyLuckyWalletViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger _page;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *myredLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailingLabel;
@property (weak, nonatomic) IBOutlet UILabel *yilingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *balaceL;
@property (weak, nonatomic) IBOutlet UIButton *tibiBtn;
@property (weak, nonatomic) IBOutlet UIButton *duihuanBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *tranBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, copy) NSString *total;
@end

@implementation MyLuckyWalletViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    _page = 1;
    
    
//    [self requestRedPacketToTal];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self UILayout];
    [self requestData];
}


- (IBAction)tibiBtnClick:(UIButton *)sender {
    if ([YLUserInfo shareUserInfo].jyPwd == nil || [[YLUserInfo shareUserInfo].jyPwd isEqualToString:@""]) {
        
        [self.view makeToast:LocalizationKey(@"Youhavenotpaidyourpasswordyet") duration:1.5 position:CSToastPositionCenter];
        
    }else{
        LuckyTibiViewController *groupVC = [[LuckyTibiViewController alloc] init];
        groupVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupVC animated:YES];
    }
}
- (IBAction)exchangeBtnClick:(UIButton *)sender {
    MyLuckyExchangeViewController *groupVC = [[MyLuckyExchangeViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    groupVC.total = self.total;
    [self.navigationController pushViewController:groupVC animated:YES];
}
- (IBAction)chongzhiBtnClick:(UIButton *)sender {
    ChargeMoneyViewController *groupVC = [[ChargeMoneyViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    groupVC.unit = @"USDT";
    groupVC.address = self.address;
    [self.navigationController pushViewController:groupVC animated:YES];
}
- (IBAction)tranBtnClick:(UIButton *)sender {
    if ([YLUserInfo shareUserInfo].jyPwd == nil || [[YLUserInfo shareUserInfo].jyPwd isEqualToString:@""]) {
        
        [self.view makeToast:LocalizationKey(@"Youhavenotpaidyourpasswordyet") duration:1.5 position:CSToastPositionCenter];
        
    }else{
        LuckyTranViewController *groupVC = [[LuckyTranViewController alloc] init];
        groupVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupVC animated:YES];
    }
}

//- (void)requestRedPacketToTal{
//
//    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
//    [MineNetManager getRedPacketTotalParams:nil CompleteHandle:^(id resPonseObj, int code) {
//        [EasyShowLodingView hidenLoding];
//        NSLog(@"=====%@",resPonseObj);
//        if (code) {
//            if ([resPonseObj[@"code"] integerValue]==0) {
//                //获取数据成功
//                RedPacketTotalModel *model = [RedPacketTotalModel mj_objectWithKeyValues:resPonseObj[@"data"]];
//                self.myredLabel.text = [NSString stringWithFormat:@"%@(%@%@)",LocalizationKey(@"MyRedPackets"),model.usdtTotal,model.coinId];
//                self.amountLabel.text = [NSString stringWithFormat:@"￥%@",model.cnyTotal];
//                self.dailingLabel.text = [NSString stringWithFormat:@"%@",model.unGetTotalMoney];
//                self.yilingLabel.text = [NSString stringWithFormat:@"%@",model.getTotalMoney];
//
//            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
//                [YLUserInfo logout];
//            }else{
//                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
//            }
//        }else{
//            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
//        }
//    }];
//
//}
//
- (void)requestData{
//    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [MineNetManager queryLotteryRankListByTimeParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.amountLabel.text = [NSString stringWithFormat:@"¥ %.2f",[resPonseObj[@"data"][@"totalCny"] floatValue]];
                [self.dataArray removeAllObjects];
                NSArray *array = [walletModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"list"]];
                [self.dataArray addObjectsFromArray:array];
                [self.tableView reloadData];

                for (walletModel*model in self.dataArray) {
                    if ([model.unit isEqualToString:@"USDT"]) {
                        self.address = model.address;
                        self.total = model.balance;
                    }
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


//MARK:--下拉刷新
- (void)refreshHeaderAction{
    [self requestData];
}


- (void)UILayout{
    
    self.title = LocalizationKey(@"luckywallet");
    [self.tibiBtn setTitle:LocalizationKey(@"Withdrawmoney") forState:0];
    [self.duihuanBtn setTitle:LocalizationKey(@"exchangettt") forState:0];
    [self.chongzhiBtn setTitle:LocalizationKey(@"Rechargettt") forState:0];
    [self.tranBtn setTitle:LocalizationKey(@"transfer") forState:0];
    self.nameL.text = LocalizationKey(@"namettt");
    self.priceL.text = LocalizationKey(@"Real-timeprice");
    self.balaceL.text = LocalizationKey(@"Balancettt");
    self.myredLabel.text = LocalizationKey(@"Totalassetsttt");
    self.headerViewHeight.constant = (SCREEN_WIDTH_S*105)/349+15;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"LuckyWalletTableViewCell" bundle:nil] forCellReuseIdentifier:@"LuckyWalletTableViewCell"];
   
    [self headRefreshWithScrollerView:self.tableView];
//    [self footRefreshWithScrollerView:self.tableView];
    
//    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
//    self.tableView.ly_emptyView = emptyView;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    LuckyWalletTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LuckyWalletTableViewCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell refreshUI:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
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
