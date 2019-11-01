//
//  HQIndexBannerSubview.m
//  HQCardFlowView
//
//  Created by Mr_Han on 2018/7/24.
//  Copyright © 2018年 Mr_Han. All rights reserved.
//  CSDN <https://blog.csdn.net/u010960265>
//  GitHub <https://github.com/HanQiGod>
//

#import "HQIndexBannerSubview.h"

@implementation HQIndexBannerSubview

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self addSubview:self.mainImageView];
        [self addSubview:self.titleL];
        [self addSubview:self.moneyL];
        [self addSubview:self.coinL];
        [self addSubview:self.coin];
        [self addSubview:self.numL];
        [self addSubview:self.num];
        [self addSubview:self.cnyL];
        [self addSubview:self.cny];
        [self addSubview:self.coverView];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleCellTapAction:)];
        [self addGestureRecognizer:singleTap];
    }
    
    return self;
}

- (void)singleCellTapAction:(UIGestureRecognizer *)gesture {
    if (self.didSelectCellBlock) {
        self.didSelectCellBlock(self.tag, self);
    }
}

- (void)setSubviewsWithSuperViewBounds:(CGRect)superViewBounds {
    
    NSLog(@"cell.coverView.alpha---%f",self.coverView.alpha);
    
    if (CGRectEqualToRect(self.mainImageView.frame, superViewBounds)) {
        return;
    }
    
    self.mainImageView.frame = superViewBounds;
    self.coverView.frame = superViewBounds;
}

- (UIImageView *)mainImageView {
    
    if (!_mainImageView) {
        _mainImageView = [[UIImageView alloc] init];
        _mainImageView.userInteractionEnabled = YES;
    }
    return _mainImageView;
}

- (UIImageView *)iconImage {
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImage;
}

- (UILabel *)titleL {
    
    if (!_titleL) {
        _titleL = [[UILabel alloc] initWithFrame:CGRectMake(13, 24, self.frame.size.width, 20)];
        _titleL.textColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        _titleL.font = [UIFont systemFontOfSize:14];
    }
    return _titleL;
}

- (UILabel *)moneyL {
    
    if (!_moneyL) {
        _moneyL = [[UILabel alloc] initWithFrame:CGRectMake(15, 57, self.frame.size.width, 25)];
        _moneyL.textColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        _moneyL.font = [UIFont boldSystemFontOfSize:23];
    }
    return _moneyL;
}

- (UILabel *)coinL {
    
    if (!_coinL) {
        _coinL = [[UILabel alloc] initWithFrame:CGRectMake(0, 102, (self.frame.size.width-30)/3, 20)];
        _coinL.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _coinL.textAlignment = NSTextAlignmentCenter;
        _coinL.font = [UIFont systemFontOfSize:12];
    }
    return _coinL;
}

- (UILabel *)coin {
    
    if (!_coin) {
        _coin = [[UILabel alloc] initWithFrame:CGRectMake(0, 121, (self.frame.size.width-30)/3, 20)];
        _coin.textColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        _coin.textAlignment = NSTextAlignmentCenter;
        _coin.font = [UIFont systemFontOfSize:14];
    }
    return _coin;
}

- (UILabel *)numL {
    
    if (!_numL) {
        _numL = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-30)/3, 102, (self.frame.size.width-30)/3, 20)];
        _numL.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _numL.textAlignment = NSTextAlignmentCenter;
        _numL.font = [UIFont systemFontOfSize:12];
    }
    return _numL;
}

- (UILabel *)num {
    
    if (!_num) {
        _num = [[UILabel alloc] initWithFrame:CGRectMake((self.frame.size.width-30)/3, 121, (self.frame.size.width-30)/3, 20)];
        _num.textColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        _num.textAlignment = NSTextAlignmentCenter;
        _num.font = [UIFont systemFontOfSize:14];
    }
    return _num;
}

- (UILabel *)cnyL {
    
    if (!_cnyL) {
        _cnyL = [[UILabel alloc] initWithFrame:CGRectMake(2*((self.frame.size.width-30)/3), 102, (self.frame.size.width-30)/3, 20)];
        _cnyL.textColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _cnyL.textAlignment = NSTextAlignmentCenter;
        _cnyL.font = [UIFont systemFontOfSize:12];
    }
    return _cnyL;
}

- (UILabel *)cny {
    
    if (!_cny) {
        _cny = [[UILabel alloc] initWithFrame:CGRectMake(2*((self.frame.size.width-30)/3), 121, (self.frame.size.width-30)/3, 20)];
        _cny.textColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
        _cny.textAlignment = NSTextAlignmentCenter;
        _cny.font = [UIFont systemFontOfSize:14];
    }
    return _cny;
}

- (UIView *)coverView {
    
    if (!_coverView) {
        _coverView = [[UIView alloc] init];
        _coverView.backgroundColor = [UIColor blackColor];
    }
    return _coverView;
}


@end
