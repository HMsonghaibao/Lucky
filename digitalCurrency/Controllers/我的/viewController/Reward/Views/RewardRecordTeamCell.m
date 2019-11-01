//
//  RewardRecordTeamCell.m
//  digitalCurrency
//
//  Created by 宋海保 on 2019/8/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "RewardRecordTeamCell.h"

@implementation RewardRecordTeamCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.rewardL.text = LocalizationKey(@"Myincomettt");
    self.typeL.text = LocalizationKey(@"type");
}

- (void)refreshUI:(InvestRewardModel *)model{
    self.timeL.text = [model.createTime substringToIndex:10];
    self.rewardnumL.text = [model.rewardMoney stringValue];
    self.typeDescL.text = model.remark;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
