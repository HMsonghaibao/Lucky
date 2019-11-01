//
//  HQIndexBannerSubview.h
//  HQCardFlowView
//
//  Created by Mr_Han on 2018/7/24.
//  Copyright © 2018年 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//


/******************************
 
 可以根据自己的需要继承HQIndexBannerSubview
 
 ******************************/

#import <UIKit/UIKit.h>

@interface HQIndexBannerSubview : UIView

/**
 *  主图
 */
@property (nonatomic, strong) UIImageView *mainImageView;

/**
 *  阴影
 */
@property (nonatomic, strong) UIImageView *iconImage;

/**
 *  标题
 */
@property (nonatomic, strong) UILabel *titleL;

/**
 *  金额
 */
@property (nonatomic, strong) UILabel *moneyL;

/**
 *  币种
 */
@property (nonatomic, strong) UILabel *coinL;

/**
 *  币种值
 */
@property (nonatomic, strong) UILabel *coin;

/**
 *  金额
 */
@property (nonatomic, strong) UILabel *numL;

/**
 *  金额
 */
@property (nonatomic, strong) UILabel *num;

/**
 *  金额
 */
@property (nonatomic, strong) UILabel *cnyL;

/**
 *  金额
 */
@property (nonatomic, strong) UILabel *cny;

/**
 *  用来变色的view
 */
@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, copy) void (^didSelectCellBlock)(NSInteger tag, HQIndexBannerSubview *cell);

/**
 设置子控件frame,继承后要重写
 
 @param superViewBounds <#superViewBounds description#>
 */
- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds;



@end
