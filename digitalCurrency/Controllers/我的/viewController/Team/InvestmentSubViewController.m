//
//  PartnerDetailViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InvestmentSubViewController.h"
#import "SelectCoinTypeView1.h"
#import "MineNetManager.h"
#import "invTypeModel.h"
#import "HMScannerController.h"
#import "LoginNetManager.h"
#import "PartnerTypeModel.h"
static NSString *partnerID = @"partnerCellId";

@interface InvestmentSubViewController ()<UITableViewDataSource, UITableViewDelegate,SelectCoinTypeView1Delegate, UITextFieldDelegate>{
    SelectCoinTypeView1 *_selectTypeView;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *unitButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel4;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel2;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel3;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailLabelHeight4;
@property (weak, nonatomic) IBOutlet UITextField *codetf;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *coinArray;
@property (nonatomic, copy) NSString *coinId;

@property (nonatomic, strong) NSArray *titleLabels;
@property (nonatomic, strong) NSArray *contentLabels;
@property (nonatomic, strong) NSArray *heights;
@property (nonatomic, assign) NSInteger applyType;
@property (nonatomic, assign) NSInteger applyMoneyId;
@property (nonatomic, copy) NSString *invested;
@property (nonatomic, copy) NSString *typeId;
@property (weak, nonatomic) IBOutlet UIView *moneyView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *num1L;
@property (weak, nonatomic) IBOutlet UILabel *num2L;
@property (weak, nonatomic) IBOutlet UILabel *num3L;
@property (weak, nonatomic) IBOutlet UILabel *num4L;
@property (weak, nonatomic) IBOutlet UILabel *vtL;
@property (weak, nonatomic) IBOutlet UILabel *dvL;
@property (weak, nonatomic) IBOutlet UILabel *oneL;
@property (weak, nonatomic) IBOutlet UILabel *twoL;
@property (weak, nonatomic) IBOutlet UILabel *threeL;
@property (weak, nonatomic) IBOutlet UILabel *fourL;
@property (weak, nonatomic) IBOutlet UILabel *vtdescL;
@property (nonatomic, assign)ChildInvestViewType childViewType;
@end

@implementation InvestmentSubViewController


- (instancetype)initWithChildViewType:(ChildInvestViewType)childViewType
{
    self = [super init];
    if (self) {
        self.childViewType = childViewType;
    }
    return self;
}


- (NSMutableArray *)coinArray{
    if (!_coinArray) {
        _coinArray = [NSMutableArray array];
    }
    return _coinArray;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _inputTF.delegate = self;
    [_inputTF setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];

    
//    self.titleLabel.text = LocalizationKey(@"Selectinvestmentamount");
//    self.titleLabel1.text = LocalizationKey(@"Investmentrules");
//    [self.doneBtn setTitle:LocalizationKey(@"Confirmationapplication") forState:0];
    self.typeButton.selected = NO;
    self.tableView.scrollEnabled = NO;
    
    self.moneyView.layer.borderWidth = 1;
    self.moneyView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1].CGColor;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: partnerID];
    
    self.applyMoneyId = 1;
//    [self getData];
    [self requestData];
//    [self getMoneyData];
    self.typeId = @"1";
    
    [self.codetf setValue:RGBOF(0x999999) forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
    if (self.childViewType == 0) {
        self.backImageView.image = [UIImage imageNamed:@"investment-150"];
        self.moneyL.textColor = RGB(24, 178, 247);
        self.vtdescL.textColor = RGB(24, 178, 247);
        self.oneL.textColor = RGB(24, 178, 247);
        self.twoL.textColor = RGB(24, 178, 247);
        self.threeL.textColor = RGB(24, 178, 247);
        self.fourL.textColor = RGB(24, 178, 247);
    }else if (self.childViewType == 1){
        self.backImageView.image = [UIImage imageNamed:@"investment-1500"];
        self.moneyL.textColor = RGB(49, 115, 231);
        self.vtdescL.textColor = RGB(49, 115, 231);
        self.oneL.textColor = RGB(49, 115, 231);
        self.twoL.textColor = RGB(49, 115, 231);
        self.threeL.textColor = RGB(49, 115, 231);
        self.fourL.textColor = RGB(49, 115, 231);
    }else if (self.childViewType == 2){
        self.backImageView.image = [UIImage imageNamed:@"investment-5000"];
        self.moneyL.textColor = RGB(76, 72, 255);
        self.vtdescL.textColor = RGB(76, 72, 255);
        self.oneL.textColor = RGB(76, 72, 255);
        self.twoL.textColor = RGB(76, 72, 255);
        self.threeL.textColor = RGB(76, 72, 255);
        self.fourL.textColor = RGB(76, 72, 255);
    }else{
        self.backImageView.image = [UIImage imageNamed:@"investment-10000"];
        self.moneyL.textColor = RGB(118, 21, 238);
        self.vtdescL.textColor = RGB(118, 21, 238);
        self.oneL.textColor = RGB(118, 21, 238);
        self.twoL.textColor = RGB(118, 21, 238);
        self.threeL.textColor = RGB(118, 21, 238);
        self.fourL.textColor = RGB(118, 21, 238);
    }
    
    self.moneyL.text = _model.amount;
    self.vtdescL.text = _model.inUnit;
    self.num1L.text = [NSString stringWithFormat:@"%@%@等值%ld%@",_model.amount,_model.inUnit,_model.amount.integerValue*3,_model.releaseUnit];
    self.num2L.text = [NSString stringWithFormat:@"%.1f%%",_model.staticRatio.floatValue*100];
    self.num3L.text = [NSString stringWithFormat:@"%.1f%@等值%.1f%@",_model.amount.floatValue*_model.staticRatio.floatValue,_model.inUnit,_model.amount.floatValue*_model.staticRatio.floatValue*3,_model.releaseUnit];
    self.num4L.text = [NSString stringWithFormat:@"%.1f%%",_model.referrerRatio.floatValue*100];
    self.oneL.text = [NSString stringWithFormat:@"%@倍杠杆收益:",_model.leverRatio];
    self.vtL.text = [NSString stringWithFormat:@"%@%@",_model.amount,_model.inUnit];
    self.dvL.text = [NSString stringWithFormat:@"%ld%@",_model.amount.integerValue*3,_model.releaseUnit];
}


