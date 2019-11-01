//
//  PartnerincomeController.m
//  digitalCurrency
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "PartnerincomeController.h"
#import "RecommendedWayController.h"
#import "FSScrollContentView.h"
@interface PartnerincomeController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) UISegmentedControl *seg;
@property (nonatomic, strong) FSPageContentView * pageContentView;
@end

@implementation PartnerincomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"Partnerincome" value:nil table:@"English"];
    [self.view addSubview:self.seg];
    NSArray *titles = @[LocalizationKey(@"direct"),LocalizationKey(@"indirect")];
    NSMutableArray *contentVCs = [NSMutableArray array];
    for (NSString *title in titles) {
        if ([title isEqualToString:LocalizationKey(@"direct")]) {
            RecommendedWayController *buyVC = [[RecommendedWayController alloc] initWithChildViewType:2];
            buyVC.title = title;
            buyVC.view.backgroundColor = mainColor;
            [contentVCs addObject:buyVC];
            
        }else{
            RecommendedWayController *sellVC = [[RecommendedWayController alloc] initWithChildViewType:3];
            sellVC.title = title;
            sellVC.view.backgroundColor = mainColor;
            [contentVCs addObject:sellVC];
            
        }
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 65, kWindowW, kWindowH - SafeAreaTopHeight-65-SafeAreaBottomHeight) childVCs:contentVCs parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.seg.selectedSegmentIndex = endIndex;
    //    _tableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    //    _tableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}


- (void)handelSegementControlAction:(UISegmentedControl *)segment
{
    self.pageContentView.contentViewCurrentIndex = segment.selectedSegmentIndex;
}


- (UISegmentedControl *)seg{
    if (!_seg) {
        _seg = [[UISegmentedControl alloc] initWithItems:@[LocalizationKey(@"direct"), LocalizationKey(@"indirect")]];
        [_seg addTarget:self action:@selector(handelSegementControlAction:) forControlEvents:(UIControlEventValueChanged)];
        _seg.frame = CGRectMake(0, 0, 180, 32);
        //        _seg.center = CGPointMake(self.view.frame.size.width / 2, 26);
        _seg.center = CGPointMake(kWindowW/2, 35);
        _seg.selectedSegmentIndex = 0;
        _seg.tintColor=RGBOF(0xF0A70A);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RGBOF(0xF0A70A),NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
        NSDictionary *seldic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
        [_seg setTitleTextAttributes:dic forState:UIControlStateNormal];
        [_seg setTitleTextAttributes:seldic forState:UIControlStateSelected];
    }
    return _seg;
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
