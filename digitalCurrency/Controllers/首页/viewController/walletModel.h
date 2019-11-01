//
//  walletModel.h
//  LUCKY
//
//  Created by Apple on 2019/10/18.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface walletModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *isLock;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *cnyBalance;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *frozenBalance;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *balance;
@property (nonatomic, copy) NSString *usdBalance;
@end

NS_ASSUME_NONNULL_END
