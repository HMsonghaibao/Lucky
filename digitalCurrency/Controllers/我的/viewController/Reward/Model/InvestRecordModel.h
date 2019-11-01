//
//  InvestRecordModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecListModel : BaseModel

@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSNumber *investMoney;
@property (nonatomic, strong) NSNumber *memberId;

@end

@interface InvestRecordModel : BaseModel

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *finishTime;
@property (nonatomic, strong) NSNumber *investMoney;
@property (nonatomic, strong) NSNumber *roundId;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, strong) NSArray<NSDictionary *> *recList;
+ (instancetype)modelWithDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
