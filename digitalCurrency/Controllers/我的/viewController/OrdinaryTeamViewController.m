//
//  OrdinaryTeamViewController.m
//  digitalCurrency
//
//  Created by mac on 2019/7/23.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "OrdinaryTeamViewController.h"
#import "TeamPersonChildController.h"
#import "SLSegmentComeView.h"
#import "MineNetManager.h"
@interface OrdinaryTeamViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;/**<控制器容器*/
@property (weak, nonatomic) IBOutlet UIView *bkgView;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@property (weak, nonatomic) IBOutlet UILabel *directL;
@property (weak, nonatomic) IBOutlet UILabel *direct;
@property (weak, nonatomic) IBOutlet UILabel *realL;
@property (weak, nonatomic) IBOutlet UILabel *real;
@property (nonatomic, strong)SLSegmentComeView *segment;
@property(nonatomic,strong) NSArray*segmentTitleArray;
@end

@implementation OrdinaryTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"HTC挖矿";
//    self.numL.text = @"持有中";
//    self.directL.text = @"已回款";
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-30, 175);
    gradient.colors = [NSArray arrayWithObjects:(id)[RGBACOLOR(255, 211, 158, 1) CGColor], (id)[RGBACOLOR(165, 104, 38, 1) CGColor],nil];
    gradient.startPoint = CGPointMake(1, 1);
    gradient.endPoint = CGPointMake(0, 0);
    [self.backView.layer insertSublayer:gradient atIndex:0];
    
//    [self getTotalData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString*directCount=@"持有中";
    NSString*indirectCount=@"已回款";
    self.segmentTitleArray= @[directCount,indirectCount];
    [self setUpViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//MARK:--获取数据
-(void)getTotalData{
//    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryGeneralRecommandTotalParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.totalL.text = [NSString stringWithFormat:@"%@",resPonseObj[@"data"][@"total"]];
                self.direct.text = [NSString stringWithFormat:@"%@(%@)",resPonseObj[@"data"][@"realCount"],LocalizationKey(@"NumberCount")];
                self.real.text = [NSString stringWithFormat:@"%@(%@)",resPonseObj[@"data"][@"noRealCount"],LocalizationKey(@"NumberCount")];
                NSString*directCount=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"directttt"),resPonseObj[@"data"][@"directCount"]];
                NSString*indirectCount=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"indirectttt"),resPonseObj[@"data"][@"indirectCount"]];
                NSString*otherCount=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"other"),resPonseObj[@"data"][@"otherCount"]];
                self.segmentTitleArray= @[directCount,indirectCount,otherCount];
                [self.segment removeFromSuperview];
                self.segment = nil;
                [self setUpViews];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![YLUserInfo isLogIn]) {
        CGFloat width = self.scrollView.frame.size.width;
        CGFloat offsetX = self.scrollView.contentOffset.x;
        //当前位置需要显示的控制器的索引
        NSInteger index = offsetX / width;
        if (index==2) {
            [self.segment movieToCurrentSelectedSegment:0];
            self.scrollView.mj_offsetX=0;
            [self scrollViewDidEndScrollingAnimation:self.scrollView];
            return;
        }
    }
    [self scrollViewDidEndScrollingAnimation:self.scrollView];
    //只有这个方法中拿到了ctrlContanier的frame后才能去设置当前的控制器
}

-(void)setUpViews
{
    [self.bkgView addSubview:self.segment];
    [self createChildCtrls];
}
- (void)createChildCtrls
{
    //添加子控制器
    for (int i=0; i<self.segmentTitleArray.count; i++) {
        TeamPersonChildController *childCtrl = [[TeamPersonChildController alloc] initWithChildViewType:i];
        [self addChildViewController:childCtrl];
    }
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count*kWindowW, 0);
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    //设置optionalNewsSegment滚动到控制器对应的位置
    [self.segment movieToCurrentSelectedSegment:index];
    if (index<0)
        return;
    // 取出需要显示的控制器
    TeamPersonChildController *willShowVC = self.childViewControllers[index];
    // 如果当前位置已经显示过了，就直接返回
    if ([willShowVC isViewLoaded]){
        [willShowVC reloadData];//刷新数据
        return;
    }
    // 添加控制器的view到scrollView中;
    willShowVC.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVC.view];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark - 懒加载
- (SLSegmentComeView *)segment
{
    if (!_segment) {
        _segment = [[SLSegmentComeView alloc] initWithSegmentWithTitleArray:self.segmentTitleArray];
        _segment.frame=CGRectMake(40,0, kWindowW-80, 40);
        __weak typeof(self)weakSelf = self;
        _segment.clickSegmentButton = ^(NSInteger index) {
            //点击segment回调,让底部的内容scrollView滚动到对应位置
            CGPoint offset = weakSelf.scrollView.contentOffset;
            offset.x = index * weakSelf.scrollView.frame.size.width;
            [weakSelf.scrollView setContentOffset:offset animated:YES];
        };
    }
    return _segment;
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
