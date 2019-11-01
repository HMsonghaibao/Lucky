//
//  NoticeTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/7/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "EcologyTableViewCell.h"
#import "HelpeCenterViewController.h"
#import "NoticeCenterViewController.h"
#import "DemandbalanceController.h"
#import "OrdinaryTeamViewController.h"
@implementation EcologyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.transactionlabel.font = self.helplebel.font  = self.noticelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16 * kWindowWHOne];
//     self.safelabel.font = self.problemlabel.font  = self.noticecontentlabel.font = [UIFont systemFontOfSize:12 * kWindowWHOne];
  
    
    self.transactionview.userInteractionEnabled = YES;
    self.helpView.userInteractionEnabled = YES;
    self.Noticeview.userInteractionEnabled = YES;
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-30, 175);
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBACOLOR(255, 211, 158, 1) CGColor], (id)[RGBACOLOR(165, 104, 38, 1) CGColor],nil];
    gradient.startPoint = CGPointMake(1, 1);
    gradient.endPoint = CGPointMake(0, 0);
    [self.helpView.layer insertSublayer:gradient atIndex:0];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(transactionaction)];
    [self.transactionview addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(helpaction)];
    [self.helpView addGestureRecognizer:tap3];
    
    UITapGestureRecognizer *tap5 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(noticeaction)];
    [self.Noticeview addGestureRecognizer:tap5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//法币交易
-(void)transactionaction{
    DemandbalanceController *help = [[DemandbalanceController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:help];
}

//帮助中心
-(void)helpaction{
    OrdinaryTeamViewController *help = [[OrdinaryTeamViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:help];
}

//公告中心
-(void)noticeaction{
    OrdinaryTeamViewController *help = [[OrdinaryTeamViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:help];
}

@end
