//
//  CustomSectionHeader.m
//  digitalCurrency
//
//  Created by sunliang on 2018/4/11.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "CustomSectionHeader.h"

@implementation CustomSectionHeader
+(CustomSectionHeader *)instancesectionHeaderViewWithFrame:(CGRect)Rect{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CustomSectionHeader" owner:nil options:nil];
    CustomSectionHeader*headerView=[nibView objectAtIndex:0];
    headerView.frame=Rect;
    return headerView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backView.layer.cornerRadius=5;
    self.backView.layer.shadowColor=RGB(51, 62, 99).CGColor;
    self.backView.layer.shadowOffset=CGSizeMake(0, 0);
    self.backView.layer.shadowOpacity=0.1;
    self.backView.layer.shadowRadius=2;
}

- (IBAction)moreaction:(id)sender {
    self.moreBlock();
}

@end