- (void)UILayout{

    
    _titleLabels = @[_titleLabel1,_titleLabel2];
    _contentLabels = @[_detailLabel,_detailLabel2];
    _heights = @[_detailLabelHeight,_detailLabelHeight2];
}

- (IBAction)codeBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    NSString *cardName = @"";
    UIImage *avatar = [UIImage imageNamed:@""];
    
    HMScannerController *scanner = [HMScannerController scannerWithCardName:cardName avatar:avatar completion:^(NSString *stringValue) {
        NSString*str= [stringValue substringFromIndex:stringValue.length-9];
        self.codetf.text = str;
    }];
    
    [scanner setTitleColor:[UIColor whiteColor] tintColor:[UIColor greenColor]];
    
    [self showDetailViewController:scanner sender:nil];
}

- (IBAction)comfirmAction:(UIButton *)sender {
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:self.model.id forKey:@"modeId"];
    NSLog(@"=====%@",bodydic);
    [MineNetManager customInvestApplyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"status"] integerValue]==0) {
                //获取数据成功
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
//                [self.navigationController popViewControllerAnimated:YES];
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];

}

- (void)requestData{
    NSString*languagestr=@"";
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        languagestr = @"en_us";
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        languagestr = @"zh_cn";
    }
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:languagestr forKey:@"language"];
    [MineNetManager getLotterySession:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
//                self.detailLabel.text = resPonseObj[@"data"];
                UILabel *contentLabel = self.detailLabel;
                contentLabel.text = resPonseObj[@"data"];
                
                NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:resPonseObj[@"data"]];
                
                CGSize size = CGSizeMake(SCREEN_WIDTH_S-42, CGFLOAT_MAX);
                NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
                paragraph.lineSpacing = 6;
                [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [resPonseObj[@"data"] length])];
                contentLabel.attributedText = attr;
                
                CGRect rect = [resPonseObj[@"data"] boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],NSParagraphStyleAttributeName : paragraph} context:nil];
                
                NSLayoutConstraint *height = _detailLabelHeight;
                height.constant = rect.size.height;
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];

}

- (void)refreshRule:(NSArray *)dataArr{
    
    for (int i=0; i<2; i++) {
        PartnerTypeModel *model = dataArr[i];
        
        UILabel *titleLabel = _titleLabels[i];
        titleLabel.text = model.typeName;
        
        UILabel *contentLabel = _contentLabels[i];
        contentLabel.text = model.content;
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:model.content];
        
        CGSize size = CGSizeMake(SCREEN_WIDTH_S-42, CGFLOAT_MAX);
        NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 6;
        [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, model.content.length)];
        contentLabel.attributedText = attr;
        
        CGRect rect = [model.content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],NSParagraphStyleAttributeName : paragraph} context:nil];
        
        NSLayoutConstraint *height = _heights[i];
        height.constant = rect.size.height;
    }
}

- (IBAction)typeSeletcdAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (!sender.selected) {
        _typeViewHeight.constant = 47;
        _tableView.hidden = YES;
    }else{
        _typeViewHeight.constant = 40*self.dataArray.count+47;
        _tableView.hidden = NO;
    }
}

- (IBAction)unitSelectdAction:(UIButton *)sender {
    
    if (self.coinArray.count == 0) {
        return;
    }
    
    if (self.coinArray.count > 1) {
        [self selectCoinTypeView];
    }
}


