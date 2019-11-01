//
//  RewardRecordTeamCell.h
//  digitalCurrency
//
//  Created by 宋海保 on 2019/8/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestRewardModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RewardRecordTeamCell : UITableViewCell
- (void)refreshUI:(InvestRewardModel *)model;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *rewardL;
@property (weak, nonatomic) IBOutlet UILabel *rewardnumL;
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *typeDescL;

@end

NS_ASSUME_NONNULL_END
