//
//  SetNickNameViewController.h
//  LUCKY
//
//  Created by Apple on 2019/10/12.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^SetNickNameBlock)(NSString*);
@interface SetNickNameViewController : UIViewController
@property(nonatomic,copy)SetNickNameBlock SetNickNameBlock;
@property(nonatomic,copy)NSString*nickName;
@end

NS_ASSUME_NONNULL_END
