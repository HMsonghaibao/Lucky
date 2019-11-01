//
//  ChatWithViewController.m
//  digitalCurrency
//
//  Created by 宋海保 on 2019/8/23.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ChatWithViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "TUIVideoMessageCell.h"
#import "TUIFileMessageCell.h"
#import "TUIKit.h"
#import "ReactiveObjC/ReactiveObjC.h"
#import "MMLayout/UIView+MMLayout.h"

#import "THelper.h"
@interface ChatWithViewController ()<TUIChatControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate>
@property (nonatomic, strong) TUIChatController *chat;
@end

@implementation ChatWithViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TIMConversation *conv = [[TIMManager sharedInstance] getConversation:_conversationData.convType receiver:_conversationData.convId];
    _chat = [[TUIChatController alloc] initWithConversation:conv];
    _chat.delegate = self;
    [self addChildViewController:_chat];
    [self.view addSubview:_chat.view];
    
    RAC(self, title) = [RACObserve(_conversationData, title) distinctUntilChanged];
    
#if CUSTOM
    NSMutableArray *moreMenus = [NSMutableArray arrayWithArray:_chat.moreMenus];
    [moreMenus addObject:({
        TUIInputMoreCellData *data = [TUIInputMoreCellData new];
        data.image = [UIImage tk_imageNamed:@"default_head"];
        data.title = @"自定义";
        data;
    })];
    _chat.moreMenus = moreMenus;
#endif
    
//    [self setupNavigator];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onRefreshNotification:)
                                                 name:TUIKitNotification_TIMRefreshListener
                                               object:nil];
    
    //添加未读计数的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onChangeUnReadCount:)
                                                 name:TUIKitNotification_onChangeUnReadCount
                                               object:nil];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 禁用返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 开启返回手势
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


- (void)willMoveToParentViewController:(UIViewController *)parent
{
    if (parent == nil) {
        [_chat saveDraft];
    }
}

// 聊天窗口标题由上层维护，需要自行设置标题
- (void)onRefreshNotification:(NSNotification *)notifi
{
    
    NSArray<TIMConversation *> *convs = notifi.object;
    if ([convs isKindOfClass:[NSArray class]]) {
        for (TIMConversation *conv in convs) {
            if ([[conv getReceiver] isEqualToString:_conversationData.convId]) {
                if (_conversationData.convType == TIM_GROUP) {
                    _conversationData.title = [conv getGroupName];
                } else if (_conversationData.convType == TIM_C2C) {
                    TIMUserProfile *user = [[TIMFriendshipManager sharedInstance] queryUserProfile:_conversationData.convId];
                    if (user) {
                        _conversationData.title = [user showName];
                    }
                }
            }
        }
    }
    
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)setupNavigator
//{
//    //left
//    _unRead = [[TUnReadView alloc] init];
//
//    //_unRead.backgroundColor = [UIColor grayColor];//可通过此处将未读标记设置为灰色，类似微信，但目前仍使用红色未读视图
//    UIBarButtonItem *urBtn = [[UIBarButtonItem alloc] initWithCustomView:_unRead];
//
//
//    self.navigationItem.leftBarButtonItems = @[urBtn];
//
//    //既显示返回按钮，又显示未读视图
//    self.navigationItem.leftItemsSupplementBackButton = YES;
//
//
//
//}
//
//-(void)leftBarButtonClick
//{
//    [self.navigationController popViewControllerAnimated:YES];
//}



- (void)chatController:(TUIChatController *)chatController onSelectMoreCell:(TUIInputMoreCell *)cell
{
//    if ([cell.data.title isEqualToString:@"自定义"]) {
//        MyCustomCellData *cellData = [[MyCustomCellData alloc] initWithDirection:MsgDirectionOutgoing];
//        cellData.text = @"欢迎加入云通信IM大家庭！";
//        cellData.link = @"www.qq.com";
//
//        cellData.innerMessage = [[TIMMessage alloc] init];
//        TIMCustomElem * custom_elem = [[TIMCustomElem alloc] init];
//        [cellData.innerMessage addElem:custom_elem];
//
//        [chatController sendMessage:cellData];
//    }
}

- (TUIMessageCellData *)chatController:(TUIChatController *)controller onNewMessage:(TIMMessage *)msg
{
#if CUSTOM
    TIMElem *elem = [msg getElem:0];
    if([elem isKindOfClass:[TIMCustomElem class]]){
        MyCustomCellData *cellData = [[MyCustomCellData alloc] initWithDirection:msg.isSelf ? MsgDirectionOutgoing : MsgDirectionIncoming];
        cellData.text = @"欢迎加入云通信IM大家庭！";
        cellData.link = @"www.qq.com";
        cellData.avatarUrl = [[TIMFriendshipManager sharedInstance] querySelfProfile].faceURL;
        return cellData;
    }
#endif
    return nil;
}

- (TUIMessageCell *)chatController:(TUIChatController *)controller onShowMessageData:(TUIMessageCellData *)data
{
#if CUSTOM
    if ([data isKindOfClass:[MyCustomCellData class]]) {
        MyCustomCell *myCell = [[MyCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
        [myCell fillWithData:(MyCustomCellData *)data];
        return myCell;
    }
#endif
    return nil;
}

- (void)chatController:(TUIChatController *)controller onSelectMessageContent:(TUIMessageCell *)cell
{
    
}

- (void) onChangeUnReadCount:(NSNotification *)notifi{
    NSNumber *count = notifi.object;
    
    //此处获取本对话的未读计数，并减去本对话的未读。如果不减去，则在本对话中收到消息时，消息不会自动设为已读，从而会错误显示左上角未读计数。
    TIMConversation *conv = [[TIMManager sharedInstance] getConversation:_conversationData.convType receiver:_conversationData.convId];
    count = [NSNumber numberWithInteger:(count.integerValue - conv.getUnReadMessageNum)];
    
    [_unRead setNum:count.integerValue];
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
