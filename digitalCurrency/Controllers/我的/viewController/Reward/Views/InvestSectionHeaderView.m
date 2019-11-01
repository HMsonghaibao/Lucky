//
//  InvestSectionHeaderView.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvestSectionHeaderView.h"

@interface InvestSectionHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *stateButton;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *investLabel;

@end

@implementation InvestSectionHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.finishTimeLabel.text = LocalizationKey(@"SettlementTime");
    self.investLabel.text = LocalizationKey(@"investmentAmount");
    self.titleLabel.text = LocalizationKey(@"Inviteinvestmentrecor");
}

- (void)refreshUI:(InvestRecordModel *)model{
    if (model.selected) {
        _titleLabel.hidden = NO;
        _stateButton.selected = YES;
    }else{
        _titleLabel.hidden = YES;
        _stateButton.selected = NO;
    }
    _timeLabel.text = model.finishTime;
    
    _amountLabel.text = [NSString stringWithFormat:@"%@%@",[model.investMoney stringValue],model.unit];
}

@end
