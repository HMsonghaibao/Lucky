//
//  InvitePartnerViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/21.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvitePartnerViewController.h"
#import "PartnerDetailViewController.h"
#import "MineNetManager.h"

@interface InvitePartnerViewController ()

@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UIButton *itemButton2;
@property (weak, nonatomic) IBOutlet UIButton *comfirmButton;


@property (nonatomic, strong) UIButton *currentBtn;

@property (nonatomic, assign) NSInteger applyType;

@end

@implementation InvitePartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = LocalizationKey(@"Inviteapartner");
    self.currentBtn = self.itemButton;
    self.currentBtn.selected = YES;
    self.applyType = 1;
    
    self.titleLabel1.text = LocalizationKey(@"Inviteecall");
    self.inputTF.placeholder = LocalizationKey(@"InvitePlacehodler");
    self.titleLabel2.text = LocalizationKey(@"Choiceisinvitedtobecome");
    [self.itemButton setTitle:LocalizationKey(@"BusinessPartner") forState:UIControlStateNormal];
    [self.itemButton2 setTitle:LocalizationKey(@"ProjectPartner") forState:UIControlStateNormal];
    [self.comfirmButton setTitle:LocalizationKey(@"Confirminvitation") forState:UIControlStateNormal];
}

- (IBAction)selectdTypeAction:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    NSInteger itemTag = sender.tag-2010;
    NSLog(@"itemTag: %ld",(long)itemTag);
    sender.selected = YES;
    self.currentBtn.selected = NO;
    self.currentBtn = sender;
    self.applyType = itemTag+1;
}

- (IBAction)comfirmAction:(UIButton *)sender {
    
    NSString *phone = self.inputTF.text;
    if (phone.length == 0) {
        
        return;
    }

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:@(self.applyType) forKey:@"applyType"];
    [params setObject:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    [MineNetManager invitationTurnParter:params CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
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
