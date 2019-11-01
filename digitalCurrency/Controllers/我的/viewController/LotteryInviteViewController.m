//
//  LotteryInviteViewController.m
//  digitalCurrency
//
//  Created by mac on 2019/6/21.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "LotteryInviteViewController.h"
#import "MineNetManager.h"
#import "WinningRecordDrewCell.h"
#import "WinningRecordModel.h"
#import "ScreenShotView.h"
@interface LotteryInviteViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *fourL;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UIImageView *luckImage;
@property (weak, nonatomic) IBOutlet UIImageView *qrdescImage;
@property (weak, nonatomic) IBOutlet UIImageView *QRimage;
@property (weak, nonatomic) IBOutlet UILabel *listL;
@property (weak, nonatomic) IBOutlet UILabel *recordNumL;
@property (weak, nonatomic) IBOutlet UILabel *totalL;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *newlistL;
@property (weak, nonatomic) IBOutlet UILabel *AdvantageL;
@property (weak, nonatomic) IBOutlet UILabel *buttonL1;
@property (weak, nonatomic) IBOutlet UILabel *buttonL2;
@property (weak, nonatomic) IBOutlet UILabel *buttonL3;
@property (weak, nonatomic) IBOutlet UILabel *ruleL;
@property (weak, nonatomic) IBOutlet UILabel *contextL;
@property (weak, nonatomic) IBOutlet UILabel *fiveL;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,assign)NSInteger pageNo;
@property (nonatomic, strong) ScreenShotView *invitefriendView;
@property (nonatomic, strong) UIImage *useImage;
@property (nonatomic, strong) UIView *maskTheView;
@end

@implementation LotteryInviteViewController


/**
 *  遮盖
 */

- (UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.8];
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskClickGesture)];
        [_maskTheView addGestureRecognizer:tap];//让header去检测点击手势
    }
    return _maskTheView;
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self requestRule];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WinningRecordDrewCell" bundle:nil] forCellReuseIdentifier:@"WinningRecordDrewCell"];
    
    self.pageNo = 1;
    
    [self getData];
    [self getTotalData];
    [self getQRData];
    [self getFiveData];
    
    [self languageSetting];
    
//    [self headRefreshWithScrollerView:self.tableView];
//    [self footRefreshWithScrollerView:self.tableView];
    
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:[[ChangeLanguage bundle] localizedStringForKey:@"Thereisnodataforthetimebeing" value:nil table:@"English"]];
    self.tableView.ly_emptyView = emptyView;
    
    
    [self rightBarItemWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"Sharenow" value:nil table:@"English"]];
    
    
    NSString *testStr = [NSString stringWithFormat:@"%@ %@",[YLUserInfo shareUserInfo].userName,LocalizationKey(@"Inviteyoutodrawalottery")];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:testStr];
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        self.luckImage.image = [UIImage imageNamed:@"Luckydraw-s"];
        self.qrdescImage.image = [UIImage imageNamed:@"Identification-s"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:253/255.0 green:175/255.0 blue:96/255.0 alpha:1.0] range:NSMakeRange(0,testStr.length - 30)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,testStr.length - 30)];
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        self.luckImage.image = [UIImage imageNamed:@"Luckydraw"];
        self.qrdescImage.image = [UIImage imageNamed:@"Identification"];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:253/255.0 green:175/255.0 blue:96/255.0 alpha:1.0] range:NSMakeRange(0,testStr.length - 8)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0,testStr.length - 8)];
    }
    self.nameL.attributedText = str;
    
    self.fourL.text = LocalizationKey(@"nolimitontheamounttttt");
    self.listL.text = LocalizationKey(@"Winningrecordttt");
    self.newlistL.text = LocalizationKey(@"Latestrecord");
    self.AdvantageL.text = LocalizationKey(@"Luckydrawadvantage");
    self.buttonL1.text = LocalizationKey(@"Nolimitontheamountofwinning");
    self.buttonL2.text = LocalizationKey(@"Bigbonuseveryday");
    self.buttonL3.text = LocalizationKey(@"Extrabonusisnotstopped");
    self.ruleL.text = LocalizationKey(@"Winningrules");
}


//MARK:--明细的点击事件
-(void)RighttouchEvent{
    UIImage*image = [self screenshotForView:self.scrollView];
    UIWindow * window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self.maskTheView];
    [window addSubview:self.invitefriendView];
    self.invitefriendView.frame=self.view.bounds;
    self.invitefriendView.imageView.image = image;
    
//    self.useImage = [self compressImage:image toByte:50*1024];
//    NSData*imageData = [self resetSizeOfImageData:image maxSize:4*1024];
    NSData*imageData = [self resetSizeOfImageData:image maxSize:200];
    self.useImage = [UIImage imageWithData:imageData];
    NSLog(@"====%@===",self.useImage);
    NSLog(@"====%@===",self.useImage);
}



- (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;

    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;

    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }

    return resultImage;
}



