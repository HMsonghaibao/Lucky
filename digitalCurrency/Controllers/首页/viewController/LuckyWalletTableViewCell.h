//
//  RedPacketTableViewCell.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "walletModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LuckyWalletTableViewCell : UITableViewCell

- (void)refreshUI:(walletModel *)model;

@end

NS_ASSUME_NONNULL_END
