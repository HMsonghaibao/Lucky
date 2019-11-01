//
//  FeeincomeChildController.h
//  digitalCurrency
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeeincomeChildController : BaseViewController
typedef enum : NSUInteger {
    ChildViewType_USDT=0,
    ChildViewType_BTC,
    ChildViewType_ETH
} ChildViewType;
- (instancetype)initWithChildViewType:(ChildViewType)childViewType;
-(void)reloadData;//刷新数据
@end
