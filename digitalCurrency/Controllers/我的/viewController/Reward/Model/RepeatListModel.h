//
//  RepeatListModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RepeatListModel : BaseModel
@property (nonatomic, strong) NSNumber *repeatID;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSNumber *investMoney;
@property (nonatomic, strong) NSNumber *rewardMoney;
@end

NS_ASSUME_NONNULL_END
