//
//  PartnerDetailViewController.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PartnerDetailViewController : BaseViewController
@property (nonatomic, assign) NSInteger applyType;
@property(nonatomic,copy)NSString *uidFrom;
@property(nonatomic,copy)NSString *nameFrom;
@end

NS_ASSUME_NONNULL_END
