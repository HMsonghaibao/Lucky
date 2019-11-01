//
//  RecommendedWayController.h
//  digitalCurrency
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendedWayController : BaseViewController
typedef enum : NSUInteger {
    ChildViewType_direct=0,
    ChildViewType_indirect,
    ChildViewType_indirect1,
    ChildViewType_indirect2,
    ChildViewType_indirect3,
    ChildViewType_indirect4
} ChildViewType;
- (instancetype)initWithChildViewType:(ChildViewType)childViewType;
-(void)reloadData;//刷新数据
@end
