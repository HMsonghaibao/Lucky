//
//  MyBillChatViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/4/4.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyBillChatViewController.h"
#import "UITextView+Placeholder.h"
#import "ChatTableViewCell.h"
#import "IQKeyboardManager.h"
#import "MineNetManager.h"
#import "YLTabBarController.h"
#import "ChatGroupFMDBTool.h"
#import "MyBillDetail1ViewController.h"
@interface MyBillChatViewController ()<UITableViewDelegate,UITableViewDataSource,chatSocketDelegate,UITextViewDelegate>
{
    int _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UITextView *sendTextView;//发送输入框
@property (weak, nonatomic) IBOutlet UIButton *sendButton;//发送按钮
@property(nonatomic,strong)NSMutableArray *chatArr;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property(nonatomic,assign)NSInteger maxTextH;
@property(nonatomic,assign)NSInteger textOldH;
@end

@implementation MyBillChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _page=1;
    self.view.backgroundColor = mainColor;
    if (self.clickIndex == 1) {
        self.title = self.groupModel.nameFrom;
        [self rightBarItemWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"orderDetail" value:nil table:@"English"]];
    }else{
      self.title = self.model.otherSide;
    }
    [self.sendButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"send" value:nil table:@"English"] forState:UIControlStateNormal];
    
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    [self.tableView registerClass:[ChatTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ChatTableViewCell class])];
    [self headRefreshWithScrollerView:self.tableView];
    self.sendTextView.clipsToBounds = YES;
    self.sendTextView.layer.borderWidth = 1;
    self.sendTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.sendTextView.layer.cornerRadius = 6;
    self.sendTextView.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputSendContent" value:nil table:@"English"];
    [self getChatRecord];
  
    [self initController];
}


- (void)initController{
    self.sendTextView.delegate = self;
    self.sendTextView.scrollEnabled = NO;
    self.sendTextView.scrollsToTop = NO;
    self.sendTextView.layer.borderWidth = 1;
    self.sendTextView.layer.cornerRadius = 5;
    self.sendTextView.font = [UIFont systemFontOfSize:17];
//    当textview的字符串为0时发送（rerurn）键无效
    self.sendTextView.enablesReturnKeyAutomatically = YES;
    self.sendTextView.keyboardType = UIKeyboardTypeDefault;
//    键盘return样式变成发送
    self.sendTextView.returnKeyType = UIReturnKeySend;
    
//    监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self

                                             selector:@selector(keyboardWasShown:)

                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
//     计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextH = ceil(self.sendTextView.font.lineHeight * 6 + self.sendTextView.textContainerInset.top + self.sendTextView.textContainerInset.bottom);
    
}


