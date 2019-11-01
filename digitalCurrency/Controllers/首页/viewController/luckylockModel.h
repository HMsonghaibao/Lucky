//
//  luckylockModel.h
//  LUCKY
//
//  Created by Apple on 2019/10/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface luckylockModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *frozenBalance;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
