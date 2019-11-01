//
//  AccountSettingTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "NicknameSettingTableViewCell.h"
#import "ChangePhoneDetailViewController.h"
@implementation NicknameSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftLabel.font = [UIFont systemFontOfSize:16 * kWindowWHOne];
    self.rightLabel.font = [UIFont systemFontOfSize:16 * kWindowWHOne];
    
    self.changeBtn.layer.borderWidth = 1;
    self.changeBtn.layer.borderColor = RGB(0, 35, 211).CGColor;
    self.changeBtn.layer.cornerRadius = 11.5;
    self.changeBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)changeBtnClick:(UIButton *)sender {
    ChangePhoneDetailViewController *record = [[ChangePhoneDetailViewController alloc] init];
    record.phoneNum = [YLUserInfo shareUserInfo].mobile;
    [[AppDelegate sharedAppDelegate] pushViewController:record];
}

@end
