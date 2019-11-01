//
//  RedPacketModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/9/19.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RedPacketModel : BaseModel
@property (nonatomic, strong) NSNumber *amount;
@property (nonatomic, strong) NSNumber *status;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *memberId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *redDate;
@property (nonatomic, copy) NSString *getTime;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *frozenBalance;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *remark;
@end

NS_ASSUME_NONNULL_END
