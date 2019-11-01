//
//  SweepstakesViewController.m
//  digitalCurrency
//
//  Created by LiuXiongwei on 2019/6/15.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "SweepstakesViewController.h"
#import "MineNetManager.h"
#import "LotteryModel.h"
#import "CountDown.h"
#import "UIView+ArrangeSubview.h"
#import "LotteryListViewController.h"
#import "RecordDetailController.h"
@interface SweepstakesViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *kTitleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *kTitleLabel2;
@property (weak, nonatomic) IBOutlet UILabel *kTitleLabel3;
@property (weak, nonatomic) IBOutlet UILabel *kTitleLabel4;
@property (weak, nonatomic) IBOutlet UIButton *kButton1;
@property (weak, nonatomic) IBOutlet UIButton *kButton2;
@property (weak, nonatomic) IBOutlet UIButton *kButton3;
@property (weak, nonatomic) IBOutlet UIButton *kButton4;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel1;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel2;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel3;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel4;
@property (weak, nonatomic) IBOutlet UIView *lineView0;

@property (weak, nonatomic) IBOutlet UIView *lineView1;
@property (weak, nonatomic) IBOutlet UIView *lineView2;
@property (weak, nonatomic) IBOutlet UIView *lineView3;
@property (weak, nonatomic) IBOutlet UIView *lineView4;

@property (weak, nonatomic) IBOutlet UIButton *tButton1;
@property (weak, nonatomic) IBOutlet UIButton *tButton2;
@property (weak, nonatomic) IBOutlet UIButton *tButton3;
@property (weak, nonatomic) IBOutlet UIButton *tButton4;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel1;
@property (weak, nonatomic) IBOutlet UILabel *secLabel1;
@property (weak, nonatomic) IBOutlet UILabel *minLabel1;
@property (weak, nonatomic) IBOutlet UILabel *ruleLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel1;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel2;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel3;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel4;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ruleTextHeight;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *secLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeLabel;
@property (weak, nonatomic) IBOutlet UILabel *reTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *regisImageV;


@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) NSArray *kTitileLabels;
@property (nonatomic, strong) NSArray *kButtons;
@property (nonatomic, strong) NSArray *tButtons;
@property (nonatomic, strong) NSArray *lineViews;
@property (nonatomic, strong) NSArray *timeLabels;
@property (nonatomic, strong) NSArray *statusLabels;

@property (strong, nonatomic)  CountDown *countDownForLabel;
@end

@implementation SweepstakesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _countDownForLabel = [[CountDown alloc] init];
    
    
    [self UILayout];
    [self requestData];
    [self requestRule];
    
    
}



-(long long)getCurrentTimestamp{
    NSDate* currentdate = [NSDate date];
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString*dateTime = [formatter stringFromDate:currentdate];
    NSTimeInterval a=[currentdate timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f000", a];//转为字符型
    long long startLongLong = [timeString longLongValue];
    NSLog(@"当前时间是===%@===%lld",dateTime,startLongLong);
    return startLongLong;
}

///此方法用两个时间戳做参数进行倒计时
-(void)startLongLongStartStamp:(long long)strtLL longlongFinishStamp:(long long)finishLL{
    __weak __typeof(self) weakSelf= self;
    [_countDownForLabel countDownWithStratTimeStamp:strtLL finishTimeStamp:finishLL completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
        NSLog(@"666");
        [weakSelf refreshUIDay:day hour:hour minute:minute second:second];
    }];
}


-(void)refreshUIDay:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    if (hour==0) {
        self.hourLabel1.text = @"00";
    }else{
        if (hour<10&&hour) {
            self.hourLabel1.text = [NSString stringWithFormat:@"0%ld",(long)hour];
        }else{
            self.hourLabel1.text = [NSString stringWithFormat:@"%ld",(long)hour];
        }
    }
    
    if (minute==0) {
        self.secLabel1.text = @"00";
    }else{
        if (minute<10) {
            self.secLabel1.text = [NSString stringWithFormat:@"0%ld",(long)minute];
        }else{
            self.secLabel1.text = [NSString stringWithFormat:@"%ld",(long)minute];
        }
    }
    
    if (second==0) {
        self.minLabel1.text = @"00";
    }else{
        if (second<10) {
            self.minLabel1.text = [NSString stringWithFormat:@"0%ld",(long)second];
        }else{
            self.minLabel1.text = [NSString stringWithFormat:@"%ld",(long)second];
        }
    }
    
    
}


