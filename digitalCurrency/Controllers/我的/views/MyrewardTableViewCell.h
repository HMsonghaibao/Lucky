//
//  MyassetsTableViewCell.h
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "investModel.h"
@interface MyrewardTableViewCell : UITableViewCell<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *backview;
@property (weak, nonatomic) IBOutlet UILabel *titleview;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;
@property (nonatomic,copy)void (^selectBlock)(NSInteger num);
@property (nonatomic, assign)NSInteger userType;
@property (nonatomic, strong)NSArray*investarr;
@end
