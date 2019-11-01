//
//  RecordDetailController.m
//  digitalCurrency
//
//  Created by mac on 2019/6/15.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "RecordDetailController.h"
#import "CountDown.h"
#import "UIView+ArrangeSubview.h"
@interface RecordDetailController ()
@property (weak, nonatomic) IBOutlet UILabel *hourL2;
@property (weak, nonatomic) IBOutlet UILabel *minL2;
@property (weak, nonatomic) IBOutlet UILabel *secondL;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeL;
@property (weak, nonatomic) IBOutlet UILabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *listL;
@property (weak, nonatomic) IBOutlet UILabel *nogetL;
@property (strong, nonatomic)  CountDown *countDownForLabel;
@property (weak, nonatomic) IBOutlet UILabel *hL;
@property (weak, nonatomic) IBOutlet UILabel *mL;
@property (weak, nonatomic) IBOutlet UILabel *sL;



@end

@implementation RecordDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = LocalizationKey(@"Lotterydetails");
    self.recordTimeL.text = LocalizationKey(@"Lotterytime");
    self.countL.text = LocalizationKey(@"Countdown");
    self.nogetL.text = LocalizationKey(@"Notyetawarded");
    self.listL.text = LocalizationKey(@"Lotteryleaderboard");
    self.hL.text = LocalizationKey(@"hour");
    self.mL.text = LocalizationKey(@"mmin");
    self.sL.text = LocalizationKey(@"sec");
    _countDownForLabel = [[CountDown alloc] init];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone localTimeZone];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:self.time]; //------------将字符串按formatter转成nsdate    //时间转时间戳的方法:
    NSString*dateTime = [formatter stringFromDate:date];
    NSTimeInterval a=[date timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f000", a];//转为字符型
    long long finishLongLong1 = [timeString longLongValue];
    

    
    long long startLongLong1 = [self getCurrentTimestamp];
    
    NSLog(@"当前时间是===%@===%lld===%lld",dateTime,startLongLong1,finishLongLong1);
    
    ///方法一倒计时测试
//    long long startLongLong = 1560737411000;
//    long long finishLongLong = 1560741113000;
    [self startLongLongStartStamp:startLongLong1 longlongFinishStamp:finishLongLong1];
    
    
    
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
        self.hourL2.text = @"00";
    }else{
        if (hour<10&&hour) {
            self.hourL2.text = [NSString stringWithFormat:@"0%ld",(long)hour];
        }else{
            self.hourL2.text = [NSString stringWithFormat:@"%ld",(long)hour];
        }
    }
    
    if (minute==0) {
        self.minL2.text = @"00";
    }else{
        if (minute<10) {
            self.minL2.text = [NSString stringWithFormat:@"0%ld",(long)minute];
        }else{
            self.minL2.text = [NSString stringWithFormat:@"%ld",(long)minute];
        }
    }
    
    if (second==0) {
        self.secondL.text = @"00";
    }else{
        if (second<10) {
            self.secondL.text = [NSString stringWithFormat:@"0%ld",(long)second];
        }else{
            self.secondL.text = [NSString stringWithFormat:@"%ld",(long)second];
        }
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    [_countDownForLabel destoryTimer];
    NSLog(@"%s dealloc",object_getClassName(self));
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
