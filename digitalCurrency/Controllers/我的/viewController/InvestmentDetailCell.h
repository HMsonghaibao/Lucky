//
//  InvestmentDetailCell.h
//  digitalCurrency
//
//  Created by mac on 2019/7/25.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestmentDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *invL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;

@end
