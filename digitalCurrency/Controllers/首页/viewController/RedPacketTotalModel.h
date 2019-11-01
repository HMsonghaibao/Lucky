//
//  RedPacketTotalModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/20.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketTotalModel : BaseModel
@property (nonatomic, strong) NSNumber *unGetTotalMoney;
@property (nonatomic, strong) NSNumber *getTotalMoney;
@property (nonatomic, strong) NSNumber *usdtTotal;
@property (nonatomic, strong) NSNumber *cnyTotal;
@property (nonatomic, copy) NSString *coinId;

@end

NS_ASSUME_NONNULL_END
