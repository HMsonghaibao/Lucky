//
//  InvestRewardModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvestRewardModel : BaseModel
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, strong) NSNumber *investMoney;
@property (nonatomic, strong) NSNumber *memberId;
@property (nonatomic, strong) NSNumber *rewardMoney;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
