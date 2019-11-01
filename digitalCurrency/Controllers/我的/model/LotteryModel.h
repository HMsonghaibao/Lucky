//
//  LotteryModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/15.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LotteryModel : BaseModel
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, copy) NSString *lotteryTime;
@property (nonatomic, copy) NSString *time;
@end

NS_ASSUME_NONNULL_END
