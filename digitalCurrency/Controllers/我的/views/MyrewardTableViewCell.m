//
//  MyassetsTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyrewardTableViewCell.h"
#import "AactionCollectionViewCell1.h"

@implementation MyrewardTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backview.layer.masksToBounds = YES;
    self.backview.layer.cornerRadius = 3;
    self.titleview.text = @"奖励管理";
    [self updatacollectionUI];
}

-(void)updatacollectionUI{
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"AactionCollectionViewCell1" bundle:nil] forCellWithReuseIdentifier:@"AactionCollectionViewCell1"];

}


-(void)setInvestarr:(NSArray *)investarr{
    _investarr=investarr;
    [self.collectionview reloadData];
}


-(void)setUserType:(NSInteger)userType{
    _userType=userType;
    [self.collectionview reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return 4;
    return self.investarr.count;
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        AactionCollectionViewCell1 *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AactionCollectionViewCell1" forIndexPath:indexPath];
    NSArray *namearray;
    NSArray *imagearray;
    namearray = @[@"150U",@"1500U",@"5000U",@"10000U"];
    imagearray = @[@"home-small",@"home-bsmall",@"home-bbsmall",@"home-big"];
    investModel*model = self.investarr[indexPath.item];
//    cell.logimage.image = [UIImage imageNamed:imagearray[indexPath.row]];
    [cell.logbtn setBackgroundImage:[UIImage imageNamed:imagearray[indexPath.row]] forState:0];
//    cell.namelabel.text = namearray[indexPath.row];
    cell.namelabel.text = [NSString stringWithFormat:@"%@TV",model.amount];
    if (indexPath.row == 0) {
//        cell.namelabel.textColor = RGB(24, 178, 247);
        cell.doneL.text = @"微型矿机";
    }else if (indexPath.row == 1){
//        cell.namelabel.textColor = RGB(49, 115, 231);
        cell.doneL.text = @"小型矿机";
    }else if (indexPath.row == 2){
//        cell.namelabel.textColor = RGB(76, 72, 255);
        cell.doneL.text = @"中型矿机";
    }else{
//        cell.namelabel.textColor = RGB(118, 21, 238);
        cell.doneL.text = @"大型矿机";
    }
    return cell;
  
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((self.collectionview.width-10) / 2,100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  
    self.selectBlock(indexPath.row);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
