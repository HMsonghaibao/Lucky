//
//  SelectCoinTypeView.h
//  digitalCurrency
//
//  Created by iDog on 2018/2/9.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "applyPartnerModel.h"
@class SelectCoinTypeView1;
@protocol SelectCoinTypeView1Delegate <NSObject>
- (void)selectCoinTypeModel:(applyPartnerModel *)model  enterIndex:(NSInteger)index payWaysArr:(NSMutableArray *)payWaysArr;
@end

@interface SelectCoinTypeView1 : UIView<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *certainButton;
@property(nonatomic,strong)NSArray<applyPartnerModel *> *modelArr;
@property (nonatomic,weak) id<SelectCoinTypeView1Delegate> delegate;
@property(nonatomic,assign)NSInteger enterIndex;//进入的类型 1:选择币种进入 2：选择付款方式
@property(nonatomic,strong)NSMutableArray *payWaysSelectArr;
@property (weak, nonatomic) IBOutlet UIView *boardView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boardViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneBtnHeightConstraint;


@end
