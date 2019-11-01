//
//  InvestRecordTableViewCell.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InvestRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvestRecordTableViewCell : UITableViewCell
- (void)refreshUI:(NSDictionary *)model;
@end

NS_ASSUME_NONNULL_END
