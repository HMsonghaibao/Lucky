//
//  RewardListTableViewCell.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RepeatListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RewardListTableViewCell : UITableViewCell

- (void)refreshUI:(RepeatListModel *)model;

@end

NS_ASSUME_NONNULL_END
