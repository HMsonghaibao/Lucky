//
//  MyincomeListTableCell.m
//  digitalCurrency
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "MyincomeListTableCell.h"

@implementation MyincomeListTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)leftBtnClick:(UIButton *)sender {
    if (self.MyincomeListBlock) {
        self.MyincomeListBlock(0);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
