//
//  InvestRecordTableViewCell.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvestRecordTableViewCell.h"

@interface InvestRecordTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *investLabel;

@end

@implementation InvestRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.investLabel.text = LocalizationKey(@"investmentAmount");

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshUI:(NSDictionary *)model{
   
//    NSDictionary *dic = model;
    if (model[@"avatar"]) {
        [_avatarImageV sd_setImageWithURL:[NSURL URLWithString:model[@"avatar"]] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    }
    _nickLabel.text = model[@"userName"];
    _timeLabel.text = model[@"createTime"];
    if ([model[@"investMoney"] doubleValue] > 0) {
        _amountLabel.text = [NSString stringWithFormat:@"%@ %@",model[@"investMoney"],model[@"unit"]];
    }else{
        _amountLabel.text = [NSString stringWithFormat:@"0 %@",model[@"unit"]];
    }
}

@end
