//
//  HomeViewController.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EcologyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
-(void)getotcUnReadCount;
-(void)getinvitationUnReadCount;
-(void)gettencentUnReadCount;
@end