-(void)dealloc{
    [_countDownForLabel destoryTimer];
    NSLog(@"%s dealloc",object_getClassName(self));
}



- (void)UILayout{
    
    _kTitileLabels = @[_kTitleLabel1,_kTitleLabel2,_kTitleLabel3,_kTitleLabel4];
    _kButtons = @[_kButton1,_kButton2,_kButton3,_kButton4];
    _tButtons = @[_tButton1,_tButton2,_tButton3,_tButton4];
    _lineViews = @[_lineView0,_lineView1,_lineView2,_lineView3,_lineView4];
    _timeLabels = @[_timeLabel1,_timeLabel2,_timeLabel3,_timeLabel4];
    _statusLabels = @[_statusLabel1, _statusLabel2, _statusLabel3, _statusLabel4];
    
     for (int i=0; i<_kButtons.count; i++) {
          UIButton *button = _kButtons[i];
          [button setTitle:LocalizationKey(@"Waitingforthedraw") forState:UIControlStateNormal];
          [button setTitle:LocalizationKey(@"DrawOver") forState:UIControlStateDisabled];
     }
     
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH_S, SCREEN_HEIGHT_S);
     _hourLabel.text = LocalizationKey(@"Hour");
     _minLabel.text = LocalizationKey(@"Minute");
     _secLabel.text = LocalizationKey(@"Second");
     _detailLabel.text = LocalizationKey(@"RegistrationReminder");
     _reTitleLabel.text = LocalizationKey(@"RegisTitle");
     _activeLabel.text = LocalizationKey(@"Ruleofactivity");
     _regisImageV.image = [UIImage imageNamed:LocalizationKey(@"RegistrationImageName")];
}


-(void)gettime:(NSString*)str{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:str]; //------------将字符串按formatter转成nsdate    //时间转时间戳的方法:
//    NSString*dateTime = [formatter stringFromDate:date];
//    NSTimeInterval a=[date timeIntervalSince1970];
    
    NSTimeInterval time = 5 * 60;//五分钟的秒数
    NSDate *newDate = [date dateByAddingTimeInterval:-time];
    NSString*dateTime = [formatter stringFromDate:newDate];
    NSTimeInterval a=[newDate timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f000", a];//转为字符型
    long long finishLongLong1 = [timeString longLongValue];
    
    
    
    long long startLongLong1 = [self getCurrentTimestamp];
    
    NSLog(@"当前时间是===%@===%lld===%lld",dateTime,startLongLong1,finishLongLong1);
    
    ///方法一倒计时测试
    //    long long startLongLong = 1560737411000;
    //    long long finishLongLong = 1560741113000;
    [self startLongLongStartStamp:startLongLong1 longlongFinishStamp:finishLongLong1];
}


