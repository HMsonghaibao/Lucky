//
//  AccountSettingTableViewCell.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "PhoneSettingTableViewCell.h"
#import "SetNickNameViewController.h"
@implementation PhoneSettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.leftLabel.font = [UIFont systemFontOfSize:16 * kWindowWHOne];
    self.rightLabel.font = [UIFont systemFontOfSize:16 * kWindowWHOne];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)editBtnClick:(UIButton *)sender {
    SetNickNameViewController *record = [[SetNickNameViewController alloc] init];
    record.SetNickNameBlock = ^(NSString * namestr) {
        self.rightLabel.text = namestr;
    };
    record.title = LocalizationKey(@"Editnickname");
    record.nickName = self.rightLabel.text;
    [[AppDelegate sharedAppDelegate] pushViewController:record];
}

@end
