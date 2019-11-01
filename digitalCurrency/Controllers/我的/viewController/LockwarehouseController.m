//
//  LockwarehouseController.m
//  digitalCurrency
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "LockwarehouseController.h"
#import "LockwareViewCell.h"
#import "LockRecordViewController.h"
#import "MineNetManager.h"
#import "lockRecordModel.h"
@interface LockwarehouseController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *didLockL;
@property (weak, nonatomic) IBOutlet UILabel *firstLockL;
@property (weak, nonatomic) IBOutlet UILabel *lockNumberL;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLockL;
@property (weak, nonatomic) IBOutlet UILabel *lockNumL;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLockNumL;
@property(nonatomic,strong)NSMutableArray *lockRecordArr;
@property (weak, nonatomic) IBOutlet UILabel *sysmolL;

@end

@implementation LockwarehouseController

- (NSMutableArray *)lockRecordArr {
    if (!_lockRecordArr) {
        _lockRecordArr = [NSMutableArray array];
    }
    return _lockRecordArr;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


//MARK:--自定义导航栏消息按钮
-(void)rightButton{
    UIButton * issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    [issueButton setImage:[UIImage imageNamed:@"Unlockrecord"] forState:UIControlStateNormal];
    [issueButton addTarget:self action:@selector(lockRecordBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}


//MARK:--自定义导航栏消息按钮
-(void)leftButton{
    UIButton * issueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    [issueButton setImage:[UIImage imageNamed:@"back3"] forState:UIControlStateNormal];
    [issueButton addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.leftBarButtonItem = leftBarButtomItem;
}


- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)lockRecordBtnClick:(UIButton *)sender {
    LockRecordViewController *detailVC = [[LockRecordViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.didLockL.text = [NSString stringWithFormat:@"(%@)",[[ChangeLanguage bundle] localizedStringForKey:@"Unlocked" value:nil table:@"English"]];
    self.lockNumberL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Numberoflocks" value:nil table:@"English"];
    self.shengyuLockL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Remaininglock" value:nil table:@"English"];
    self.firstLockL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Latestunlockrecord" value:nil table:@"English"];
    self.title = @"NBTC";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LockwareViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([LockwareViewCell class])];
    
    [self leftButton];
    [self rightButton];
    
    
    [self headRefreshWithScrollerView:self.tableView];
//    [self footRefreshWithScrollerView:self.tableView];
    [self getData];
    [self getLockData];
    
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
}



//MARK:--下拉刷新
- (void)refreshHeaderAction{
    [self getData];
}


//MARK:--获取数据
-(void)getLockData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager unlockInfoParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
//                [_lockRecordArr removeAllObjects];
//
//                NSArray *dataArr = [lockRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
//                [self.lockRecordArr addObjectsFromArray:dataArr];
//                [self.tableView reloadData];
                self.totalL.text = [NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"unlock_num"] floatValue]];
                self.shengyuLockNumL.text = [NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"surplus_num"] floatValue]];
                self.lockNumL.text = [NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"total"] floatValue]];
                self.sysmolL.text = resPonseObj[@"data"][@"coin_id"];
                self.title = resPonseObj[@"data"][@"coin_id"];
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
    
    [MineNetManager lockRecordParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [_lockRecordArr removeAllObjects];
                
                NSArray *dataArr = [lockRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.lockRecordArr addObjectsFromArray:dataArr];
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


-(NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.doubleValue)];
    return outNumber;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lockRecordArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LockwareViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LockwareViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.timeLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"Settlementtime" value:nil table:@"English"];
    cell.lockL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Numberofunlocks" value:nil table:@"English"];
    cell.speedL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Acceleratedunlock" value:nil table:@"English"];
    lockRecordModel *model = self.lockRecordArr[indexPath.row];
    cell.timeL.text = model.createTime;
    NSString*str=[self removeFloatAllZero:model.amount];
    cell.lockNumberL.text = [NSString stringWithFormat:@"%@ %@",str,model.coinId];
    if ([model.speedUp integerValue] > 0) {
        cell.speedL.hidden = NO;
        
    }else{
        cell.speedL.hidden = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62;
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
