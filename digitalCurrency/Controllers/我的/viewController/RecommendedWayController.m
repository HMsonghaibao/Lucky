//
//  RecommendedWayController.m
//  digitalCurrency
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "RecommendedWayController.h"
#import "RecommendedCell.h"
#import "TeamListTableViewCell.h"
#import "MineNetManager.h"
#import "recommendModel.h"
@interface RecommendedWayController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign)ChildViewType childViewType;
@property (nonatomic,strong)NSMutableArray *directArr;
@property(nonatomic,strong)NSMutableArray *indirectArr;
@property(nonatomic,strong)NSMutableArray *indirectArr1;
@property(nonatomic,strong)NSMutableArray *indirectArr2;
@property(nonatomic,strong)NSMutableArray *indirectArr3;
@property(nonatomic,strong)NSMutableArray *indirectArr4;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger pageNo1;
@property(nonatomic,assign)NSInteger pageNo2;
@property(nonatomic,assign)NSInteger pageNo3;
@property(nonatomic,assign)NSInteger pageNo4;
@property(nonatomic,assign)NSInteger pageNo5;
@end

@implementation RecommendedWayController


- (NSMutableArray *)directArr {
    if (!_directArr) {
        _directArr = [NSMutableArray array];
    }
    return _directArr;
}

- (NSMutableArray *)indirectArr {
    if (!_indirectArr) {
        _indirectArr = [NSMutableArray array];
    }
    return _indirectArr;
}

- (NSMutableArray *)indirectArr1 {
    if (!_indirectArr1) {
        _indirectArr1 = [NSMutableArray array];
    }
    return _indirectArr1;
}

- (NSMutableArray *)indirectArr2 {
    if (!_indirectArr2) {
        _indirectArr2 = [NSMutableArray array];
    }
    return _indirectArr2;
}

- (NSMutableArray *)indirectArr3 {
    if (!_indirectArr3) {
        _indirectArr3 = [NSMutableArray array];
    }
    return _indirectArr3;
}

- (NSMutableArray *)indirectArr4 {
    if (!_indirectArr4) {
        _indirectArr4 = [NSMutableArray array];
    }
    return _indirectArr4;
}

