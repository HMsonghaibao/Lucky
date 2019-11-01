//
//  RecommendedCell.h
//  digitalCurrency
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *feeL;
@property (weak, nonatomic) IBOutlet UILabel *regL;

@end
