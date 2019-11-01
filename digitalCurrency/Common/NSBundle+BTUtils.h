//
//  NSBundle+BTUtils.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/30.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSBundle (BTUtils)

+ (BOOL)isChineseLanguage;

+ (NSString *)currentLanguage;

@end

NS_ASSUME_NONNULL_END
