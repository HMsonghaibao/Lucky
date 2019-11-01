//
//  LockRecordViewController.m
//  digitalCurrency
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "LockRecordViewController.h"
#import "LockwareViewCell.h"
#import "MineNetManager.h"
#import "lockRecordModel.h"
#import "PlatformMessageDetailViewController.h"
#import "HelpCenterDetailsViewController.h"
@interface LockRecordViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property(nonatomic,strong)NSMutableArray *lockRecordArr;
@property(nonatomic,assign)NSInteger pageNo;
@end

@implementation LockRecordViewController

- (NSMutableArray *)lockRecordArr {
    if (!_lockRecordArr) {
        _lockRecordArr = [NSMutableArray array];
    }
    return _lockRecordArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = mainColor;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"Unlockrecord" value:nil table:@"English"];
    self.title = LocalizationKey(@"Noticetttt");
    self.timeL.text = [[ChangeLanguage bundle] localizedStringForKey:@"time" value:nil table:@"English"];
    self.countL.text = [[ChangeLanguage bundle] localizedStringForKey:@"amonut" value:nil table:@"English"];
    self.typeL.text = [[ChangeLanguage bundle] localizedStringForKey:@"type" value:nil table:@"English"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"LockwareViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([LockwareViewCell class])];
    
    self.pageNo = 1;
    
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    [self getData];
    
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
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


//MARK:--获取数据
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"page"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        bodydic[@"language"] = @"en_us";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        bodydic[@"language"] = @"zh_cn";
    }
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryAddLockRecordPageParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"---=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_lockRecordArr removeAllObjects];
                }
                
                NSArray *dataArr = [lockRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"rows"]];
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
    
    lockRecordModel *model = self.lockRecordArr[indexPath.row];
    cell.timeL.text = model.createTime;
    cell.lockNumberL.text = [self filterHTML:model.content];
    cell.lockL.text = model.title;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 170;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    PlatformMessageModel*model=self.platformMessageArr[indexPath.row];
    lockRecordModel *model = self.lockRecordArr[indexPath.row];
    PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
    detailVC.type = @"1";
    detailVC.content = model.content;
    detailVC.navtitle = model.title;
    [[AppDelegate sharedAppDelegate] pushViewController:detailVC];
    
//    HelpCenterDetailsViewController *detail = [[HelpCenterDetailsViewController alloc] init];
//    detail.title = LocalizationKey(@"Articledetails");
////    detail.contentModel = model.content[indexPath.row];
//    [[AppDelegate sharedAppDelegate] pushViewController:detail];
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
//        [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
        lockRecordModel *model = self.lockRecordArr[indexPath.row];
        NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
        [bodydic setValue:model.id forKey:@"noticeId"];
        [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
        NSLog(@"=====%@",bodydic);
        
        [MineNetManager lockRecordParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
            [EasyShowLodingView hidenLoding];
            
            NSLog(@"---=====%@",resPonseObj);
            
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    
                    [self.lockRecordArr removeObjectAtIndex:indexPath.row];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                   
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
