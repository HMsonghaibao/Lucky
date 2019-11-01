//
//  MyassetsTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyinvestmentTableViewCell.h"
#import "AactionCollectionViewCell.h"

@implementation MyinvestmentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backview.layer.masksToBounds = YES;
    self.backview.layer.cornerRadius = 3;
    [self updatacollectionUI];
}

-(void)updatacollectionUI{
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"AactionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AactionCollectionViewCell"];

}


-(void)setUserType:(NSInteger)userType{
    _userType=userType;
    [self.collectionview reloadData];
    self.titleview.text = LocalizationKey(@"Investmentmanagement");
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        AactionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AactionCollectionViewCell" forIndexPath:indexPath];
    NSArray *namearray;
    NSArray *imagearray;
    namearray = @[LocalizationKey(@"life"),LocalizationKey(@"Social"),LocalizationKey(@"entertainment"),LocalizationKey(@"Live"),LocalizationKey(@"shopping"),LocalizationKey(@"game"),LocalizationKey(@"loan"),LocalizationKey(@"Pay")];
    imagearray = @[@"home-1",@"home-2",@"home-3",@"home-4",@"home-5",@"home-6",@"home-7",@"home-8"];
    cell.logimage.image = [UIImage imageNamed:imagearray[indexPath.row]];
    cell.namelabel.text = namearray[indexPath.row];
    return cell;
  
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionview.width / 4,self.collectionview.width / 4-10);
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
