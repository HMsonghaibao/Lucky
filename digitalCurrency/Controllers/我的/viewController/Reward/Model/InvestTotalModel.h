//
//  InvestTotalModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface InvestTotalModel : BaseModel
@property (nonatomic, strong) NSNumber *freeMoney;
@property (nonatomic, strong) NSNumber *usdtTotal;
@property (nonatomic, strong) NSNumber *cnyTotal;
@property (nonatomic, strong) NSNumber *inviteRewardMoney;
@property (nonatomic, strong) NSNumber *unlockMoney;
@property (nonatomic, strong) NSNumber *lockMoney;
@end

NS_ASSUME_NONNULL_END
