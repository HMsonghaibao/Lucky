//
//  LotteryListCell.h
//  digitalCurrency
//
//  Created by mac on 2019/6/15.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotteryListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *leverL;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *numberL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerConstraint;

@end
