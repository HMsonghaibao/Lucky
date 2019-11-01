//
//  MyassetsTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyassetsTableViewCell.h"
#import "AactionCollectionViewCell.h"
#import "MineScorllView.h"
#import "HZBannerView.h"
#import "MyincomeListController.h"
#import "LockwarehouseController.h"
#import "WalletManageViewController.h"
#import "PartnerincomeController.h"

@interface MyassetsTableViewCell()<HQFlowViewDelegate,HQFlowViewDataSource>

@end

@implementation MyassetsTableViewCell


- (NSMutableArray *)advArray
{
    if (!_advArray) {
        _advArray = [NSMutableArray arrayWithObjects:@"Purpleblock",@"Yellowblock",@"Blueblock",@"Orangeblock",@"red-mine", nil];
    }
    return _advArray;
}

- (NSMutableArray *)bannerArray
{
    if (!_bannerArray) {
        _bannerArray = [NSMutableArray array];
    }
    return _bannerArray;
}

#pragma mark -- 轮播图

- (HQFlowView *)pageFlowView
{
    if (!_pageFlowView) {
        
        _pageFlowView = [[HQFlowView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH_S, 164)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.3;
        _pageFlowView.leftRightMargin = 15;
        _pageFlowView.topBottomMargin = 20;
        _pageFlowView.orginPageCount = _advArray.count;
        _pageFlowView.isOpenAutoScroll = NO;
        _pageFlowView.isCarousel = NO;
        _pageFlowView.autoTime = 3.0;
        _pageFlowView.orientation = HQFlowViewOrientationHorizontal;
    }
    return _pageFlowView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self updatacollectionUI];
}

-(void)updatacollectionUI{
    [self.scrollView addSubview:self.pageFlowView];
//    [self.pageFlowView reloadData];//刷新轮播
}

- (void)scrollTopPage:(NSInteger)page{
    
    [self.pageFlowView scrollToPage:page];
}