- (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize {

    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage, 1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;

    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }

    //获取原图片宽高比
    CGFloat sourceImageAspectRatio = sourceImage.size.width / sourceImage.size.height;
    //先调整分辨率
    CGSize defaultSize = CGSizeMake(1024, 1024 / sourceImageAspectRatio);
    UIImage * newImage = [self newSizeImage:defaultSize image:sourceImage];
    finallImageData    = UIImageJPEGRepresentation(newImage, 1.0);

    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0 / 250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i --) {
        value = i * avg;
        [compressionQualityArr addObject:@(value)];
    }

    /*
     调整大小
     说明：压缩系数数组compressionQualityArr是从大到小存储。
     */
    //思路：使用二分法搜索
    finallImageData = [self halfFuntion:compressionQualityArr image:newImage sourceData:finallImageData maxSize:maxSize];
    //如果还是未能压缩到指定大小，则进行降分辨率
    while (finallImageData.length == 0) {
        //每次降100分辨率
        CGFloat reduceWidth  = 100.0;
        CGFloat reduceHeight = 100.0 / sourceImageAspectRatio;
        if (defaultSize.width - reduceWidth <= 0 || defaultSize.height - reduceHeight <= 0) {
            break;
        }
        defaultSize = CGSizeMake(defaultSize.width - reduceWidth, defaultSize.height - reduceHeight);
        UIImage *image = [self newSizeImage:defaultSize
                                      image:[UIImage imageWithData:UIImageJPEGRepresentation(newImage, [[compressionQualityArr lastObject] floatValue])]];
        finallImageData = [self halfFuntion:compressionQualityArr image:image sourceData:UIImageJPEGRepresentation(image,1.0) maxSize:maxSize];
    }
    return finallImageData;
}



#pragma mark 调整图片分辨率/尺寸（等比例缩放）
- (UIImage *)newSizeImage:(CGSize)size image:(UIImage *)sourceImage {

    CGSize newSize     = CGSizeMake(sourceImage.size.width, sourceImage.size.height);
    CGFloat tempHeight = newSize.height / size.height;
    CGFloat tempWidth  = newSize.width / size.width;

    if (tempWidth > 1.0 && tempWidth > tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempWidth, sourceImage.size.height / tempWidth);
    } else if (tempHeight > 1.0 && tempWidth < tempHeight) {
        newSize = CGSizeMake(sourceImage.size.width / tempHeight, sourceImage.size.height / tempHeight);
    }

    UIGraphicsBeginImageContext(newSize);
    [sourceImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark 二分法
- (NSData *)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize {

    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end   = arr.count - 1;
    NSUInteger index = 0;
    NSUInteger difference = NSIntegerMax;

    while(start <= end) {
        index = start + (end - start) / 2;
        finallImageData = UIImageJPEGRepresentation(image, [arr[index] floatValue]);
        NSUInteger sizeOrigin   = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1024;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        NSLog(@"\nstart：%zd\nend：%zd\nindex：%zd\n压缩系数：%lf", start, end, (unsigned long)index, [arr[index] floatValue]);

        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize - sizeOriginKB < difference) {
                difference = maxSize - sizeOriginKB;
                tempData   = finallImageData;
            }
            if (index <= 0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    return tempData;
}



/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


//MARK:--获取数据
-(void)getQRData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryInviteInfoParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                
                // 1. 实例化二维码滤镜
                CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
                // 2. 恢复滤镜的默认属性
                [filter setDefaults];
                
                // 3. 将字符串转换成NSData
                NSString *urlStr = resPonseObj[@"data"][@"share_url"];//测试二维码地址,次二维码不能支付,需要配合服务器来二维码的地址(跟后台人员配合)
                NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
                // 4. 通过KVO设置滤镜inputMessage数据
                [filter setValue:data forKey:@"inputMessage"];
                
                // 5. 获得滤镜输出的图像
                CIImage *outputImage = [filter outputImage];
                
                self.QRimage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:156];//重绘二维码,使其显示清晰
                
                
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


-(ScreenShotView*)invitefriendView{
    
    if (!_invitefriendView) {
        _invitefriendView=[ScreenShotView loadScreenShotView:^(NSInteger aa) {
            if(aa == 4){
                [self maskClickGesture];
            }else{
                NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
                SSDKPlatformType type;
                
                if(aa == 0){
                    [self maskClickGesture];
                    //微博
                    /*Share SDK http://www.mob.com/*/
                    type = SSDKPlatformTypeSinaWeibo;
                    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@", @"",@"",@""] images:self.useImage url:[NSURL URLWithString:@""] title:@"" type:SSDKContentTypeImage];
                }else if(aa == 1 ){
                    [self maskClickGesture];
                    //QQ
                    type = SSDKPlatformSubTypeQQFriend;
                    [shareParams SSDKSetupShareParamsByText:@"" images:self.useImage url:[NSURL URLWithString:@""] title:@"" type:SSDKContentTypeImage];
                }else if(aa==2){
                    [self maskClickGesture];
                    //朋友圈
                    type = SSDKPlatformSubTypeWechatTimeline;
                    [shareParams SSDKSetupShareParamsByText:@"" images:self.useImage url:[NSURL URLWithString:@""] title:@"" type:SSDKContentTypeImage];
                }else {
                    [self maskClickGesture];
                    //微信
                    type = SSDKPlatformSubTypeWechatSession;
                    [shareParams SSDKSetupShareParamsByText:@"" images:self.useImage url:[NSURL URLWithString:@""] title:@"" type:SSDKContentTypeImage];
                }
                
                [ShareSDK share:type parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                    
                    switch (state) {
                            
                        case SSDKResponseStateSuccess: {
                            //[self.view makeToast:@"分享成功" duration:1.5 position:CSToastPositionCenter];
                        } break;
                            
                        case SSDKResponseStateFail: {
                            [self.view makeToast:@"分享失败" duration:1.5 position:CSToastPositionCenter];
                        } break;
                            
                        case SSDKResponseStateCancel: {
                            //[self.view makeToast:@"分享已取消" duration:1.5 position:CSToastPositionCenter];
                        } break;
                        default: break;
                    }
                }];
            }
            
        }];
        
        
    }
    return _invitefriendView;
}


