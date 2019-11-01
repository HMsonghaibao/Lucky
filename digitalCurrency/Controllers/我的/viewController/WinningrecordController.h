//
//  WinningrecordController.h
//  digitalCurrency
//
//  Created by mac on 2019/6/14.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WinningrecordController : UIViewController
typedef enum : NSUInteger {
    ChildViewType_Record=0,
    ChildViewType_Parter
} ChildViewType;
- (instancetype)initWithChildViewType:(ChildViewType)childViewType;
@end
