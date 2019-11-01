//
//  DemandbalanceController.m
//  digitalCurrency
//
//  Created by Apple on 2019/9/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "DemandbalanceController.h"
#import "TibitipView.h"
#import "ChongzhijitipView.h"
@interface DemandbalanceController ()
@property (nonatomic, strong) TibitipView *TibitipView;
@property (nonatomic, strong) ChongzhijitipView *ChongzhijitipView;
@property (nonatomic, strong) UIView *maskTheView;
@end

@implementation DemandbalanceController

/**
 *  遮盖
 */

- (UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.8];
    }
    return _maskTheView;
    
}


-(TibitipView*)TibitipView{
    
    if (!_TibitipView) {
        _TibitipView=[TibitipView loadTibitipView:^(NSInteger aa) {
            if (aa==1) {
                [self maskClickGesture];
            }else{
                [self maskClickGesture];
            }
        }];
//        _versonTipView.layer.cornerRadius=5;
//        _versonTipView.layer.masksToBounds=YES;
        
    }
    return _TibitipView;
}

-(ChongzhijitipView*)ChongzhijitipView{
    
    if (!_ChongzhijitipView) {
        _ChongzhijitipView=[ChongzhijitipView loadChongzhijitipView:^(NSInteger aa) {
            if (aa==1) {
                [self maskClickGesture];
            }else{
                [self maskClickGesture];
            }
        }];
//        _ChongzhijitipView.layer.cornerRadius=5;
//        _ChongzhijitipView.layer.masksToBounds=YES;
        
    }
    return _ChongzhijitipView;
}

- (void)maskClickGesture{
    [self.maskTheView removeFromSuperview];
    [self.TibitipView removeFromSuperview];
    [self.ChongzhijitipView removeFromSuperview];
    self.maskTheView=nil;
    self.TibitipView=nil;
    self.ChongzhijitipView=nil;
}

- (IBAction)chongzhiBtnClick:(UIButton *)sender {
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskTheView];
    [window addSubview:self.ChongzhijitipView];
    self.ChongzhijitipView.frame=CGRectMake((Screen_Width-327)/2, Screen_Height/2-250/2-10, 327, 250);
}
- (IBAction)tixianBtnClick:(UIButton *)sender {
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskTheView];
    [window addSubview:self.TibitipView];
    self.TibitipView.frame=CGRectMake((Screen_Width-327)/2, Screen_Height/2-250/2-10, 327, 250);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"活期余额";
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
