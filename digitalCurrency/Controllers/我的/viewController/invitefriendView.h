//
//  invitefriendView.h
//  digitalCurrency
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^invitefriendViewBlock)(NSInteger);
@interface invitefriendView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *weiboBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *pyqBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property(nonatomic,copy)invitefriendViewBlock invitefriendViewBlock;
+(instancetype)loadinvitefriendView:(invitefriendViewBlock)loadinvitefriendView;
@end
