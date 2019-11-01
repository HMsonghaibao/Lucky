//
//  MineScorllView.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/18.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "MineScorllView.h"
@interface MineScorllView()
@property (weak, nonatomic) IBOutlet UIImageView *backImageV;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel3;

@end

@implementation MineScorllView

- (void)layoutSubviews{
    [super layoutSubviews];
    self.width = SCREEN_WIDTH_S-20;
    self.height = (SCREEN_WIDTH_S-20)*164/314;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
