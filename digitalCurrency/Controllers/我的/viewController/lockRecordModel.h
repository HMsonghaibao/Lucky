//
//  lockRecordModel.h
//  digitalCurrency
//
//  Created by mac on 2019/5/18.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lockRecordModel : NSObject
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *coinId;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *speedUp;
@property(nonatomic,copy)NSString *recordType;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,copy)NSString *isShow;
@property(nonatomic,copy)NSString *sort;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *isTop;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *language;
@end
