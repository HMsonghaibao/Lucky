//
//  HZBannerTableViewCell.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/18.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "HZBannerTableViewCell.h"

@interface HZBannerTableViewCell()

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

@implementation HZBannerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(HZBannerModel *)model{
    
    _model = model;
    _backImageV.image = [UIImage imageNamed:model.picture];
//    _textLabel.text = model.title;
    _typeNameLabel.text = model.typeName;
    _amountLabel.text = [NSString stringWithFormat:@"￥%@",model.amount];
}


@end
