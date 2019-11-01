//
//  MyRedPacketViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "MyLuckyExchangeViewController.h"
#import "MineNetManager.h"
#import "RedPacketModel.h"
#import "RedPacketTableViewCell.h"
#import "RedPacketTotalModel.h"

@interface MyLuckyExchangeViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerViewHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *myredLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dailingLabel;
@property (weak, nonatomic) IBOutlet UILabel *yilingLabel;
@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UIView *tfView;
@property (weak, nonatomic) IBOutlet UILabel *huilvL;
@property (weak, nonatomic) IBOutlet UITextField *numTF;
@property (weak, nonatomic) IBOutlet UILabel *numL;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, copy) NSString *huilv;

@end

@implementation MyLuckyExchangeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = LocalizationKey(@"exchangettt");
    
//    self.countView.layer.borderWidth = 1;
//    self.countView.layer.borderColor = RGB(238, 238, 238).CGColor;
//    self.countView.layer.cornerRadius = 5;
//    self.countView.layer.masksToBounds = YES;
//
//    self.tfView.layer.borderWidth = 1;
//    self.tfView.layer.borderColor = RGB(204, 204, 204).CGColor;
//    self.tfView.layer.cornerRadius = 5;
//    self.tfView.layer.masksToBounds = YES;
    self.numTF.delegate = self;
    [self requesthuilvToTal];
    self.myredLabel.text = [NSString stringWithFormat:@"%.2f",self.total.doubleValue];
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.numL.text = [NSString stringWithFormat:@"%.2f",self.numTF.text.floatValue/self.huilv.floatValue];
    
}


- (void)requesthuilvToTal{
    
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:@"USDT" forKey:@"unit"];
    [MineNetManager getInvestRewardTotal:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.huilv = resPonseObj[@"data"];
                self.huilvL.text = [NSString stringWithFormat:@"1USDT=%@TV",resPonseObj[@"data"]];
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


- (IBAction)exchangeBtnClick:(UIButton *)sender {
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:self.numTF.text forKey:@"amount"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [MineNetManager getInvestRuleInfo:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"status"] integerValue]==0) {
                //获取数据成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }else if ([resPonseObj[@"status"] integerValue] == 3000 ||[resPonseObj[@"status"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
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
