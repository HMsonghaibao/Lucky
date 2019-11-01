//
//  MiningmachineController.m
//  digitalCurrency
//
//  Created by Apple on 2019/9/17.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "MiningmachineController.h"
#import "KuangjitipView.h"
@interface MiningmachineController ()
@property (nonatomic, strong) KuangjitipView *KuangjitipView;
@property (nonatomic, strong) UIView *maskTheView;
@end

@implementation MiningmachineController

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


-(KuangjitipView*)KuangjitipView{
    
    if (!_KuangjitipView) {
        _KuangjitipView=[KuangjitipView loadKuangjitipView:^(NSInteger aa) {
            if (aa==1) {
                [self maskClickGesture];
            }else{
                [self maskClickGesture];
            }
        }];
//        _KuangjitipView.layer.cornerRadius=5;
//        _KuangjitipView.layer.masksToBounds=YES;
        
    }
    return _KuangjitipView;
}

- (void)maskClickGesture{
    [self.maskTheView removeFromSuperview];
    [self.KuangjitipView removeFromSuperview];
    self.maskTheView=nil;
    self.KuangjitipView=nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"30天矿机";
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-30, 175);
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBACOLOR(171, 193, 222, 1) CGColor], (id)[RGBACOLOR(59, 75, 102, 1) CGColor],nil];
    gradient.startPoint = CGPointMake(1, 1);
    gradient.endPoint = CGPointMake(0, 0);
    [self.backView.layer insertSublayer:gradient atIndex:0];
}
- (IBAction)buyBtnClick:(UIButton *)sender {
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskTheView];
    [window addSubview:self.KuangjitipView];
    self.KuangjitipView.frame=CGRectMake((Screen_Width-327)/2, Screen_Height/2-250/2-10, 327, 250);
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
