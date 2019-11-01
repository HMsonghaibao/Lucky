//
//  ChangePhoneDetailViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/3/19.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "LuckyTibiViewController.h"
#import "MineNetManager.h"
#import "AccountSettingViewController.h"

@interface LuckyTibiViewController ()
@property (weak, nonatomic) IBOutlet UILabel *tipLabel; //提示语
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (weak, nonatomic) IBOutlet UITextField *latestPhoneNum;
@property (weak, nonatomic) IBOutlet UITextField *loginPassword;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;//短信验证码
// 国际化需要
@property (weak, nonatomic) IBOutlet UILabel *messageCode;
@property (weak, nonatomic) IBOutlet UILabel *latestPhoneNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *coinBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *feeL;

@end

@implementation LuckyTibiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = RGBCOLOR(18, 22, 28);
//    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"changeBindPhoneNum" value:nil table:@"English"];
    self.title = LocalizationKey(@"Withdrawmoney");
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
     NSString *backStr = [self.phoneNum substringFromIndex:self.phoneNum.length- 4 ];
    self.tipLabel.text = [NSString stringWithFormat:@"%@%@%@",[[ChangeLanguage bundle] localizedStringForKey:@"handsetTailNumber" value:nil table:@"English"],backStr,[[ChangeLanguage bundle] localizedStringForKey:@"receiveMessageCode" value:nil table:@"English"]];
//    self.messageCode.text =[[ChangeLanguage bundle] localizedStringForKey:@"messageCode" value:nil table:@"English"];
//    self.latestPhoneNumLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"newPhoneNum" value:nil table:@"English"];
//    self.loginPasswordLabel.text = [[ChangeLanguage bundle] localizedStringForKey:@"loginPassword" value:nil table:@"English"];
//     [_verifyButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"getVerifyCode" value:nil table:@"English"] forState:UIControlStateNormal];
//     [self.submitButton setTitle:[[ChangeLanguage bundle] localizedStringForKey:@"changeBindPhoneNum" value:nil table:@"English"] forState:UIControlStateNormal];
//    [self.submitButton setTitle:@"提币" forState:UIControlStateNormal];

//    self.codeTextField.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputCode" value:nil table:@"English"];
//    self.latestPhoneNum.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputNewPhoneNum" value:nil table:@"English"];
//    self.loginPassword.placeholder = [[ChangeLanguage bundle] localizedStringForKey:@"inputLoginPassword" value:nil table:@"English"];
    
    [_codeTextField setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_latestPhoneNum setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    [_loginPassword setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    
    // Do any additional setup after loading the view from its nib.
    [self requestData];
}


- (void)requestData{
    //    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:@"LKC" forKey:@"unit"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [MineNetManager getLotteryRule:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.numL.text = [NSString stringWithFormat:@"%@: %.2fLKC",LocalizationKey(@"Availablequantity"),[resPonseObj[@"data"][@"balance"] doubleValue]];
                self.feeL.text = [NSString stringWithFormat:@"%@: %.1f%%",LocalizationKey(@"Handlingfee"),[resPonseObj[@"data"][@"ratio"] doubleValue]*100];
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


- (IBAction)eyeBtnClick:(UIButton *)sender {
    self.eyeBtn.selected = !self.eyeBtn.selected;
    self.loginPassword.secureTextEntry = !self.eyeBtn.selected;
}

//按钮的点击事件
- (IBAction)btnBlick:(UIButton *)sender {
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:self.coinBtn.titleLabel.text forKey:@"unit"];
    [bodydic setValue:self.codeTextField.text forKey:@"address"];
    [bodydic setValue:self.latestPhoneNum.text forKey:@"amount"];
    [bodydic setValue:[MD5 md5:self.loginPassword.text] forKey:@"jyPassword"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getMemberTotalRewardMoneyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"status"] integerValue]==0) {
                //获取数据成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                [self.navigationController popViewControllerAnimated:YES];
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
//MARK:--修改绑定手机号
-(void)changeBindingPhone{
   
    if ([self.codeTextField.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputMessageCode" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.latestPhoneNum.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputNewPhoneNum" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    if ([self.loginPassword.text isEqualToString:@""]) {
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"inputLoginPassword" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        return;
    }
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager changePhoneNumForPassword:self.loginPassword.text withPhone:self.latestPhoneNum.text withCode:self.codeTextField.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.0 position:CSToastPositionCenter];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    for (UIViewController *controller in self.navigationController.viewControllers) {
                        if ([controller isKindOfClass:[AccountSettingViewController class]]) {
                            AccountSettingViewController *accountVC =(AccountSettingViewController *)controller;
                            [self.navigationController popToViewController:accountVC animated:YES];
                        }
                    }
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