- (instancetype)initWithChildViewType:(ChildViewType)childViewType
{
    self = [super init];
    if (self) {
        self.childViewType = childViewType;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendedCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([RecommendedCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"TeamListTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([TeamListTableViewCell class])];
    
    self.pageNo = 1;
    self.pageNo1 = 1;
    self.pageNo2 = 1;
    self.pageNo3 = 1;
    self.pageNo4 = 0;
    self.pageNo5 = 0;
    
//    if (self.childViewType==ChildViewType_direct) {
//        [self getData];
//    }else if(self.childViewType==ChildViewType_indirect){
//        [self getData1];
//    }else if(self.childViewType==ChildViewType_indirect1){
//        [self getData2];
//    }else if(self.childViewType==ChildViewType_indirect2){
//        [self getData3];
//    }else if(self.childViewType==ChildViewType_indirect3){
//        [self getData4];
//    }else{
//        [self getData5];
//    }
    
    
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
}


//MARK:--上拉加载
- (void)refreshFooterAction{
    if (self.childViewType==ChildViewType_direct) {
        self.pageNo++;
        [self getData];
    }else if(self.childViewType==ChildViewType_indirect){
        self.pageNo1++;
        [self getData1];
    }else if(self.childViewType==ChildViewType_indirect1){
        self.pageNo2++;
        [self getData2];
    }else if(self.childViewType==ChildViewType_indirect2){
        self.pageNo3++;
        [self getData3];
    }else if(self.childViewType==ChildViewType_indirect3){
        self.pageNo4++;
        [self getData4];
    }else{
        self.pageNo5++;
        [self getData5];
    }
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    if (self.childViewType==ChildViewType_direct) {
        self.pageNo = 1 ;
        [self getData];
    }else if(self.childViewType==ChildViewType_indirect){
        self.pageNo1 = 1 ;
        [self getData1];
    }else if(self.childViewType==ChildViewType_indirect1){
        self.pageNo2 = 1 ;
        [self getData2];
    }else if(self.childViewType==ChildViewType_indirect2){
        self.pageNo3 = 1 ;
        [self getData3];
    }else if(self.childViewType==ChildViewType_indirect3){
        self.pageNo4 = 0 ;
        [self getData4];
    }else{
        self.pageNo5 = 0 ;
        [self getData5];
    }
}


//MARK:--获取数据
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"1" forKey:@"fromLevel"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager recommendedrewardParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_directArr removeAllObjects];
                }
                
                NSArray *dataArr = [recommendModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
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


//MARK:--获取数据
-(void)getData1{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo1];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"2" forKey:@"fromLevel"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager recommendedrewardParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo1 == 1) {
                    [_indirectArr removeAllObjects];
                }
                
                NSArray *dataArr = [recommendModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.indirectArr addObjectsFromArray:dataArr];
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
-(void)getData2{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo2];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"1" forKey:@"fromLevel"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager partnerincomeParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo2 == 1) {
                    [_indirectArr1 removeAllObjects];
                }
                
                NSArray *dataArr = [recommendModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.indirectArr1 addObjectsFromArray:dataArr];
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
-(void)getData3{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo3];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"2" forKey:@"fromLevel"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager partnerincomeParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo3 == 1) {
                    [_indirectArr2 removeAllObjects];
                }
                
                NSArray *dataArr = [recommendModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.indirectArr2 addObjectsFromArray:dataArr];
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
-(void)getData4{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo4];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"1" forKey:@"isDirect"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager teamListParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo4 == 0) {
                    [_indirectArr3 removeAllObjects];
                }
                
                NSArray *dataArr = [recommendModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.indirectArr3 addObjectsFromArray:dataArr];
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
-(void)getData5{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo5];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"0" forKey:@"isDirect"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager teamListParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo5 == 0) {
                    [_indirectArr4 removeAllObjects];
                }
                
                NSArray *dataArr = [recommendModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.indirectArr4 addObjectsFromArray:dataArr];
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
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
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
    if (self.childViewType==ChildViewType_direct) {
        return 5;
    }else if(self.childViewType==ChildViewType_indirect){
        return 6;
    }else if(self.childViewType==ChildViewType_indirect1){
        return 7;
    }else if(self.childViewType==ChildViewType_indirect2){
        return self.indirectArr2.count;
    }else if(self.childViewType==ChildViewType_indirect3){
        return self.indirectArr3.count;
    }else{
        return self.indirectArr4.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.childViewType==ChildViewType_direct) {
        RecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecommendedCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.regL.text = [[ChangeLanguage bundle] localizedStringForKey:@"registTime" value:nil table:@"English"];
//        recommendModel *model = self.directArr[indexPath.row];
//        cell.nameL.text = model.userName;
//        cell.timeL.text = model.regTime;
//        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
//        NSString*str=[self removeFloatAllZero:model.amount];
//        cell.feeL.text = [NSString stringWithFormat:@"+%@ %@",str,model.symbol];
        return cell;
    }else if(self.childViewType==ChildViewType_indirect){
        RecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecommendedCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.regL.text = [[ChangeLanguage bundle] localizedStringForKey:@"registTime" value:nil table:@"English"];
//        recommendModel *model = self.indirectArr[indexPath.row];
//        cell.nameL.text = model.userName;
//        cell.timeL.text = model.regTime;
//        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
//        NSString*str=[self removeFloatAllZero:model.amount];
//        cell.feeL.text = [NSString stringWithFormat:@"+%@ %@",str,model.symbol];
        return cell;
    }else if(self.childViewType==ChildViewType_indirect1){
        RecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecommendedCell class]) forIndexPath:indexPath];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.regL.text = [[ChangeLanguage bundle] localizedStringForKey:@"registTime" value:nil table:@"English"];
