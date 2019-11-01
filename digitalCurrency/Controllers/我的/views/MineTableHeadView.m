//
//  MineTableHeadView.m
//  ATC
//
//  Created by iDog on 2018/6/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MineTableHeadView.h"
#import "SettingCenterViewController.h"
@implementation MineTableHeadView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    if (kWindowW==320) {
        self.setHeightConstraint.constant = 30;
    }else if (kWindowW==375){
        if (kWindowH==812) {
            self.setHeightConstraint.constant = 44;
        }else{
            self.setHeightConstraint.constant = 30;
        }
    }else if (kWindowW==414){
        if (kWindowH==896) {
            self.setHeightConstraint.constant = 44;
        }else{
            self.setHeightConstraint.constant = 30;
        }
    }else {
        self.setHeightConstraint.constant = 44;
    }

}
-(MineTableHeadView *)instancetableHeardViewWithFrame:(CGRect)Rect
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MineTableHeadView" owner:nil options:nil];
    MineTableHeadView *tableView=[nibView objectAtIndex:0];
    tableView.frame=Rect;
    tableView.imageheight.constant = 70 * kWindowWHOne;
    tableView.headImage.layer.cornerRadius = 35 * kWindowWHOne;
    tableView.safetop.constant = kWindowH == 812.0 ? 44 : 30;
    return tableView;
}

- (IBAction)setBtnClick:(UIButton *)sender {
    //账户设置
    SettingCenterViewController *set = [[SettingCenterViewController alloc] init];
    [[AppDelegate sharedAppDelegate] pushViewController:set];
}

@end
