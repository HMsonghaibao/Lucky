//
//  AccountSettingInfoModel.h
//  digitalCurrency
//
//  Created by iDog on 2018/2/27.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountSettingInfoModel : NSObject

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *email;
@property(nonatomic,copy)NSString *emailVerified;
@property(nonatomic,copy)NSString *fundsVerified;
@property(nonatomic,copy)NSString *ID;
@property(nonatomic,copy)NSString *idCard;
@property(nonatomic,copy)NSString *loginVerified;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *phoneVerified;
@property(nonatomic,copy)NSString *realAuditing;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *realVerified;
@property(nonatomic,copy)NSString *transactions;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *avatar;
@property(nonatomic,copy)NSString *realNameRejectReason;
@property(nonatomic,copy)NSString *accountVerified;
@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *jyPwd;
@property(nonatomic,copy)NSString *jyStatus;
@property(nonatomic,copy)NSString *starLevel;
@property(nonatomic,copy)NSString *noteLevel;
@end
