//
//  RewardRecordTableViewCell.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestRewardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RewardRecordTableViewCell : UITableViewCell
- (void)refreshUI:(InvestRewardModel *)model;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageV;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *investAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *myAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *investLabel;
@property (weak, nonatomic) IBOutlet UILabel *myIncomeLabel;
@end

NS_ASSUME_NONNULL_END
