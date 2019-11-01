//
//  MyRedPacketViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "MyLuckyLockViewController.h"
#import "MineNetManager.h"
#import "RedPacketModel.h"
#import "RedPacketTableViewCell.h"
#import "RedPacketTotalModel.h"
#import "luckylockModel.h"
@interface MyLuckyLockViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *myredLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailingLabel;
@property (weak, nonatomic) IBOutlet UILabel *yilingLabel;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *num1L;
@property (weak, nonatomic) IBOutlet UILabel *num2L;
@property(nonatomic,assign)NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MyLuckyLockViewController

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pageNo = 1;
    [self UILayout];
    
    self.backView.layer.cornerRadius=5;
    self.backView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.backView.layer.shadowOffset=CGSizeMake(0, 0);
    self.backView.layer.shadowOpacity=0.1;
    self.backView.layer.shadowRadius=2;
    [self requestData];
    [self requestRedPacketToTal];
}

- (void)requestRedPacketToTal{
    
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [MineNetManager getPartnerInfo:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.num1L.text = [NSString stringWithFormat:@"%@",resPonseObj[@"data"][@"totalLockMoney"]];
                self.myredLabel.text = [NSString stringWithFormat:@"%@",resPonseObj[@"data"][@"unlockMoney"]];
                self.num2L.text = [NSString stringWithFormat:@"%@",resPonseObj[@"data"][@"surplusMoney"]];
                
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

- (void)requestData{
    //    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"page"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [MineNetManager invitationApplyPartner:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [self.dataArray removeAllObjects];
                }
                NSArray *array = [luckylockModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"rows"]];
                [self.dataArray addObjectsFromArray:array];
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

- (void)UILayout{
    
    self.title = LocalizationKey(@"Releaseassets");
//    self.headerViewHeight.constant = (SCREEN_WIDTH_S-32)*179/343+50;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RedPacketTableViewCell" bundle:nil] forCellReuseIdentifier:@"MyRedPacketCellIdentifier"];
   
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;

}


//MARK:--上拉加载
- (void)refreshFooterAction{
    self.pageNo++;
    [self requestData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1 ;
    [self requestData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    RedPacketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyRedPacketCellIdentifier" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    luckylockModel*model = self.dataArray[indexPath.row];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",model.amount];
    cell.amountLabel.text = model.createTime;
    cell.timeL.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
//    [cell refreshUI:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
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
