//
//  TeamManagerViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/5/14.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "FansiManagerViewController.h"
#import "FansiBaseController.h"
#import "FSScrollContentView.h"
#import "MineNetManager.h"
@interface FansiManagerViewController () <FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) UISegmentedControl *seg;
@property (nonatomic, strong) FSPageContentView * pageContentView;
@property (nonatomic, assign)NSInteger userType;
@end

@implementation FansiManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"Teammanagement" value:nil table:@"English"];
    self.title = @"粉丝";
    [self.view addSubview:self.seg];
    NSArray *titles = @[@"普通玩家",@"有效玩家",@"VIP玩家"];
    NSMutableArray *contentVCs = [NSMutableArray array];
    for (NSString *title in titles) {
        if ([title isEqualToString:@"活期账单"]) {
            FansiBaseController *buyVC = [[FansiBaseController alloc] initWithChildViewType:1];
            buyVC.title = title;
            buyVC.view.backgroundColor = mainColor;
            [contentVCs addObject:buyVC];
            
        }else if ([title isEqualToString:@"定期账单"]) {
            FansiBaseController *buyVC = [[FansiBaseController alloc] initWithChildViewType:2];
            buyVC.title = title;
            buyVC.view.backgroundColor = mainColor;
            [contentVCs addObject:buyVC];
            
        }else{
            FansiBaseController *sellVC = [[FansiBaseController alloc] initWithChildViewType:3];
            sellVC.title = title;
            sellVC.view.backgroundColor = mainColor;
            [contentVCs addObject:sellVC];
            
        }
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 65, kWindowW, kWindowH - SafeAreaTopHeight-65-SafeAreaBottomHeight) childVCs:contentVCs parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];
    [self UILayout];
    
    
//    [self getData];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}



//MARK:--获取数据
-(void)getData{
//    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryMemberPartnerParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
//        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.userType = [resPonseObj[@"data"] integerValue];
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



- (void)UILayout{
//    [self addRightButton];
    
    
}

- (void)addRightButton
{
    UIButton * rightButtton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 16, 17)];
    [rightButtton setImage:[UIImage imageNamed:@"team-Application"] forState:UIControlStateNormal];
    [rightButtton addTarget:self action:@selector(applyPartnerAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtton];
}


#pragma mark --BtnClickMethod

- (void)applyPartnerAction{
    
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
        _seg = [[UISegmentedControl alloc] initWithItems:@[@"普通玩家",@"有效玩家",@"VIP玩家"]];
        [_seg addTarget:self action:@selector(handelSegementControlAction:) forControlEvents:(UIControlEventValueChanged)];
        _seg.frame = CGRectMake(0, 0, 345, 32);
        //        _seg.center = CGPointMake(self.view.frame.size.width / 2, 26);
        _seg.center = CGPointMake(kWindowW/2, 35);
        _seg.selectedSegmentIndex = 0;
        _seg.tintColor=[UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1/1.0];
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1/1.0],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
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
