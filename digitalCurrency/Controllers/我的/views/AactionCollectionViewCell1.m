//
//  AactionCollectionViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AactionCollectionViewCell1.h"

@implementation AactionCollectionViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bkgView.layer.cornerRadius=5;
    self.bkgView.layer.shadowColor=[UIColor blackColor].CGColor;
    self.bkgView.layer.shadowOffset=CGSizeMake(0, 0);
    self.bkgView.layer.shadowOpacity=0.1;
    self.bkgView.layer.shadowRadius=2;
}

@end
