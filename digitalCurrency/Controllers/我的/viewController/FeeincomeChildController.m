//
//  FeeincomeChildController.m
//  digitalCurrency
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "FeeincomeChildController.h"
#import "FeeincomeChlidCell.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "MarketViewController.h"
#import "MineNetManager.h"
#import "feeincomeModel.h"
@interface FeeincomeChildController ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL _isDragging;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)ChildViewType childViewType;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *contentArr1;
@property(nonatomic,strong)NSMutableArray *contentArr2;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger pageNo1;
@property(nonatomic,assign)NSInteger pageNo2;
@end

@implementation FeeincomeChildController

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
    [self setUpViews];
    self.view.backgroundColor = RGBCOLOR(18, 22, 28);
    [self.tableView registerNib:[UINib nibWithNibName:@"FeeincomeChlidCell" bundle:nil] forCellReuseIdentifier:@"FeeincomeChlidCell"];
    self.tableView.frame=CGRectMake(0, 0, kWindowW, kWindowH-SafeAreaTopHeight-SafeAreaBottomHeight-40);
    self.tableView.rowHeight=60;

    
    self.pageNo = 1;
    self.pageNo1 = 1;
    self.pageNo2 = 1;
    
    
    if (self.childViewType==ChildViewType_USDT) {
        [self getData];
    }else if(self.childViewType==ChildViewType_BTC){
        [self getData1];
    }else{
        [self getData2];
    }
    
    
    [self languageSetting];
    
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
}



