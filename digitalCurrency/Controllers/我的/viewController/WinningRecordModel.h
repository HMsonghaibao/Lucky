//
//  WinningRecordModel.h
//  digitalCurrency
//
//  Created by mac on 2019/6/15.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WinningRecordModel : NSObject
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *rewardType;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *fromMoney;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *memberId;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *lotteryDate;
@property(nonatomic,copy)NSString *fromCount;
@property(nonatomic,copy)NSString *partnerMemberId;
@property(nonatomic,copy)NSString *coinId;
@property(nonatomic,copy)NSString *partnerMoney;
@property(nonatomic,copy)NSString *createTime;
@end