#pragma mark ================textViewdelegate=========================
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView==self.sendTextView && [text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [self sendBtnClick:nil];

        textView.text = nil;
        [self textViewDidChange:textView];
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView {
    NSInteger height = ceilf([self.sendTextView sizeThatFits:CGSizeMake(self.sendTextView.bounds.size.width, MAXFLOAT)].height);
    if (_textOldH!=height) {
        // 最大高度，可以滚动
        self.sendTextView.scrollEnabled = height > _maxTextH && _maxTextH > 0;

        if (self.sendTextView.scrollEnabled==NO) {
            _heightConstraint.constant = height + 11;//距离上下边框各为5，所以加10
            [self.view layoutIfNeeded];
            self.tableView.frame = CGRectMake(0, 0, kWindowW,  self.backView.frame.origin.y);
            if (self.chatArr.count>0) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        }

        _textOldH = height;

    }

}


- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    // 获取键盘弹出时长
    CGFloat duration = [aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    //键盘高度
    CGRect keyBoardFrame = [[[aNotification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    //调增backView距离父视图底部的距离
    _bottomViewHeight.constant = keyBoardFrame.origin.y != screenH?keyBoardFrame.size.height:0;
    
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
        self.tableView.frame = CGRectMake(0, 0, kWindowW,  self.backView.frame.origin.y);
        if (self.chatArr.count>0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }];
    
}


//MARK:--首页聊天组进入导航右边的订单详情
-(void)RighttouchEvent{
    MyBillDetail1ViewController *detailVC = [[MyBillDetail1ViewController alloc] init];
    detailVC.hidesBottomBarWhenPushed = YES;
    detailVC.flagIndex = 1;
    detailVC.orderId = _groupModel.orderId;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //检测键盘frame变化的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardFrameChanged:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getmassgeendStr:) name:@"getmassgeendStr" object:nil];
}



-(void)getmassgeendStr:(NSNotification*)noti{
    [self.chatArr removeAllObjects];
    [self getChatRecord];
//    NSString*endStr=noti.object;
//    if (endStr) {
//        NSLog(@"====%@",endStr);
//        NSDictionary *dic =[SocketUtils dictionaryWithJsonString:endStr];
//        ChatModel *model = [ChatModel mj_objectWithKeyValues:dic];
//
//        ChatGroupInfoModel *info = [[ChatGroupInfoModel alloc] init];
//        info.content = model.content;
//        info.uidTo = model.uidTo;
//        info.uidFrom = model.uidFrom;
//        info.avatar = model.avatar;
//        info.orderId = model.orderId;
//        info.nameTo = model.nameTo;
//        info.nameFrom = model.nameFrom;
//        info.flagIndex = model.flagIndex;
//        info.sendTimeStr = model.sendTimeStr;
//        [ChatGroupFMDBTool createTable:info withIndex:0];//存储数据
//        if (self.clickIndex == 1) {//首页进来
//            if ([info.orderId isEqualToString:_groupModel.orderId]) {
//                [self.chatArr addObject:model];
//                [self.tableView reloadData];
//                if (self.chatArr.count != 0) {
//                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                }
//            }
//        }else{ //订单详情进来
//            if ([info.orderId isEqualToString:self.model.orderSn]) {
//                [self.chatArr addObject:model];
//                [self.tableView reloadData];
//                if (self.chatArr.count != 0) {
//                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//                }
//            }
//        }
//        //            NSLog(@"接收消息--收到的回复-%@--%d--",dic,cmd);
//    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [self.sendTextView becomeFirstResponder];

    NSDictionary *dic;
    if (self.clickIndex == 1) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:self.groupModel.uidTo, @"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:self.model.myId, @"uid",nil];
    }
    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [ChatSocketManager share].delegate=self;
}

#pragma  mark-获取聊天记录
-(void)getChatRecord{
    NSString *orderSn;
    NSString *uidTo;
    NSString *uidFrom;
    if (self.clickIndex == 1) {
        orderSn = self.groupModel.orderId;
        uidTo = self.groupModel.uidTo;
        uidFrom = self.groupModel.uidFrom;
    }else{
        orderSn = self.model.orderSn;
        uidTo = self.model.hisId;
        uidFrom = self.model.myId;
    }
    [MineNetManager chatRecordDetailForId:orderSn uidTo:uidTo uidFrom:uidFrom limit:@"20" page:[NSString stringWithFormat:@"%d",_page] sortFiled:@"sendTime" CompleteHandle:^(id resPonseObj, int code) {
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSArray *chatArray = [ChatModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                 chatArray=(NSMutableArray *)[[chatArray reverseObjectEnumerator] allObjects];//倒叙排列
                NSRange range = NSMakeRange(0, chatArray.count);
                NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
                 [self.chatArr insertObjects:chatArray atIndexes:set]; // 将历史数据，添加到总数组的最前面
                for (ChatModel *model in self.chatArr) {
                    if (_clickIndex == 1) {
                        model.avatar = self.groupModel.avatar;
                    }else{
                        model.avatar = self.avatar;
                    }
                }
                [self.tableView reloadData];
                NSLog(@"====%lu",self.chatArr.count);
                if (self.chatArr.count != 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                }
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
        
    }];
}

#pragma mark-下拉加载聊天数据记录
- (void)refreshHeaderAction{
    _page+=1;
    [self getChatRecord];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChatTableViewCell class]) forIndexPath:indexPath];
    ChatModel *model = self.chatArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell refreshCell:model];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self cellForHeight:self.chatArr[indexPath.row]] <= 30) {
        return 60;
    }else if ([self cellForHeight:self.chatArr[indexPath.row]] <= 50){
        return 70;
    }else{
        return [self cellForHeight:self.chatArr[indexPath.row]]+30;
        
    }
}
-(CGFloat)cellForHeight:(ChatModel*)model{
    // 首先计算文本宽度和高度
    CGRect rec = [model.content boundingRectWithSize:CGSizeMake(200, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]} context:nil];
    return rec.size.height;
}
//MARK:--发送按钮的点击事件
- (IBAction)sendBtnClick:(UIButton *)sender {
    if ([self.sendTextView.text isEqualToString:@""]) {
       // [self.view makeToast:@"不得发送空的内容" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    //发送消息内容
    ChatModel *model = [[ChatModel alloc] init];
    model.content = self.sendTextView.text;
    
    NSLog(@"===%lu",self.clickIndex);
    
    if (self.clickIndex == 1) {
        model.uidFrom = self.groupModel.uidTo;
    }else{
        model.uidFrom = self.model.myId;
    }
    [self.chatArr addObject:model];
    [self.tableView reloadData];
    if (self.chatArr.count != 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    NSDictionary *dic;
    if (self.clickIndex == 1) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:self.groupModel.orderId,@"orderId",self.groupModel.uidTo,@"uidFrom",self.groupModel.uidFrom,@"uidTo",self.groupModel.nameTo,@"nameTo",[YLUserInfo shareUserInfo].userName,@"nameFrom",[NSNumber numberWithInt:1],@"messageType",self.sendTextView.text,@"content",[YLUserInfo shareUserInfo].avatar,@"avatar", nil];
        ChatGroupInfoModel *info = [[ChatGroupInfoModel alloc] init];
        info.content = model.content;
        info.uidTo = self.groupModel.uidTo;
        info.uidFrom = self.groupModel.uidFrom;
        info.avatar = self.groupModel.avatar;
        info.orderId = self.groupModel.orderId;
        info.nameTo = self.groupModel.nameTo;
        info.nameFrom = self.groupModel.nameFrom;
        info.flagIndex = self.groupModel.flagIndex;
        info.sendTimeStr = [ToolUtil getCurrentDateString];
        [ChatGroupFMDBTool createTable:info withIndex:0];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:self.model.orderSn,@"orderId",self.model.myId,@"uidFrom",self.model.hisId,@"uidTo",self.model.otherSide,@"nameTo",[YLUserInfo shareUserInfo].userName,@"nameFrom",[NSNumber numberWithInt:1],@"messageType",self.sendTextView.text,@"content",[YLUserInfo shareUserInfo].avatar,@"avatar", nil];
        ChatGroupInfoModel *info = [[ChatGroupInfoModel alloc] init];
        info.content = model.content;
        info.uidTo = self.model.myId;
        info.uidFrom = self.model.hisId;
        info.avatar = self.avatar;
        info.orderId = self.model.orderSn;
        info.nameTo = [YLUserInfo shareUserInfo].userName;
        info.nameFrom = self.model.otherSide;
        info.flagIndex = model.flagIndex;
        info.sendTimeStr = [ToolUtil getCurrentDateString];
        [ChatGroupFMDBTool createTable:info withIndex:0];
    }
    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SEND_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
