//
//  TeamPersonTableViewCell.m
//  digitalCurrency
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "TeamPersonTableViewCell.h"

@implementation TeamPersonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-30, 175);
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBACOLOR(171, 193, 222, 1) CGColor], (id)[RGBACOLOR(59, 75, 102, 1) CGColor],nil];
    gradient.startPoint = CGPointMake(1, 1);
    gradient.endPoint = CGPointMake(0, 0);
    [self.backView.layer insertSublayer:gradient atIndex:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