//MARK:--获取已投资金额
-(void)getMoneyData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    NSLog(@"=====%@",bodydic);
    [MineNetManager getInvestMoneyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.invested = resPonseObj[@"data"];
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


//MARK:--获取数据
-(void)getData{
    [self.coinArray removeAllObjects];
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    NSLog(@"=====%@",bodydic);
    [MineNetManager queryInvestApplyMoneyListParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSArray *dataArr = [invTypeModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.dataArray addObjectsFromArray:dataArr];
                
                if (self.dataArray.count>0) {
                    invTypeModel *model0 = dataArr[0];
                    NSString*str = [self removeFloatAllZero:model0.payMoney];
                    self.priceLabel.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"Paymentamount"), str];
                    self.applyMoneyId = [model0.id integerValue];
                    [self.unitButton setTitle:model0.unit forState:UIControlStateNormal];
                    self.coinId = model0.unit;
                    self.inputTF.text = model0.money;
                    self.inputTF.enabled = NO;
                    self.typeButton.enabled = YES;
                    self.titleLabel.text = LocalizationKey(@"Selectinvestmentamount");
                }else{
                    self.priceLabel.text = [NSString stringWithFormat:@"%@：0",LocalizationKey(@"Paymentamount")];
                    [self.unitButton setTitle:@"USDT" forState:UIControlStateNormal];
                    self.coinId = @"USDT";
                    self.inputTF.placeholder = LocalizationKey(@"Pleaseentertheinvestmentamount");
                    self.inputTF.enabled = YES;
                    self.typeButton.enabled = NO;
                    self.typeId = @"2";
                    self.titleLabel.text = LocalizationKey(@"Pleaseentertheinvestmentamount");
                }
                
                invTypeModel *model = [[invTypeModel alloc] init];
                model.money = LocalizationKey(@"customize");
                [self.dataArray addObject:model];
                
                [self.tableView reloadData];
        
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}

-(NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.doubleValue)];
    return outNumber;
}

#pragma UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:partnerID forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    invTypeModel*model=self.dataArray[indexPath.row];
    cell.textLabel.text = model.money;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _typeViewHeight.constant = 47;
    _tableView.hidden = YES;
    invTypeModel*model=self.dataArray[indexPath.row];
    if ([model.money isEqualToString:LocalizationKey(@"customize")]) {
        self.typeId = @"2";
        _inputTF.enabled = YES;
        _inputTF.text = @"";
        _inputTF.placeholder = LocalizationKey(@"Pleaseentertheinvestmentamount");
        [_inputTF becomeFirstResponder];
        self.priceLabel.text = [NSString stringWithFormat:@"%@：0",LocalizationKey(@"Paymentamount")];
    }else{
        self.typeId = @"1";
        _inputTF.enabled = NO;
        _inputTF.text = model.money;
        self.priceLabel.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"Paymentamount"), model.payMoney];
    }
    self.typeButton.selected = NO;
    self.applyMoneyId = [model.id integerValue];
//    [self getData];
}


- (void)selectCoinTypeModel:(applyPartnerModel *)model enterIndex:(NSInteger)index payWaysArr:(NSMutableArray *)payWaysArr {
    
    NSString*str = [self removeFloatAllZero:model.money];
    self.priceLabel.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"Paymentamount"), str];
    [self.unitButton setTitle:model.coinId forState:UIControlStateNormal];
    self.coinId = model.coinId;
}

//MARK:--点击购买弹出的提示框
-(void)selectCoinTypeView{
    if (!_selectTypeView) {
        _selectTypeView = [[NSBundle mainBundle] loadNibNamed:@"SelectCoinTypeView1" owner:nil options:nil].firstObject;
        _selectTypeView.frame=[UIScreen mainScreen].bounds;
        _selectTypeView.modelArr = self.coinArray;
        _selectTypeView.delegate = self;
    }
    _selectTypeView.enterIndex = 1;
    [_selectTypeView.tableView reloadData];
    [self.view addSubview:_selectTypeView];
    CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0,1.0);
    _selectTypeView.boardView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.2,0.2);
    _selectTypeView.boardView.alpha = 0;
    [UIView animateWithDuration:0.3 delay:0.1 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveLinear animations:^{
        _selectTypeView.boardView.transform = transform;
        _selectTypeView.boardView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
//    double amount = [textField.text doubleValue];
//    if (amount < 5000) {
//        textField.text = @"5000";
//    }
    if (textField.text.length == 0) {
        self.priceLabel.text = [NSString stringWithFormat:@"%@：0",LocalizationKey(@"Paymentamount")];
    }else{
        NSInteger money = [textField.text integerValue] - [self.invested integerValue];
        self.priceLabel.text = [NSString stringWithFormat:@"%@：%ld",LocalizationKey(@"Paymentamount"), money];
    }
    
//    invTypeModel *model = self.dataArray.lastObject;
//    model.money = textField.text;
    
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
