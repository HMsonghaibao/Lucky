//
//  NFVersonTipView.h
//  NiuFa
//
//  Created by 宋海保 on 2018/6/20.
//  Copyright © 2018年 胡小龙. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^versonTipViewBlock)(NSInteger);
@interface TibitipView : UIView
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property(nonatomic,copy)versonTipViewBlock versonTipViewBlock;
+(instancetype)loadTibitipView:(versonTipViewBlock)loadTibitipView;
@end
