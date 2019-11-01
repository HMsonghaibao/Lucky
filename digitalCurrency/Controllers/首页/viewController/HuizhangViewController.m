//
//  HuizhangViewController.m
//  digitalCurrency
//
//  Created by Apple on 2019/9/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "HuizhangViewController.h"
#import "WinningrecordController.h"
@interface HuizhangViewController ()

@end

@implementation HuizhangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"会长奖励";
    
    [self rightButton];
    
    // Do any additional setup after loading the view from its nib.
}


//MARK:--自定义导航栏消息按钮
-(void)rightButton{
    UIButton * issueButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    issueButton.frame = CGRectMake(0, 0, 25, 25);
    [issueButton setTitle:@"账单" forState:0];
    [issueButton addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    //添加到导航条
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:issueButton];
    self.navigationItem.rightBarButtonItem = leftBarButtomItem;
}


-(void)RighttouchEvent{
    if(![YLUserInfo isLogIn]){
        [self showLoginViewController];
        return;
    }
    
    WinningrecordController *groupVC = [[WinningrecordController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
    
    
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
