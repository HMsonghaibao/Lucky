//
//  RewardListTableViewCell.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "RewardListTableViewCell.h"

@interface RewardListTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeCountLabel;

@end

@implementation RewardListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.finishTimeLabel.text = LocalizationKey(@"SettlementTime");
    self.incomeCountLabel.text = LocalizationKey(@"QuantityOfRevenue");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI:(RepeatListModel *)model{
    self.timeLabel.text = [model.createTime substringToIndex:10];
    self.amountLabel.text = [NSString stringWithFormat:@"%@%@",model.rewardMoney,model.unit];
}

@end
