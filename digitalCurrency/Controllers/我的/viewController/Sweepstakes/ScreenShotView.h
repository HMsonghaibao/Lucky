//
//  ScreenShotView.h
//  digitalCurrency
//
//  Created by mac on 2019/6/20.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ScreenShotViewBlock)(NSInteger);
@interface ScreenShotView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *friendBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic,copy)ScreenShotViewBlock ScreenShotViewBlock;
+(instancetype)loadScreenShotView:(ScreenShotViewBlock)loadScreenShotView;
@end
