//
//  investModel.h
//  LUCKY
//
//  Created by Apple on 2019/10/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface investModel : NSObject
@property (nonatomic, copy) NSString *inUnit;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *isShow;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *referrerRatio;
@property (nonatomic, copy) NSString *staticRatio;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *releaseUnit;
@property (nonatomic, copy) NSString *leverRatio;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *createTime;
@end

NS_ASSUME_NONNULL_END
