//
//  RedPacketTableViewCell.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "LuckyTeamTableViewCell.h"

@interface LuckyTeamTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameL;


@end

@implementation LuckyTeamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI:(luckyteamModel *)model{
    self.nameL.text = [NSString stringWithFormat:@"%@",model.nickName];
    NSString*level = [NSString stringWithFormat:@"%@",model.note_level];
    if ([level isEqualToString:@"0"]) {
        self.dateLabel.text = LocalizationKey(@"generaluser");
    }else if ([level isEqualToString:@"1"]){
        self.dateLabel.text = LocalizationKey(@"Advancednode");
    }else{
        self.dateLabel.text = LocalizationKey(@"Supernode");
    }
    self.amountLabel.text = [NSString stringWithFormat:@"%.2f",model.totalPerformance.floatValue];
}

@end
