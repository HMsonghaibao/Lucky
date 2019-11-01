//
//  HZBannerTableViewCell.h
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/18.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZBannerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HZBannerTableViewCell : UICollectionViewCell

/**  数据模型 */
@property (nonatomic, strong) HZBannerModel *model;

@end

NS_ASSUME_NONNULL_END
