//
//  SetNickNameViewController.m
//  LUCKY
//
//  Created by Apple on 2019/10/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "SetNickNameViewController.h"
#import "MineNetManager.h"
@interface SetNickNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nickTF;

@end

@implementation SetNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.nickTF.text = self.nickName;
}

- (IBAction)saveBtnClick:(UIButton *)sender {
    
    if ([NSString stringIsNull:self.nickTF.text]) {
        [self.view makeToast:LocalizationKey(@"Pleaseenteranickname") duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:self.nickTF.text forKey:@"nickName"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager recommendedrewardParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (self.SetNickNameBlock) {
                    self.SetNickNameBlock(self.nickTF.text);
                }
                [self.navigationController popViewControllerAnimated:YES];
                
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
