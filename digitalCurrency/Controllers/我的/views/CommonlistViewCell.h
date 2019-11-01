//
//  CommonlistViewCell.h
//  digitalCurrency
//
//  Created by Apple on 2019/9/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonlistViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

NS_ASSUME_NONNULL_END
