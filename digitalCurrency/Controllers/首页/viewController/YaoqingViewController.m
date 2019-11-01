//
//  YaoqingViewController.m
//  digitalCurrency
//
//  Created by Apple on 2019/9/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "YaoqingViewController.h"
#import "HuizhangViewController.h"
#import "FansiManagerViewController.h"
#import "TieganManagerViewController.h"
#import "MyhaibaoViewController.h"
@interface YaoqingViewController ()

@end

@implementation YaoqingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的邀请";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)tieganBtnClick:(UIButton *)sender {
    TieganManagerViewController *groupVC = [[TieganManagerViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
}
- (IBAction)fansiBtnClick:(UIButton *)sender {
    FansiManagerViewController *groupVC = [[FansiManagerViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
}
- (IBAction)inviteBtnClick:(UIButton *)sender {
}
- (IBAction)haibaoBtnClick:(UIButton *)sender {
    MyhaibaoViewController *groupVC = [[MyhaibaoViewController alloc] init];
    groupVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:groupVC animated:YES];
}
- (IBAction)fuzhiBtnCLick:(UIButton *)sender {
}
- (IBAction)huizhangBtnCLick:(UIButton *)sender {
    HuizhangViewController *groupVC = [[HuizhangViewController alloc] init];
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
