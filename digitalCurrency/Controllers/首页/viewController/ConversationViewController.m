//
//  ConversationViewController.m
//  digitalCurrency
//
//  Created by 宋海保 on 2019/8/23.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "ConversationViewController.h"
#import "TUIConversationListController.h"
#import "ChatWithViewController.h"
#import "TNaviBarIndicatorView.h"
@interface ConversationViewController ()<TUIConversationListControllerDelegagte>
@property (nonatomic, strong) TNaviBarIndicatorView *titleView;
@end

@implementation ConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TUIConversationListController *conv = [[TUIConversationListController alloc] init];
    conv.delegate = self;
    [self addChildViewController:conv];
    [self.view addSubview:conv.view];
//
//    //如果不加这一行代码，依然可以实现点击反馈，但反馈会有轻微延迟，体验不好。
    conv.tableView.delaysContentTouches = NO;
    
//    self.title = @"NTEX";
    [self setupNavigation];
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


/**
 *初始化导航栏
 */
- (void)setupNavigation
{
    _titleView = [[TNaviBarIndicatorView alloc] init];
    [_titleView setTitle:@"NTEX"];
    [_titleView setTintColor:[UIColor whiteColor]];
    self.navigationItem.titleView = _titleView;
    self.navigationItem.title = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNetworkChanged:) name:TUIKitNotification_TIMConnListener object:nil];
}

/**
 *初始化导航栏Title，不同连接状态下Title显示内容不同
 */
- (void)onNetworkChanged:(NSNotification *)notification
{
    TUINetStatus status = (TUINetStatus)[notification.object intValue];
    switch (status) {
        case TNet_Status_Succ:
            [_titleView setTitle:@"NTEX"];
            [_titleView stopAnimating];
            break;
        case TNet_Status_Connecting:
            [_titleView setTitle:@"连接中..."];
            [_titleView startAnimating];
            break;
        case TNet_Status_Disconnect:
            [_titleView setTitle:@"NTEX(未连接)"];
            [_titleView stopAnimating];
            break;
        case TNet_Status_ConnFailed:
            [_titleView setTitle:@"NTEX(未连接)"];
            [_titleView stopAnimating];
            break;
            
        default:
            break;
    }
}


/**
 *在消息列表内，点击了某一具体会话后的响应函数
 */
- (void)conversationListController:(TUIConversationListController *)conversationController didSelectConversation:(TUIConversationCell *)conversation
{
    ChatWithViewController *chat = [[ChatWithViewController alloc] init];
    chat.conversationData = conversation.convData;
    [self.navigationController pushViewController:chat animated:YES];
    
//    TIMConversation *conv = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:@"abc"];
//    TUIChatController *vc = [[TUIChatController alloc] initWithConversation:conv];
//    [self.navigationController pushViewController:vc animated:YES];
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
