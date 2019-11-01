//
//  NFVersonTipView.m
//  NiuFa
//
//  Created by 宋海保 on 2018/6/20.
//  Copyright © 2018年 胡小龙. All rights reserved.
//

#import "TibitipView.h"

@implementation TibitipView

+(instancetype)loadTibitipView:(versonTipViewBlock)loadTibitipView{
    TibitipView*versonTipView=[[NSBundle mainBundle] loadNibNamed:@"TibitipView" owner:nil options:nil].lastObject;
    versonTipView.versonTipViewBlock=loadTibitipView;
    return versonTipView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.layer.borderWidth = 1;
    self.backView.layer.cornerRadius = 2;
    self.backView.layer.borderColor = [RGB(61, 82, 107) CGColor];
}


- (IBAction)cancelBtnClick:(UIButton *)sender {
    self.versonTipViewBlock(1);
}

- (IBAction)doneBtnClick:(UIButton *)sender {
    self.versonTipViewBlock(2);
}

@end