//    self.sendTextView.text = @"";
    self.sendTextView.text = nil;
    [self textViewDidChange:self.sendTextView];
}
#pragma mark - SocketDelegate Delegate
- (void)ChatdelegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
  
    if (cmd==SEND_CHAT) {//发送消息
        if (endStr) {
             NSLog(@"发送消息--%@-收到的回复命令--%d",endStr,cmd);
        }
    }
    else if (cmd==PUSH_GROUP_CHAT)//收到组消息
    {
        if (endStr) {
            
            NSDictionary *dic =[SocketUtils dictionaryWithJsonString:endStr];
            ChatModel *model = [ChatModel mj_objectWithKeyValues:dic];

            ChatGroupInfoModel *info = [[ChatGroupInfoModel alloc] init];
            info.content = model.content;
            info.uidTo = model.uidTo;
            info.uidFrom = model.uidFrom;
            info.avatar = model.avatar;
            info.orderId = model.orderId;
            info.nameTo = model.nameTo;
            info.nameFrom = model.nameFrom;
            info.flagIndex = model.flagIndex;
            info.sendTimeStr = model.sendTimeStr;
            [ChatGroupFMDBTool createTable:info withIndex:0];//存储数据
            if (self.clickIndex == 1) {//首页进来
                if ([info.orderId isEqualToString:_groupModel.orderId]) {
                    [self.chatArr addObject:model];
                    [self.tableView reloadData];
                    if (self.chatArr.count != 0) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }
            }else{ //订单详情进来
                if ([info.orderId isEqualToString:self.model.orderSn]) {
                    [self.chatArr addObject:model];
                    [self.tableView reloadData];
                    if (self.chatArr.count != 0) {
                        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    }
                }
            }
//            NSLog(@"接收消息--收到的回复-%@--%d--",dic,cmd);
        }
        
    }else{
        NSLog(@"单聊消息-%@--%d",endStr,cmd);
    }
}
#pragma mark 键盘高度发生变化
//- (void)keyBoardFrameChanged:(NSNotification* )notification
//{
//    CGRect rect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationCurve:7];
//
//    if (rect.origin.y == kWindowH) {
//        self.backView.frame = CGRectMake(0, rect.origin.y- 50-SafeAreaTopHeight- SafeAreaBottomHeight, kWindowW, 50);
//
//    }else{
//        self.backView.frame = CGRectMake(0, rect.origin.y- 50-SafeAreaTopHeight, kWindowW, 50);
//    }
//    //改变表的坐标
//    self.tableView.frame = CGRectMake(0, 0, kWindowW,  self.backView.frame.origin.y);
//    [UIView commitAnimations];
//    if (self.chatArr.count>0) {
//          [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatArr.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
//}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
//    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:self.model.myId, @"uid",nil];
//    [[ChatSocketManager share] ChatsendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_GROUP_CHAT withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [ChatSocketManager share].delegate = nil;
    [self.sendTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSMutableArray*array=[ChatGroupFMDBTool getChatGroupDataArr];
    ChatGroupInfoModel*model = array[array.count-1];
    model.flagIndex = 0;
    NSLog(@"====%@",model.content);
    [ChatGroupFMDBTool changeData:model];
    
}
- (NSMutableArray *)chatArr
{
    if (!_chatArr) {
        _chatArr = [[NSMutableArray alloc]init];
    }
    return _chatArr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
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
