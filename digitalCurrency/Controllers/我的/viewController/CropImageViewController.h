//
//  CropImageViewController.h
//  digitalCurrency
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^cropSucess)(UIImage *image);
@interface CropImageViewController : UIViewController
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) cropSucess cropSucess;
@end
