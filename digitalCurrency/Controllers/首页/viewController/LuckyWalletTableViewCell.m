//
//  RedPacketTableViewCell.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "LuckyWalletTableViewCell.h"

@interface LuckyWalletTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameL;


@end

@implementation LuckyWalletTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI:(walletModel *)model{
    self.dateLabel.text = model.cnyBalance;
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f",[model.balance doubleValue]];
    self.nameL.text = model.unit;
}

@end
