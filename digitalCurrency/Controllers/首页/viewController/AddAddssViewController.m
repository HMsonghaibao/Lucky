//
//  AddAddssViewController.m
//  digitalCurrency
//
//  Created by Apple on 2019/9/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "AddAddssViewController.h"
#import "HMScannerController.h"
#import "MentionCoinInfoModel.h"
@interface AddAddssViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UITextField *addsTf;

@end

@implementation AddAddssViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建提币地址";
    [self.nameTf setValue:[UIColor colorWithRed:61/255.0 green:82/255.0 blue:107/255.0 alpha:1/1.0] forKeyPath:@"_placeholderLabel.textColor"];
    [self.addsTf setValue:[UIColor colorWithRed:61/255.0 green:82/255.0 blue:107/255.0 alpha:1/1.0] forKeyPath:@"_placeholderLabel.textColor"];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)scrBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *cardName = @"";
    UIImage *avatar = [UIImage imageNamed:@""];
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:cardName avatar:avatar completion:^(NSString *stringValue) {
        NSString*str= [stringValue substringFromIndex:stringValue.length-9];
        self.addsTf.text = str;
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}

- (IBAction)doneBtnClick:(UIButton *)sender {
    NSMutableArray *addressInfoArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"addressInfoArr"];
    if (addressInfoArr == nil) {
        addressInfoArr = [NSMutableArray array];
    }
    NSMutableArray*arr= [addressInfoArr mutableCopy];
    NSDictionary*dict = @{@"remark":self.nameTf.text,@"address":self.addsTf.text};
    if (![arr containsObject:dict]) {
        [arr addObject:dict];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:arr forKey:@"addressInfoArr"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
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
