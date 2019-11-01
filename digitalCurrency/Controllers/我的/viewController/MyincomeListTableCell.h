//
//  MyincomeListTableCell.h
//  digitalCurrency
//
//  Created by mac on 2019/7/24.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyincomeListBlock)(NSInteger);
@interface MyincomeListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIButton *leftbtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property(nonatomic,copy)MyincomeListBlock MyincomeListBlock;
@end
