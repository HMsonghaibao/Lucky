//
//  ParterMessageModel.h
//  digitalCurrency
//
//  Created by mac on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParterMessageModel : NSObject
@property(nonatomic,copy)NSString *nameTo;
@property(nonatomic,copy)NSString *orderId;
@property(nonatomic,copy)NSString *uidFrom;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *sendTime;
@property(nonatomic,copy)NSString *sendTimeStr;
@property(nonatomic,copy)NSString *uidTo;
@property(nonatomic,copy)NSString *nameFrom;
@property(nonatomic,copy)NSString *messageType;
@property(nonatomic,copy)NSString *fromAvatar;
@property(nonatomic,copy)NSString *isRead;
@property(nonatomic,copy)NSString *msgId;
@end
