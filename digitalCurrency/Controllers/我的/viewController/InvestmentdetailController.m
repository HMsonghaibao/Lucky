//
//  InvestmentdetailController.m
//  digitalCurrency
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvestmentdetailController.h"
#import "InvestmentDetailCell.h"
#import "MineNetManager.h"
#import "InvestmentSubViewController.h"
#import "investmentDetailModel.h"
@interface InvestmentdetailController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *unlockL;
@property (weak, nonatomic) IBOutlet UILabel *unlockNumL;
@property (weak, nonatomic) IBOutlet UILabel *lockL;
@property (weak, nonatomic) IBOutlet UILabel *lockNumL;
@property (weak, nonatomic) IBOutlet UILabel *inviteL;
@property (weak, nonatomic) IBOutlet UILabel *doneL;
@property (weak, nonatomic) IBOutlet UILabel *doneNumL;
@property (weak, nonatomic) IBOutlet UILabel *personL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *totalNumL;
@property (weak, nonatomic) IBOutlet UILabel *total;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (nonatomic,strong)NSMutableArray *directArr;
@property(nonatomic,assign)NSInteger pageNo;
@end

@implementation InvestmentdetailController

- (NSMutableArray *)directArr {
    if (!_directArr) {
        _directArr = [NSMutableArray array];
    }
    return _directArr;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
    [self getTotalData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = LocalizationKey(@"Investmentdetails");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestmentDetailCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([InvestmentDetailCell class])];
    self.money.text = LocalizationKey(@"investmentamount");
    self.unlockL.text = LocalizationKey(@"Released");
    self.lockL.text = LocalizationKey(@"Notreleased");
    self.inviteL.text = LocalizationKey(@"invitefriends");
    self.doneL.text = [NSString stringWithFormat:@"%@:",LocalizationKey(@"Invited")];
    self.personL.text = [NSString stringWithFormat:@"(%@)",LocalizationKey(@"NumberCount")];
    self.totalL.text = [NSString stringWithFormat:@"%@:",LocalizationKey(@"Totalinvestment")];
    [self.doneBtn setTitle:LocalizationKey(@"Iwanttoupgrade") forState:0];
    
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
}


- (IBAction)doneBtnClick:(UIButton *)sender {
    //申请投资
    InvestmentSubViewController *detailVC = [[InvestmentSubViewController alloc] init];
    detailVC.title = LocalizationKey(@"Upgradeinvestment");
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK:--获取数据
-(void)getTotalData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getInvestTotalParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.moneyL.text = [NSString stringWithFormat:@"%@(%@)",resPonseObj[@"data"][@"investTotal"],resPonseObj[@"data"][@"investUnit"]];
                self.unlockNumL.text = [NSString stringWithFormat:@"%.2f%@",[resPonseObj[@"data"][@"freeMoney"] doubleValue],resPonseObj[@"data"][@"lockUnit"]];
                self.lockNumL.text = [NSString stringWithFormat:@"%.2f%@",[resPonseObj[@"data"][@"lockMoney"] doubleValue],resPonseObj[@"data"][@"lockUnit"]];
                self.doneNumL.text = [NSString stringWithFormat:@"%@",resPonseObj[@"data"][@"inviteCount"]];
                self.totalNumL.text = [NSString stringWithFormat:@"%@",resPonseObj[@"data"][@"inviteMoney"]];
                self.total.text = [NSString stringWithFormat:@"(%@)",resPonseObj[@"data"][@"investUnit"]];
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
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getInviteMemberListParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSArray *dataArr = [investmentDetailModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.directArr addObjectsFromArray:dataArr];
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


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.directArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    InvestmentDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InvestmentDetailCell" forIndexPath:indexPath];
    investmentDetailModel*model=self.directArr[indexPath.row];
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    cell.titleL.text = model.userName;
    cell.timeL.text = model.createTime;
    cell.moneyL.text = [NSString stringWithFormat:@"%@%@",model.investMoney,model.unit];
    cell.invL.text = LocalizationKey(@"investmentamount");
    cell.selectionStyle = 0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
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