- (void)maskClickGesture{
    [self.maskTheView removeFromSuperview];
    [self.invitefriendView removeFromSuperview];
    self.maskTheView=nil;
    self.invitefriendView=nil;
}


//根据一个View生成一个image
- (UIImage *)screenshotForView:(UIView *)view {
    UIImage *image = nil;
    //判断View类型（一般不是滚动视图或者其子类的话内容不会超过一屏，当然如果超过了也可以通过修改frame来实现绘制）
    if ([view.class isSubclassOfClass:[UIScrollView class]]) {
        UIScrollView *scrView = (UIScrollView *)view;
        
        CGPoint tempContentOffset = scrView.contentOffset;
        CGRect tempFrame = scrView.frame;
        
        scrView.contentOffset = CGPointZero;
        scrView.frame = CGRectMake(0, 0, scrView.contentSize.width, scrView.contentSize.height);
        
        image = [self screenshotForView:scrView size:scrView.frame.size];
        
        scrView.contentOffset = tempContentOffset;
        scrView.frame = tempFrame;
        
    } else {
        image = [self screenshotForView:view size:view.frame.size];
    }
    
    return image;
}

- (UIImage *)screenshotForView:(UIView *)view size:(CGSize)size {
    UIImage *image = nil;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}


//MARK:--上拉加载
- (void)refreshFooterAction{
    self.pageNo++;
    [self getData];
}
//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 1;
    [self getData];
}


//MARK:--国际化通知处理事件
- (void)languageSetting{
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"no" titleStr:LocalizationKey(@"noDada")];
    self.tableView.ly_emptyView = emptyView;
}


//MARK:--获取抽奖统计总数
-(void)getFiveData{
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [MineNetManager getTotalLotteryMoneyInfoParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
                    self.fiveL.text = [NSString stringWithFormat:@"%@ %.2f NBTC %@",LocalizationKey(@"valueof"),[resPonseObj[@"data"][@"surplus"] doubleValue],LocalizationKey(@"cometothewool")];
                }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
                {
                    self.fiveL.text = [NSString stringWithFormat:@"%@%.2f的牛特币%@",LocalizationKey(@"valueof"),[resPonseObj[@"data"][@"surplus"] doubleValue],LocalizationKey(@"cometothewool")];
                }
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
-(void)getTotalData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"0" forKey:@"rewardType"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getMemberTotalRewardMoneyParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                self.recordNumL.text = resPonseObj[@"data"][@"totalMoney"];
                self.recordNumL.text = [NSString stringWithFormat:@"%.2f",[resPonseObj[@"data"][@"totalMoney"] floatValue]];
                self.totalL.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Cumulativewinningamount"),resPonseObj[@"data"][@"coinId"]];
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
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:pageNoStr forKey:@"pageNo"];
    [bodydic setValue:@"10" forKey:@"pageSize"];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    [bodydic setValue:@"0" forKey:@"rewardType"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager queryMemberLotteryRecordListParam:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (_pageNo == 1) {
                    [_contentArr removeAllObjects];
                }
                
                NSArray *dataArr = [WinningRecordModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.contentArr addObjectsFromArray:dataArr];
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


- (void)refreshRule:(NSString *)rule{
    
    self.contextL.text = rule;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:rule];
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineSpacing = 4;
    [attr addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, rule.length)];

    self.contextL.attributedText = attr;


}



#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WinningRecordDrewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WinningRecordDrewCell" forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    WinningRecordModel *model;
    model = self.contentArr[indexPath.row];
    cell.timeL.text = [NSString stringWithFormat:@"%@%@(%@)",model.time,LocalizationKey(@"Session"),model.lotteryDate];
    cell.timeRecordL.text = [NSString stringWithFormat:@"%@: %@",LocalizationKey(@"Lotterytime"),model.time];
    //cell.moneyL.text = [NSString stringWithFormat:@"+%@ %@",model.money,model.coinId];
    cell.moneyL.text = [NSString stringWithFormat:@"+%@ %@",[NSString stringWithFormat:@"%.2f",[model.money floatValue]],model.coinId];
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
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