//MARK:--上拉加载
- (void)refreshFooterAction{
    if (self.childViewType==ChildViewType_USDT) {
        self.pageNo++;
        [self getData];
    }else if(self.childViewType==ChildViewType_BTC){
        self.pageNo1++;
        [self getData1];
    }else{
        self.pageNo2++;
        [self getData2];
    }
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    if (self.childViewType==ChildViewType_USDT) {
        self.pageNo = 1 ;
        [self getData];
    }else if(self.childViewType==ChildViewType_BTC){
        self.pageNo1 = 1 ;
        [self getData1];
    }else{
        self.pageNo2 = 1 ;
        [self getData2];
    }
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
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
    [bodydic setValue:@"1" forKey:@"fromLevel"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager feeincomeParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_contentArr removeAllObjects];
                }
                
                NSArray *dataArr = [feeincomeModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
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
    [bodydic setValue:@"0" forKey:@"fromLevel"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager feeincomeParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo1 == 1) {
                    [_contentArr1 removeAllObjects];
                }
                
                NSArray *dataArr = [feeincomeModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
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

//MARK:--获取数据
-(void)getData2{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo2];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"2" forKey:@"fromLevel"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager feeincomeParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo2 == 1) {
                    [_contentArr2 removeAllObjects];
                }
                
                NSArray *dataArr = [feeincomeModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.contentArr2 addObjectsFromArray:dataArr];
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


- (void)setUpViews
{
    [self.view addSubview:self.tableView];
}


//更新数据
-(void)reloadData{
    
    if (self.childViewType==ChildViewType_USDT) {
        [self getData];
        
    }else if (self.childViewType==ChildViewType_BTC)
    {
        [self getData1];
    }else{
        [self getData2];
    }
}


-(NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}



- (NSString*)removeFloatAllZeroByString:(NSString *)testNumber{
    
    NSString * s = nil;
    long offset = testNumber.length - 1;
    while (offset)
        {
            s = [testNumber substringWithRange:NSMakeRange(offset, 1)];
            NSLog(@"===%@",s);
            if ([s isEqualToString:@"0"] || [s isEqualToString:@"."]){
                offset--;
            }else{
                break;
            }
                
        }
    NSString * outNumber = [testNumber substringToIndex:offset+1];
    return outNumber;
    
}


-(NSString *)removeFloatAllZeroSting:(NSString *)string{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    //价格格式化显示
    NSNumberFormatter * formatter = [[NSNumberFormatter alloc]init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    NSString * formatterString = [formatter stringFromNumber:[NSNumber numberWithFloat:[outNumber doubleValue]]];
    //获取要截取的字符串位置
    NSRange range = [formatterString rangeOfString:@"."];
    if (range.length >0 ) {
        NSString * result = [formatterString substringFromIndex:range.location];
        if (result.length >= 4) {
            formatterString = [formatterString substringToIndex:formatterString.length - 1];
        }
    }
    return  formatterString;
}



- (NSString *)displaySting:(NSString *)string{
    /**
     *  方法1（正则表达式）
     */
//    NSString *regexZero = @"[0]$";
//    NSString *regexDot = @"[.]$";
//    NSPredicate *predZero = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexZero];
//    NSPredicate *predDot = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexDot];
//    while ([predZero evaluateWithObject:string] || [predDot evaluateWithObject:string]) {
//        string = [string substringToIndex:string.length - 1];
//    }
    
    /**
     *  方法2
     */
    while ([[string substringFromIndex:string.length - 1] isEqualToString:@"0"] || [[string substringFromIndex:string.length - 1] isEqualToString:@"."]) {
            string = [string substringToIndex:string.length - 1];
    }
    
    return string;
}


#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.childViewType==ChildViewType_USDT) {
        return self.contentArr.count;
    }else if (self.childViewType==ChildViewType_BTC)
    {
        return self.contentArr1.count;
    }else{
        return self.contentArr2.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FeeincomeChlidCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FeeincomeChlidCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.traL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Settlementtime" value:nil table:@"English"];
    cell.numL.text = [[ChangeLanguage bundle] localizedStringForKey:@"Quantityrelationship" value:nil table:@"English"];
    cell.comeL.text = [[ChangeLanguage bundle] localizedStringForKey:@"income" value:nil table:@"English"];
    feeincomeModel *model;
    if (self.childViewType==ChildViewType_USDT) {
        model = self.contentArr[indexPath.row];
    }else if (self.childViewType==ChildViewType_BTC)
    {
        model = self.contentArr1[indexPath.row];
    }else{
        model = self.contentArr2[indexPath.row];
    }
    
    cell.nameL.text = model.userName;
    cell.timeL.text = model.createTime;
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
//    NSString*fromMoneystr=[self removeFloatAllZero:[NSString stringWithFormat:@"%@",model.fromMoney]];
//    NSString*amountstr=[self removeFloatAllZero:[NSString stringWithFormat:@"%@",model.amount]];
//    NSString*fromMoneystr=[self removeFloatAllZeroByString:[NSString stringWithFormat:@"%@",model.fromMoney]];
//    NSString*amountstr=[self removeFloatAllZeroByString:[NSString stringWithFormat:@"%@",model.amount]];
//    NSString*fromMoneystr=[self removeFloatAllZeroSting:[NSString stringWithFormat:@"%@",model.fromMoney]];
//    NSString*amountstr=[self removeFloatAllZeroSting:[NSString stringWithFormat:@"%@",model.amount]];
//    NSString*fromMoneystr=[self displaySting:[NSString stringWithFormat:@"%@",model.fromMoney]];
//    NSString*amountstr=[self displaySting:[NSString stringWithFormat:@"%@",model.amount]];
//    cell.comeMoneyL.text = [NSString stringWithFormat:@"+%@ %@",str,model.symbol];
//    cell.comeMoneyL.text = [NSString stringWithFormat:@"+%@ %@",amountstr,model.symbol];
//    cell.numberL.text = [NSString stringWithFormat:@"%@ %@",fromMoneystr,model.symbol];
    cell.comeMoneyL.text = [NSString stringWithFormat:@"+%@ %@",model.amount,model.symbol];
    cell.numberL.text = [NSString stringWithFormat:@"%@ %@",model.fromMoney,model.symbol];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 106;
}

//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _isDragging=YES;
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    _isDragging=NO;
}
#pragma mark - 懒加载
- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = RGBCOLOR(18, 22, 28);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
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

- (NSMutableArray *)contentArr2
{
    if (!_contentArr2) {
        _contentArr2 = [NSMutableArray array];
    }
    return _contentArr2;
}

@end
