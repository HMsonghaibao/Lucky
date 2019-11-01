//
//  PartnerDetailViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/22.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "PartnerDetailViewController.h"
#import "SelectCoinTypeView1.h"
#import "MineNetManager.h"
#import "PartnerTypeModel.h"

static NSString *partnerID = @"partnerCellId";

@interface PartnerDetailViewController ()<UITableViewDataSource, UITableViewDelegate,SelectCoinTypeView1Delegate>{
    SelectCoinTypeView1 *_selectTypeView;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
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
@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *coinArray;
@property (nonatomic, copy) NSString *coinId;

@property (nonatomic, strong) NSArray *titleLabels;
@property (nonatomic, strong) NSArray *contentLabels;
@property (nonatomic, strong) NSArray *heights;

@end

@implementation PartnerDetailViewController

- (NSMutableArray *)coinArray{
    if (!_coinArray) {
        _coinArray = [NSMutableArray array];
    }
    return _coinArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = LocalizationKey(@"DetailsOfInvite");
    
    self.typeButton.selected = NO;
    self.tableView.scrollEnabled = NO;
    
    self.dataArray = @[LocalizationKey(@"BusinessPartner"),LocalizationKey(@"ProjectPartner")];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: partnerID];
    
    [self getData];
    [self requestData];
    [self UILayout];
}

- (void)UILayout{
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@~",self.nameFrom,LocalizationKey(@"InviteBecomePartner")];
    if (self.applyType > 0) {
        self.typeLabel.text = [NSString stringWithFormat:@"%@",self.dataArray[self.applyType-1]];
    }
    _titleLabels = @[_titleLabel1,_titleLabel2,_titleLabel3,_titleLabel4];
    _contentLabels = @[_detailLabel,_detailLabel2,_detailLabel3,_detailLabel4];
    _heights = @[_detailLabelHeight,_detailLabelHeight2,_detailLabelHeight3,_detailLabelHeight4];
    
    _payTypeLabel.text = LocalizationKey(@"SelectPaymentMethod");
    [_confirmButton setTitle:LocalizationKey(@"Confirminvitation") forState:UIControlStateNormal];
}


- (IBAction)comfirmAction:(UIButton *)sender {
    
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:self.uidFrom forKey:@"inviterId"];
    [bodydic setValue:@(self.applyType) forKey:@"applyType"];
    [bodydic setObject:self.coinId forKey:@"coinId"];
    
    NSLog(@"=====%@",bodydic);
    [MineNetManager invitationApplyPartner:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [self.navigationController popViewControllerAnimated:YES];
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
    [MineNetManager getPartnerInfo:@{@"language":languagestr} CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSArray *dataArr = [PartnerTypeModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self refreshRule:dataArr];
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
    
    for (int i=0; i<dataArr.count; i++) {
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
        _typeViewHeight.constant = 40*2+47;
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


//MARK:--获取数据
-(void)getData{
    [self.coinArray removeAllObjects];
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:[NSString stringWithFormat:@"%lu",self.applyType] forKey:@"partnerType"];
    NSLog(@"=====%@",bodydic);
    [MineNetManager getApplyMoneyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSArray *dataArr = [applyPartnerModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.coinArray addObjectsFromArray:dataArr];
                
                applyPartnerModel *model0 = dataArr[0];
                NSString*str = [self removeFloatAllZero:model0.money];
                self.priceLabel.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"PaymentAmount"), str];
                [self.unitButton setTitle:model0.coinId forState:UIControlStateNormal];
                self.coinId = model0.coinId;
                
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
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _typeViewHeight.constant = 47;
    _tableView.hidden = YES;
    _typeLabel.text = self.dataArray[indexPath.row];
    _applyType = indexPath.row+1;
    self.typeButton.selected = NO;
    [self getData];
}


- (void)selectCoinTypeModel:(applyPartnerModel *)model enterIndex:(NSInteger)index payWaysArr:(NSMutableArray *)payWaysArr {
    
    NSString*str = [self removeFloatAllZero:model.money];
    self.priceLabel.text = [NSString stringWithFormat:@"%@：%@",LocalizationKey(@"PaymentAmount"), str];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




@end
