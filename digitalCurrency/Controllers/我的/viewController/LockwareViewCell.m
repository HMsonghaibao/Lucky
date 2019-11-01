//
//  LockwareViewCell.m
//  digitalCurrency
//
//  Created by mac on 2019/5/14.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "LockwareViewCell.h"

@implementation LockwareViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bkgView.layer.cornerRadius=5;
    self.bkgView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.bkgView.layer.shadowOffset=CGSizeMake(0, 0);
    self.bkgView.layer.shadowOpacity=0.1;
    self.bkgView.layer.shadowRadius=2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
