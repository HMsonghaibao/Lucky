//
//  MyassetsTableViewCell.m
//  digitalCurrency
//
//  Created by startlink on 2018/8/6.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyteamTableViewCell.h"
#import "AactionCollectionViewCell.h"

@implementation MyteamTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backview.layer.masksToBounds = YES;
    self.backview.layer.cornerRadius = 3;
    self.titleview.text = @"团队管理";
    [self updatacollectionUI];
}

-(void)updatacollectionUI{
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerNib:[UINib nibWithNibName:@"AactionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"AactionCollectionViewCell"];
//    self.collectionview.backgroundColor = [UIColor redColor];
    
}


-(void)setUserType:(NSInteger)userType{
    _userType=userType;
    [self.collectionview reloadData];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
        AactionCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AactionCollectionViewCell" forIndexPath:indexPath];

    NSArray *namearray;
    NSArray *imagearray;
    namearray = @[@"游戏",@"商城",@"短视频",@"更多"];
    imagearray = @[@"生态圈_游戏",@"生态圈_商城",@"生态圈_视频",@"生态圈_更多"];
    
    cell.logimage.image = [UIImage imageNamed:imagearray[indexPath.row]];
    cell.namelabel.text = namearray[indexPath.row];
    return cell;
  
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(self.collectionview.width / 4,self.collectionview.width / 4);
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
  
//    self.selectBlock(indexPath.row);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