#pragma mark JQFlowViewDelegate
- (CGSize)sizeForPageInFlowView:(HQFlowView *)flowView
{
//    return CGSizeMake(SCREEN_WIDTH_S-2*30, self.scrollView.frame.size.height-20);
    return CGSizeMake(SCREEN_WIDTH_S-2*15, 159);
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView{
    if (self.scrollToPage) {
        self.scrollToPage(pageNumber);
    }
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex
{
    self.selectBlock(subIndex);
}

#pragma mark JQFlowViewDatasource
- (NSInteger)numberOfPagesInFlowView:(HQFlowView *)flowView
{
    return self.advArray.count;
}
- (HQIndexBannerSubview *)flowView:(HQFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    
    HQIndexBannerSubview *bannerView = (HQIndexBannerSubview *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[HQIndexBannerSubview alloc] initWithFrame:CGRectMake(0, 0, self.pageFlowView.frame.size.width, self.pageFlowView.frame.size.height)];
        bannerView.layer.cornerRadius = 5;
        bannerView.layer.masksToBounds = YES;
        bannerView.coverView.backgroundColor = [UIColor darkGrayColor];
    }
    //在这里下载网络图片
    //    [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:self.advArray[index]] placeholderImage:nil];
    //加载本地图片
    NSLog(@"===%@",self.bannerArray);
    bannerView.mainImageView.image = [UIImage imageNamed:self.advArray[index]];
    if (self.bannerArray.count>0) {
        NSDictionary*dict= self.bannerArray[index];
        if (index == 1) {
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(%.2fUSDT)",LocalizationKey(@"Availableassets"),[dict[@"usdtTotal"] doubleValue]];
            bannerView.moneyL.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"cnyTotal"] doubleValue]];
            bannerView.coinL.text = LocalizationKey(@"currency");
            bannerView.coin.text = dict[@"unit"];
            bannerView.numL.text = LocalizationKey(@"amonut");
            bannerView.num.text = [NSString stringWithFormat:@"%.2f",[dict[@"amount"] doubleValue]];
            bannerView.cnyL.text = [NSString stringWithFormat:@"%@(CNY)",LocalizationKey(@"value")];
            bannerView.cny.text = [NSString stringWithFormat:@"%.2f",[dict[@"cny"] doubleValue]];
            bannerView.cnyL.hidden = NO;
            bannerView.cny.hidden = NO;
        }else if(index == 2){
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(%.2f%@)",LocalizationKey(@"Releaseassets"),[dict[@"usdt"] doubleValue],dict[@"coin_id"]];
            bannerView.moneyL.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"cny"] doubleValue]];
            bannerView.coinL.text = LocalizationKey(@"Totallock");
            bannerView.coin.text = [NSString stringWithFormat:@"%.2f",[dict[@"total"] doubleValue]];
            bannerView.numL.text = LocalizationKey(@"Releasetoday");
            bannerView.num.text = [NSString stringWithFormat:@"%.2f",[dict[@"today_num"] doubleValue]];
            bannerView.cnyL.text = LocalizationKey(@"Notreleased");
            bannerView.cny.text = [NSString stringWithFormat:@"%.2f",[dict[@"surplus_num"] doubleValue]];
            bannerView.cnyL.hidden = NO;
            bannerView.cny.hidden = NO;
        }else if (index == 0){
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(%.2fUSDT)",LocalizationKey(@"Myincome"),[dict[@"usdtTotal"] doubleValue]];
            bannerView.moneyL.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"cnyTotal"] doubleValue]];
            bannerView.coinL.text = [NSString stringWithFormat:@"%@(USDT)",LocalizationKey(@"Yesterdayearnings")];
            bannerView.coin.text = [NSString stringWithFormat:@"%.2f",[dict[@"yesterdayUsdtTotal"] doubleValue]];
            bannerView.numL.text = [NSString stringWithFormat:@"%@(NBTC)",LocalizationKey(@"Remainingbonus")];
            bannerView.num.text = [NSString stringWithFormat:@"%.2f",[dict[@"surplusLotteryMoney"] doubleValue]];
            bannerView.cnyL.hidden = YES;
            bannerView.cny.hidden = YES;
        }else if (index == 3){
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(%.2fUSDT)",LocalizationKey(@"recommendedReward"),[dict[@"usdtTotal"] doubleValue]];
            bannerView.moneyL.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"cnyTotal"] doubleValue]];
            bannerView.coinL.text = LocalizationKey(@"Recommendedtoday");
            bannerView.coin.text = [NSString stringWithFormat:@"%@%@",dict[@"todayCount"],LocalizationKey(@"partner")];
            bannerView.numL.text = [NSString stringWithFormat:@"%@(USDT)",LocalizationKey(@"Earnrewards")];
            bannerView.num.text = [NSString stringWithFormat:@"%.2f",[dict[@"todayUsdtTotal"] doubleValue]];
            bannerView.cnyL.hidden = YES;
            bannerView.cny.hidden = YES;
        }else{
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(%.2fUSDT)",LocalizationKey(@"Totalinvestmentincome"),[dict[@"usdtTotal"] doubleValue]];
            bannerView.moneyL.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"cnyTotal"] doubleValue]];
            bannerView.coinL.text = LocalizationKey(@"Invitationrevenue");
            bannerView.coin.text = [NSString stringWithFormat:@"%.2f",[dict[@"inviteRewardMoney"] doubleValue]];
            bannerView.numL.text = LocalizationKey(@"Cumulativerelease");
            bannerView.num.text = [NSString stringWithFormat:@"%.2f",[dict[@"freeMoney"] doubleValue]];
            bannerView.cnyL.text = LocalizationKey(@"Notreleased");
            bannerView.cny.text = [NSString stringWithFormat:@"%.2f",[dict[@"lockMoney"] doubleValue]];
            bannerView.cnyL.hidden = NO;
            bannerView.cny.hidden = NO;
        }
    }else{
        if (index == 1) {
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(0.00USDT)",LocalizationKey(@"Availableassets")];
            bannerView.moneyL.text = @"¥0.00";
            bannerView.coinL.text = LocalizationKey(@"currency");
            bannerView.coin.text = @"NBTC";
            bannerView.numL.text = LocalizationKey(@"amonut");
            bannerView.num.text = @"0.00";
            bannerView.cnyL.text = [NSString stringWithFormat:@"%@(CNY)",LocalizationKey(@"value")];
            bannerView.cny.text = @"0.00";
            bannerView.cnyL.hidden = NO;
            bannerView.cny.hidden = NO;
        }else if(index == 2){
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(0.00NBTC)",LocalizationKey(@"Releaseassets")];;
            bannerView.moneyL.text = @"¥0.00";
            bannerView.coinL.text = LocalizationKey(@"Totallock");
            bannerView.coin.text = @"0.00";
            bannerView.numL.text = LocalizationKey(@"Releasetoday");
            bannerView.num.text = @"0.00";
            bannerView.cnyL.text = LocalizationKey(@"Notreleased");
            bannerView.cny.text = @"0.00";
            bannerView.cnyL.hidden = NO;
            bannerView.cny.hidden = NO;
        }else if (index == 0){
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(0.00USDT)",LocalizationKey(@"Myincome")];
            bannerView.moneyL.text = @"¥0.00";
            bannerView.coinL.text = LocalizationKey(@"Yesterdayearnings");
            bannerView.coin.text = @"0.00NBTC";
            bannerView.numL.text = LocalizationKey(@"Remainingbonus");
            bannerView.num.text = @"0.00NBTC";;
            bannerView.cnyL.hidden = YES;
            bannerView.cny.hidden = YES;
        }else if (index == 3){
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(0.00USDT)",LocalizationKey(@"recommendedReward")];
            bannerView.moneyL.text = @"¥0.00";
            bannerView.coinL.text = LocalizationKey(@"Recommendedtoday");
            bannerView.coin.text = [NSString stringWithFormat:@"0%@",LocalizationKey(@"partner")];
            bannerView.numL.text = LocalizationKey(@"Earnrewards");
            bannerView.num.text = @"0.00USDT";
            bannerView.cnyL.hidden = YES;
            bannerView.cny.hidden = YES;
        }else{
            bannerView.titleL.text = [NSString stringWithFormat:@"%@(0.00USDT)",LocalizationKey(@"Totalinvestmentincome")];
            bannerView.moneyL.text = @"¥0.00";
            bannerView.coinL.text = LocalizationKey(@"Invitationrevenue");
            bannerView.coin.text = @"0.00";
            bannerView.numL.text = LocalizationKey(@"Cumulativerelease");
            bannerView.num.text = @"0.00";
            bannerView.cnyL.text = LocalizationKey(@"Notreleased");
            bannerView.cny.text = @"0.00";
            bannerView.cnyL.hidden = NO;
            bannerView.cny.hidden = NO;
        }
    }
    return bannerView;
}

//- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(HQFlowView *)flowView
//{
//    [self.pageFlowView.pageControl setCurrentPage:pageNumber];
//}
#pragma mark --旋转屏幕改变JQFlowView大小之后实现该方法
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        [coordinator animateAlongsideTransition:^(id context) { [self.pageFlowView reloadData];
        } completion:NULL];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


-(void)setBannerdic:(NSMutableDictionary *)bannerdic{
    _bannerdic = bannerdic;
    NSLog(@"===%@",_bannerdic);
    self.bannerArray = [NSMutableArray arrayWithObjects:bannerdic[@"myReward"],bannerdic[@"walletTotal"],bannerdic[@"freeAsset"],bannerdic[@"myRecommend"],bannerdic[@"investTotal"], nil];
    NSLog(@"===%@",self.bannerArray);
    self.totalL.text = [NSString stringWithFormat:@"%@(USDT)",LocalizationKey(@"Totalassetscoin")];
//    [self.scrollView addSubview:self.pageFlowView];
    [self.pageFlowView reloadData];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
