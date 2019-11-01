//
//  InvestmentIncomeViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/7/24.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvestmentIncomeViewController.h"
#import "RewardListViewController.h"
#import "MineNetManager.h"
#import "InvestTotalModel.h"

@interface InvestmentIncomeViewController ()<UIScrollViewDelegate>{
    
    UIButton *_currentSelectBtn;
    RewardListViewController *_leftVC;
    RewardListViewController *_rightVC;
    RewardListViewController *_threeVC;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *inviteLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *leijiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shengyuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *foutouButton;
@property (weak, nonatomic) IBOutlet UIButton *shouyiButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *invteTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *leijiTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *shifangTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *teamButton;

@end

@implementation InvestmentIncomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self UILayout];
    [self requestData];
}

- (void)requestData{
    [MineNetManager getInvestRewardTotal:nil CompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"===%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //获取数据成功
                
                //mj_objectWithKeyValues
                InvestTotalModel *model = [InvestTotalModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                self.titleLabel.text = [NSString stringWithFormat:@"%@(%.2fUSDT)", LocalizationKey(@"Totalinvestmentincome"),[model.usdtTotal doubleValue]];
                self.amountLabel.text = [NSString stringWithFormat:@"￥%.2f",[model.cnyTotal doubleValue]];
                self.inviteLabel.text = [NSString stringWithFormat:@"%.2f",[model.inviteRewardMoney doubleValue]];
                self.leijiLabel.text = [NSString stringWithFormat:@"%.2f",[model.freeMoney doubleValue]];
                self.shengyuLabel.text = [NSString stringWithFormat:@"%.2f",[model.lockMoney doubleValue]];
                
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

- (void)UILayout{
    
    self.title = LocalizationKey(@"Totalinvestmentincome");
    
    self.invteTitleLabel.text = LocalizationKey(@"InviteIncome");
    self.leijiTitleLabel.text = LocalizationKey(@"Cumulativerelease");
    self.shifangTitleLabel.text = LocalizationKey(@"Notreleased");
    
    [self.foutouButton setTitle:LocalizationKey(@"Re-record") forState:UIControlStateNormal];
    [self.shouyiButton setTitle:LocalizationKey(@"IncomeRecord") forState:UIControlStateNormal];
    [self.teamButton setTitle:LocalizationKey(@"TeamIncome") forState:UIControlStateNormal];
    
    self.topViewHeight.constant = (SCREEN_WIDTH_S-32)*179/343+65;
    self.lineView.top = (SCREEN_WIDTH_S-32)*179/343+44;
    self.lineView.centerX = self.foutouButton.centerX;
    self.foutouButton.selected = YES;
    _currentSelectBtn = self.foutouButton;
    
    self.scrollView.delegate = self;
    
    _leftVC = [[RewardListViewController alloc] init];
    _leftVC.listType = 1;
    _leftVC.view.frame = CGRectMake(0, 0, SCREEN_WIDTH_S, self.scrollView.frame.size.height);
    [self addChildViewController:_leftVC];
    [self.scrollView addSubview:_leftVC.view];
    
    _rightVC = [[RewardListViewController alloc] init];
    _rightVC.listType = 2;
    _rightVC.view.frame = CGRectMake(SCREEN_WIDTH_S, 0, SCREEN_WIDTH_S, self.scrollView.frame.size.height);
    [self addChildViewController:_rightVC];
    [self.scrollView addSubview:_rightVC.view];
    
    _threeVC = [[RewardListViewController alloc] init];
    _threeVC.listType = 3;
    _threeVC.view.frame = CGRectMake(SCREEN_WIDTH_S*2, 0, SCREEN_WIDTH_S, self.scrollView.frame.size.height);
    [self addChildViewController:_threeVC];
    [self.scrollView addSubview:_threeVC.view];
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH_S*3, 0);
}

- (IBAction)changedIndexAction:(UIButton *)sender {
    if (!sender.selected) {
        _currentSelectBtn.selected = NO;
        sender.selected = YES;
        _currentSelectBtn = sender;
        self.lineView.centerX = sender.centerX;
        [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH_S*(sender.tag-1110), 0) animated:YES];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = (scrollView.contentOffset.x/SCREEN_WIDTH_S);
    if ((_currentSelectBtn.tag-1110) != index) {
        UIButton *button = [self.view viewWithTag:1110+index];
        _currentSelectBtn.selected = NO;
        button.selected = YES;
        _currentSelectBtn = button;
        self.lineView.centerX = _currentSelectBtn.centerX;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
