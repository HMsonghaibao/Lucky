//
//  MyassetsTableViewCell.h
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HQFlowView.h"
@interface MyassetsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleview;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,copy)void (^selectBlock)(NSInteger num);
@property (nonatomic,copy)void (^scrollToPage)(NSInteger page);
@property (nonatomic, assign)NSInteger userType;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UILabel *cnyL;

@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *advArray;
/**
 *  轮播图
 */
@property (nonatomic, strong) HQFlowView *pageFlowView;
@property (nonatomic, strong) NSMutableDictionary *bannerdic;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property(nonatomic,copy)NSString *assetUSD;
@property(nonatomic,copy)NSString *assetCNY;

- (void)scrollTopPage:(NSInteger)pagel;
@end
