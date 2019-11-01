//
//  PartnerDetailViewController.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseViewController.h"
#import "investModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface InvestmentSubViewController : UIViewController
typedef enum : NSUInteger {
    ChildViewType_150=0,
    ChildViewType_1500,
    ChildViewType_5000,
    ChildViewType_10000
} ChildInvestViewType;
@property(nonatomic,strong)investModel*model;
- (instancetype)initWithChildViewType:(ChildInvestViewType)childViewType;
@end

NS_ASSUME_NONNULL_END
