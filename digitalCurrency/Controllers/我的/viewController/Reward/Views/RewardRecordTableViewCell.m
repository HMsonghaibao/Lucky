//
//  RewardRecordTableViewCell.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "RewardRecordTableViewCell.h"

@interface RewardRecordTableViewCell()

@end

@implementation RewardRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.investLabel.text = LocalizationKey(@"investmentAmount");
    self.myIncomeLabel.text = LocalizationKey(@"MyIncome");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI:(InvestRewardModel *)model{
    [self.avatarImageV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    self.nickNameLabel.text = model.userName;
    self.timeLabel.text = [model.createTime substringToIndex:10];
    self.investAmountLabel.text = [model.investMoney stringValue];
    self.myAmountLabel.text = [model.rewardMoney stringValue];
}

@end
