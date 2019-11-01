//
//  RedPacketTableViewCell.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedPacketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
- (void)refreshUI:(RedPacketModel *)model;

@end

NS_ASSUME_NONNULL_END
