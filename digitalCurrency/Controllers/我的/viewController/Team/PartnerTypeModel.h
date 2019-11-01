//
//  PartnerTypeModel.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PartnerTypeModel : BaseModel

@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *content;

@end

NS_ASSUME_NONNULL_END
