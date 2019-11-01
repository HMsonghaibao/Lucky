//
//  RedPacketTableViewCell.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "RedPacketTableViewCell.h"

@interface RedPacketTableViewCell()


@end

@implementation RedPacketTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI:(RedPacketModel *)model{
    self.dateLabel.text = [NSString stringWithFormat:@"%.2f",model.amount.doubleValue];
    self.amountLabel.text = model.remark;
    self.timeL.text = model.createTime;
}

@end
