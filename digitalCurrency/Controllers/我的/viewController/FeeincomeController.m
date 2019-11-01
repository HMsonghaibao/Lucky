//
//  FeeincomeController.m
//  digitalCurrency
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "FeeincomeController.h"
#import "FeeincomeChildController.h"
#import "SLSegmentComeView.h"
@interface FeeincomeController ()<UIScrollViewDelegate>

@property (nonatomic, strong)SLSegmentComeView *segment;
@property (nonatomic, strong)UIScrollView *ctrlContanier;/**<控制器容器*/
@property(nonatomic,strong) NSArray*segmentTitleArray;
@end

@implementation FeeincomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = mainColor;
    self.segmentTitleArray= @[LocalizationKey(@"direct"),LocalizationKey(@"Partnerincome"),LocalizationKey(@"indirect")];
    [self setUpViews];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationItem.title = LocalizationKey(@"Feeincome");
    //language
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageSetting)name:LanguageChange object:nil];
    //    self.navigationController.navigationBar.translucent = NO;
}
//MARK:--国际化通知处理事件
- (void)languageSetting{
    [self.segment modifyButtonTitle:LocalizationKey(@"collect")];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![YLUserInfo isLogIn]) {
        CGFloat width = self.ctrlContanier.frame.size.width;
        CGFloat offsetX = self.ctrlContanier.contentOffset.x;
        //当前位置需要显示的控制器的索引
        NSInteger index = offsetX / width;
        if (index==3) {
            [self.segment movieToCurrentSelectedSegment:0];
            self.ctrlContanier.mj_offsetX=0;
            [self scrollViewDidEndScrollingAnimation:self.ctrlContanier];
            return;
        }
    }
    [self scrollViewDidEndScrollingAnimation:self.ctrlContanier];
    //只有这个方法中拿到了ctrlContanier的frame后才能去设置当前的控制器
}


-(void)setUpViews
{
    [self.view addSubview:self.segment];
    [self.view addSubview:self.ctrlContanier];
    [self createChildCtrls];
}
- (void)createChildCtrls
{
    //添加子控制器
    for (int i=0; i<self.segmentTitleArray.count; i++) {
        FeeincomeChildController *childCtrl = [[FeeincomeChildController alloc] initWithChildViewType:i];
        [self addChildViewController:childCtrl];
    }
    self.ctrlContanier.contentSize = CGSizeMake(self.childViewControllers.count*kWindowW, 0);
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
    FeeincomeChildController *willShowVC = self.childViewControllers[index];
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
            CGPoint offset = weakSelf.ctrlContanier.contentOffset;
            offset.x = index * weakSelf.ctrlContanier.frame.size.width;
            [weakSelf.ctrlContanier setContentOffset:offset animated:YES];
        };
    }
    return _segment;
}
-(UIScrollView *)ctrlContanier
{
    if (!_ctrlContanier) {
        _ctrlContanier = [[UIScrollView alloc] init];
        _ctrlContanier.backgroundColor = [UIColor blackColor];
        _ctrlContanier.frame=CGRectMake(0, CGRectGetMaxY(_segment.frame), kWindowW, kWindowH - NEW_NavHeight -SafeAreaBottomHeight - 40);
        _ctrlContanier.scrollsToTop = NO;
        _ctrlContanier.showsVerticalScrollIndicator = NO;
        _ctrlContanier.showsHorizontalScrollIndicator = NO;
        _ctrlContanier.pagingEnabled = YES;
        _ctrlContanier.delegate = self;
    }
    
    return _ctrlContanier;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    //    self.navigationController.navigationBar.translucent = YES;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
