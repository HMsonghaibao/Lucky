//
//  PartnerMessageViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "PartnerMessageViewController.h"
#import "PartnerMessageTableViewCell.h"
#import "PartnerDetailViewController.h"
#import "MineNetManager.h"
#import "ParterMessageModel.h"
static NSString * PartnerMessageCellId = @"PartnerMessageCellId";

@interface PartnerMessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *contentArr;
@property(nonatomic,assign)NSInteger pageNo;
@end

@implementation PartnerMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    self.title = LocalizationKey(@"Notificationlistttt");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PartnerMessageTableViewCell" bundle:nil] forCellReuseIdentifier:PartnerMessageCellId];
    
    self.pageNo = 1;
    [self getParterList];
    [self languageSetting];
    
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
}


//MARK:--上拉加载
- (void)refreshFooterAction{
    self.pageNo++;
    [self getParterList];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1 ;
    [self getParterList];
}


//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getParterList];
}


#pragma  mark-获取合伙人历史记录
-(void)getParterList{
//    [self.contentArr removeAllObjects];
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    [MineNetManager getParterlistFortype:@"INVITATION" nameid:[YLUserInfo shareUserInfo].ID limit:@"10" page:pageNoStr sortFiled:@"sendTime" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"===%@",resPonseObj);
        
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_contentArr removeAllObjects];
                }
                NSArray *chatArray = [ParterMessageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                
//                chatArray=(NSMutableArray *)[[chatArray reverseObjectEnumerator] allObjects];//倒叙排列
//                NSRange range = NSMakeRange(0, chatArray.count);
//                NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
//                [self.contentArr insertObjects:chatArray atIndexes:set]; // 将历史数据，添加到总数组的最前面
                
                [self.contentArr addObjectsFromArray:chatArray];
                [self.tableView reloadData];
                
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    PartnerMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PartnerMessageCellId forIndexPath:indexPath];
    ParterMessageModel *model;
    model = self.contentArr[indexPath.row];
    cell.timeLabel.text = model.sendTimeStr;
//    cell.titleLabel.text = model.title;
    cell.titleLabel.text = [NSString stringWithFormat:@"%@ %@",model.nameFrom,LocalizationKey(@"invitesyoutobecomeapartnerofNTEX")];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([model.isRead isEqualToString:@"0"]) {
        cell.redLabel.hidden = NO;
    }else{
        cell.redLabel.hidden = YES;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        return 84;
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        return 64;
    }
    return 64;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PartnerDetailViewController *groupVC = [[PartnerDetailViewController alloc] init];
    ParterMessageModel *model;
    model = self.contentArr[indexPath.row];
    NSData *jsonData = [model.content dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&err];
    groupVC.applyType = [dict[@"applyType"] integerValue];
    groupVC.uidFrom = model.uidFrom;
    groupVC.nameFrom = model.nameFrom;
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
    [self setMessageRead:model.msgId];
}


#pragma  mark-设置已读
-(void)setMessageRead:(NSString*)msgId{
    [MineNetManager setMessageReadForMsgid:msgId CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"===%@",resPonseObj);
        
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
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
