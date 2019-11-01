//
//  InvestRecordViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvestRecordViewController.h"
#import "InvestSectionHeaderView.h"
#import "InvestRecordTableViewCell.h"
#import "MineNetManager.h"
#import "InvestRecordModel.h"

static NSString * const InvestRecordCellIdentifier = @"InvestRecordCellIdentifier";

@interface InvestRecordViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSInteger _pageNo;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation InvestRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _pageNo = 1;
    [self UILayout];
    [self requestData];
}

//MARK:--上拉加载
- (void)refreshFooterAction{
    _pageNo++;
    [self requestData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
   _pageNo = 1 ;
    [self requestData];
}


- (void)requestData{
    
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    
//    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
//    [bodydic setValue:pageNoStr forKey:@"pageNo"];
//    [bodydic setValue:@"10" forKey:@"pageSize"];
//    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getInvestRecordParams:nil CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [self.dataSource removeAllObjects];
                }
                NSArray *dataArr = [InvestRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                
                [self.dataSource addObjectsFromArray:dataArr];
                [self.tableView reloadData];
                
                if (self.dataSource.count > 0) {
                    self.tableView.ly_emptyView.hidden = YES;
                }else{
                    self.tableView.ly_emptyView.hidden = NO;
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

- (void)UILayout{
    
    self.title = LocalizationKey(@"InvestmentRecord");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"InvestRecordTableViewCell" bundle:nil] forCellReuseIdentifier:InvestRecordCellIdentifier];
    
//    [self headRefreshWithScrollerView:self.tableView];
//    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    InvestRecordModel *model = self.dataSource[section];
    if (model.selected) {
        return model.recList.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InvestRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InvestRecordCellIdentifier forIndexPath:indexPath];
    InvestRecordModel *model = self.dataSource[indexPath.section];
    [cell refreshUI:model.recList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    InvestSectionHeaderView *header = [[NSBundle mainBundle] loadNibNamed:@"InvestSectionHeaderView" owner:self options:nil].lastObject;
    header.tag = section;
    InvestRecordModel *model = self.dataSource[section];
    [header refreshUI:model];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singTapAction:)];
    [header addGestureRecognizer:tap];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    InvestRecordModel *model = self.dataSource[section];
    if (model.selected) {
        return 76;
    }else{
        return 67;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)singTapAction:(UITapGestureRecognizer *)tap{
//    NSLog(@"tap: %d",tap.view.tag);
    
    InvestRecordModel *model = self.dataSource[tap.view.tag];
    if (model.selected) {
        model.selected = NO;
    }else{
        model.selected = YES;
    }
    [self.tableView reloadData];
    
    self.tableView.ly_emptyView.hidden = YES;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
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
