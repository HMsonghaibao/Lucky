//
//  noticeNewsCenterController.m
//  digitalCurrency
//
//  Created by mac on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "noticeNewsCenterController.h"
#import "ChatGroupMessageViewController.h"
#import "noticeNewsCell.h"
#import "PartnerMessageViewController.h"
#import "MineNetManager.h"
#import "ParterMessageModel.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "ChatGroupInfoModel.h"
#import "MyBillChatViewController.h"
#import "ChatGroupFMDBTool.h"
#import <AVFoundation/AVFoundation.h>
#import "PartnerMessageTableViewCell.h"
#import "ParterMessageModel.h"
#import "MyBillDetail1ViewController.h"
#import "ConversationViewController.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "TConversationListViewModel.h"
@interface noticeNewsCenterController ()<UITableViewDelegate,UITableViewDataSource,chatSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *groupInfoArr;
@property(nonatomic,strong)ChatGroupInfoModel *groupInfoModel;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger unreadcount;
@property (nonatomic, strong) TConversationListViewModel *viewModel;
@end

@implementation noticeNewsCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.groupInfoArr = [[NSMutableArray alloc] init];
    self.title = LocalizationKey(@"MessageCentertttt");
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"noticeNewsCell" bundle:nil] forCellReuseIdentifier:@"noticeNewsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PartnerMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"PartnerMessageTableViewCell"];
    
    self.pageNo = 1;
    [self getParterList];
    
    [self headRefreshWithScrollerView:self.tableView];
    [self footRefreshWithScrollerView:self.tableView];
    
    
    @weakify(self)
    [RACObserve(self.viewModel, dataList) subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (TConversationListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [TConversationListViewModel new];
        _viewModel.listFilter = ^BOOL(TUIConversationCellData * _Nonnull data) {
            return (data.convType != TIM_SYSTEM);
        };
    }
    return _viewModel;
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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getParterList];
    [self getUnReadCount];
    
    self.groupInfoArr = [ChatGroupFMDBTool getChatGroupDataArr];
    [self.tableView reloadData];
    
    if ([YLUserInfo isLogIn]) {
        NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
        [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
        [ChatSocketManager share].delegate = self;
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:[YLUserInfo shareUserInfo].ID, @"uid",nil];
    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [ChatSocketManager share].delegate = nil;
    
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"getmassgeendStr" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - SocketDelegate Delegate
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    
    if (cmd==SUBSCRIBE_GROUP_CHAT) {
        NSLog(@"订阅聊天成功");
    }
    else if (cmd==UNSUBSCRIBE_GROUP_CHAT) {
        NSLog(@"取消订阅成功");
    }
    else if (cmd==SEND_CHAT) {//发送消息
        if (endStr) {
            //            NSLog(@"发送消息--%@-收到的回复命令--%d",endStr,cmd);
        }
    }
    else if (cmd==PUSH_GROUP_CHAT)//收到消息
    {
        if (endStr) {
            NSDictionary *dic =[SocketUtils dictionaryWithJsonString:endStr];
            NSLog(@"接受消息--收到的回复-%@--%d--",dic,cmd);
            _groupInfoModel = [ChatGroupInfoModel mj_objectWithKeyValues:dic];
            //存入数据库
            [ChatGroupFMDBTool createTable:_groupInfoModel withIndex:1];
            //            [self setSound];
            self.groupInfoArr = [ChatGroupFMDBTool getChatGroupDataArr];
            [self.tableView reloadData];
            
        }
        
    }else{
        //        NSLog(@"消息-%@--%d",endStr,cmd);
    }
}



#pragma  mark-获取未读数
-(void)getUnReadCount{
    //    [self.contentArr removeAllObjects];
    [MineNetManager getUnReadCountFortype:@"INVITATION" nameid:[YLUserInfo shareUserInfo].ID CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"===%@",resPonseObj);
        
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.unreadcount = [resPonseObj[@"data"] integerValue];
                [self.tableView reloadData];
                
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
    
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


#pragma  mark-获取合伙人历史记录
-(void)getParterList{
//    [self.contentArr removeAllObjects];
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    [MineNetManager getParterlistFortype:@"NOTICE_OTC" nameid:[YLUserInfo shareUserInfo].ID limit:@"10" page:pageNoStr sortFiled:@"sendTime" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"===%@",resPonseObj);
        
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_contentArr removeAllObjects];
                }
                
                NSArray *chatArray = [ParterMessageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
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


#pragma mark - 数据源方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return self.contentArr.count;
    }else{
        return 1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        PartnerMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PartnerMessageTableViewCell" forIndexPath:indexPath];
        ParterMessageModel *model;
        model = self.contentArr[indexPath.row];
        cell.timeLabel.text = model.sendTimeStr;
        cell.titleLabel.text = model.title;
        cell.redLabel.hidden = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([model.isRead isEqualToString:@"0"]) {
            cell.redLabel.hidden = NO;
        }else{
            cell.redLabel.hidden = YES;
        }
        return cell;
    }else{
        noticeNewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"noticeNewsCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (indexPath.section == 0) {
            cell.nameL.text = LocalizationKey(@"Instantmessaging");
            cell.headImage.image = [UIImage imageNamed:@"Instantmessaging"];
            
            //获取未读计数
            int unReadCount = 0;
            NSArray *convs = [[TIMManager sharedInstance] getConversationList];
            for (TIMConversation *conv in convs) {
                if([conv getType] == TIM_SYSTEM){
                    continue;
                }
                unReadCount += [conv getUnReadMessageNum];
            }
            
            if (unReadCount > 0) {
                cell.redL.hidden = NO;
            }else{
                cell.redL.hidden = YES;
            }
                

        }else{
            cell.nameL.text = LocalizationKey(@"Noticetttt");
            cell.headImage.image = [UIImage imageNamed:@"Notice"];
            if (self.unreadcount > 0) {
                cell.redL.hidden = NO;
            }else{
                cell.redL.hidden = YES;
            }
            
        }
        return cell;
    }
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        ChatGroupMessageViewController *groupVC = [[ChatGroupMessageViewController alloc] init];
//        groupVC.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:groupVC animated:YES];
        ConversationViewController *ConversationVC = [[ConversationViewController alloc] init];
        ConversationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ConversationVC animated:YES];
    }else if (indexPath.section == 1){
        PartnerMessageViewController *groupVC = [[PartnerMessageViewController alloc] init];
        groupVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:groupVC animated:YES];
    }else{
        ParterMessageModel *model = self.contentArr[indexPath.row];
        MyBillDetail1ViewController *detailVC = [[MyBillDetail1ViewController alloc] init];
        detailVC.orderId = model.orderId;
        detailVC.avatar = model.fromAvatar;
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
        [self setMessageRead:model.msgId];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 80;
    }else{
        return 64;
    }
    
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