- (void)refrshUI:(NSArray *)dataArr{
    for (int i = 0; i < dataArr.count; i++) {
        LotteryModel *model = dataArr[i];
        
        UILabel *tLabel = _timeLabels[i];
        tLabel.text = model.time;
        
        UILabel *kLabel = _kTitileLabels[i];
        
        UIButton *kButton = _kButtons[i];
        
        UILabel *statusLabel = _statusLabels[i];
        
        UIButton *tButton = _tButtons[i];
        
        UIView *lineView = _lineViews[i];
        
        switch ([model.status integerValue]) {
            case 0:
                kButton.enabled = NO;
                tButton.selected = YES;
                kLabel.text = LocalizationKey(@"WinNBTC");
                lineView.backgroundColor = RGBCOLOR(228, 115, 54);
                break;
                
            case 1:
                //去报名
                kButton.hidden = YES;
                  kLabel.text = LocalizationKey(@"Redenvelopeskeepon");//@"红包不停\n+平台币";
                statusLabel.hidden = NO;
                  statusLabel.text = LocalizationKey(@"Tosignup");//@"去报名";
                statusLabel.backgroundColor = [UIColor whiteColor];//RGBACOLOR(255, 255, 255, 1);
                lineView.backgroundColor = RGBCOLOR(228, 115, 54);
                [self gettime:model.lotteryTime];
                self.dateLabel.text = [NSString stringWithFormat:@"(%@%@)%@",model.time,LocalizationKey(@"Session"),LocalizationKey(@"Countdown")];
                
                break;
            case 2:
                //已中奖
                kButton.enabled = NO;
                [kButton setTitle:LocalizationKey(@"Haswon") forState:UIControlStateDisabled];
                tButton.selected = YES;
                kLabel.text = LocalizationKey(@"WinNBTC");
                lineView.backgroundColor = RGBCOLOR(228, 115, 54);
                
                break;
            case 3:
                  kButton.hidden = YES;
                  kLabel.text = LocalizationKey(@"Redenvelopeskeepon");
                  tButton.enabled = NO;
                  statusLabel.hidden = NO;
                  statusLabel.text = LocalizationKey(@"Notstart");
                  lineView.backgroundColor = RGBCOLOR(253, 175, 96);
                  break;
            case 4:
                //待开奖
                kButton.hidden = NO;
                kButton.enabled = YES;
                statusLabel.hidden = YES;
                kLabel.text = LocalizationKey(@"WinNBTC");
                lineView.backgroundColor = RGBCOLOR(228, 115, 54);
                [self gettime:model.lotteryTime];
                self.dateLabel.text = [NSString stringWithFormat:@"(%@%@)%@",model.time,LocalizationKey(@"Session"),LocalizationKey(@"Countdown")];
                break;
                
            default:
                break;
        }
    }

}

- (void)refreshRule:(NSString *)rule{
    
    _ruleLabel.text = rule;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:rule];
    CGSize size = CGSizeMake(SCREEN_WIDTH_S-42, CGFLOAT_MAX);
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 6;
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, rule.length)];
    
    _ruleLabel.attributedText = attr;
    
    CGRect rect = [rule boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |  NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13],NSParagraphStyleAttributeName : paragraph} context:nil];
    
     if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
          _ruleTextHeight.constant = 90+rect.size.height;
     }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
     {
          _ruleTextHeight.constant = 60+rect.size.height;
     }
     
}


- (IBAction)clickButtonAction:(UIButton *)sender {
    
    LotteryModel *model = _dataSource[sender.tag - 110];
    NSLog(@"=====%@",model.status);
    if ([model.status integerValue] == 1) {
        //去报名
        [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
        [MineNetManager getRewardApply:nil CompleteHandle:^(id resPonseObj, int code) {
            [EasyShowLodingView hidenLoding];
            NSLog(@"=====%@",resPonseObj);
            if (code) {
                if ([resPonseObj[@"code"] integerValue]==0) {
                    //获取数据成功
                    [self requestData];
                }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                    [YLUserInfo logout];
                }else{
                    [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
                }
            }else{
                [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
            }
        }];
    }else if ([model.status integerValue] == 4){
        RecordDetailController *recordVC = [[RecordDetailController alloc] init];
        recordVC.time = model.lotteryTime;
        [self.navigationController pushViewController:recordVC animated:YES];
    }else if ([model.status integerValue] == 0){
        LotteryListViewController *LotteryVC = [[LotteryListViewController alloc] init];
        LotteryVC.time = model.time;
        [self.navigationController pushViewController:LotteryVC animated:YES];
        
    }else if ([model.status integerValue] == 2){
        LotteryListViewController *LotteryVC = [[LotteryListViewController alloc] init];
        LotteryVC.time = model.time;
        [self.navigationController pushViewController:LotteryVC animated:YES];
    }
}

- (void)requestRule{
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
    [MineNetManager getLotteryRule:bodydic CompleteHandle:^(id resPonseObj, int code) {
        
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [self refreshRule:resPonseObj[@"data"]];
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
     
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager getLotterySession:nil CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"=====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                NSArray *dataArr = [LotteryModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                NSLog(@"dataArr: %@",dataArr);
                self.dataSource = dataArr;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // UI更新代码
                    [self refrshUI:dataArr];
                });

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


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
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