//        recommendModel *model = self.indirectArr1[indexPath.row];
//        cell.nameL.text = model.userName;
//        cell.timeL.text = model.regTime;
//        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
//        NSString*str=[self removeFloatAllZero:model.amount];
//        cell.feeL.text = [NSString stringWithFormat:@"+%@ %@",str,model.symbol];
        return cell;
    }else if(self.childViewType==ChildViewType_indirect2){
        RecommendedCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RecommendedCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.regL.text = [[ChangeLanguage bundle] localizedStringForKey:@"registTime" value:nil table:@"English"];
        recommendModel *model = self.indirectArr2[indexPath.row];
        cell.nameL.text = model.userName;
        cell.timeL.text = model.regTime;
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        NSString*str=[self removeFloatAllZero:model.amount];
        cell.feeL.text = [NSString stringWithFormat:@"+%@ %@",str,model.symbol];
        return cell;
    }else if(self.childViewType==ChildViewType_indirect3){
        TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeamListTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.regL.text = [[ChangeLanguage bundle] localizedStringForKey:@"registTime" value:nil table:@"English"];
        recommendModel *model = self.indirectArr3[indexPath.row];
        cell.nickNameLabel.text = model.userName;
        cell.timeLabel.text = model.regTime;
        [cell.avatarImageV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        if ([model.memberLevel integerValue] > 0) {
            cell.stateLabel.text = LocalizationKey(@"Realname");
            cell.stateLabel.textColor = [UIColor colorWithRed:171/255.0 green:172/255.0 blue:172/255.0 alpha:1.0];
        }else{
            cell.stateLabel.text = LocalizationKey(@"Unrealname");
            cell.stateLabel.textColor = [UIColor colorWithRed:247/255.0 green:197/255.0 blue:86/255.0 alpha:1.0];
        }
        if ([model.superPartner integerValue] > 0) {
            cell.tagLabel.text = [NSString stringWithFormat:@" %@ ",LocalizationKey(@"partner")];
            cell.tagLabel.backgroundColor = [UIColor colorWithRed:180/255.0 green:156/255.0 blue:249/255.0 alpha:1.0];
        }else{
            cell.tagLabel.text = [NSString stringWithFormat:@" %@ ",LocalizationKey(@"user")];
            cell.tagLabel.backgroundColor = [UIColor colorWithRed:151/255.0 green:218/255.0 blue:184/255.0 alpha:1.0];
        }
        return cell;
    }else{
        TeamListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TeamListTableViewCell class]) forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.regL.text = [[ChangeLanguage bundle] localizedStringForKey:@"registTime" value:nil table:@"English"];
        recommendModel *model = self.indirectArr4[indexPath.row];
        cell.nickNameLabel.text = model.userName;
        cell.timeLabel.text = model.regTime;
        [cell.avatarImageV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        if ([model.memberLevel integerValue] > 0) {
            cell.stateLabel.text = LocalizationKey(@"Realname");
            cell.stateLabel.textColor = [UIColor colorWithRed:171/255.0 green:172/255.0 blue:172/255.0 alpha:1.0];
        }else{
            cell.stateLabel.text = LocalizationKey(@"Unrealname");
            cell.stateLabel.textColor = [UIColor colorWithRed:247/255.0 green:197/255.0 blue:86/255.0 alpha:1.0];
        }
        if ([model.superPartner integerValue] > 0) {
            cell.tagLabel.text = [NSString stringWithFormat:@" %@ ",LocalizationKey(@"partner")];
            cell.tagLabel.backgroundColor = [UIColor colorWithRed:180/255.0 green:156/255.0 blue:249/255.0 alpha:1.0];
        }else{
            cell.tagLabel.text = [NSString stringWithFormat:@" %@ ",LocalizationKey(@"user")];
            cell.tagLabel.backgroundColor = [UIColor colorWithRed:151/255.0 green:218/255.0 blue:184/255.0 alpha:1.0];
        }
        return cell;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}

//更新数据
-(void)reloadData{
    
    if (self.childViewType==ChildViewType_direct) {
        
        
    }else if (self.childViewType==ChildViewType_indirect)
    {
        
    }else{
        if (![YLUserInfo isLogIn]) {
            [self showLoginViewController];
            return ;
        }
    }
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
