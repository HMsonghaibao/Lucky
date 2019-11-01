//
//  InvitefriendsViewController.m
//  digitalCurrency
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "InviteDownloadViewController.h"
#import "invitefriendView.h"
#import "ruleofactivityController.h"
#import "MineNetManager.h"
@interface InviteDownloadViewController ()
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIButton *huodongBtn;
@property (weak, nonatomic) IBOutlet UILabel *codeL;
@property (weak, nonatomic) IBOutlet UILabel *descL;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *inviteL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) invitefriendView *invitefriendView;
@property (nonatomic, strong) UIView *maskTheView;
@property (nonatomic, strong) NSString *share_img;
@property (nonatomic, strong) NSString *share_title;
@property (nonatomic, strong) NSString *share_url;
@property (nonatomic, strong) NSString *share_content;
@property (nonatomic, strong) NSString *share_rule;
@end

@implementation InviteDownloadViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

/**
 *  遮盖
 */

- (UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskClickGesture)];
        [_maskTheView addGestureRecognizer:tap];//让header去检测点击手势
    }
    return _maskTheView;
    
}


-(invitefriendView*)invitefriendView{
    
    if (!_invitefriendView) {
        _invitefriendView=[invitefriendView loadinvitefriendView:^(NSInteger aa) {
            if(aa == 0){
                [self maskClickGesture];
            }else{
                NSMutableDictionary * shareParams = [NSMutableDictionary dictionary];
                SSDKPlatformType type;
                
                if(aa == 1){
                    [self maskClickGesture];
                    //微博
                    /*Share SDK http://www.mob.com/*/
                    type = SSDKPlatformTypeSinaWeibo;
                    [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@\n%@\n%@", self.share_title,self.share_content,self.share_url] images:self.share_img url:[NSURL URLWithString:self.share_url] title:self.share_title type:SSDKContentTypeAuto];
                }else if(aa == 2 ){
                    [self maskClickGesture];
                    //QQ
                    type = SSDKPlatformSubTypeQQFriend;
                    [shareParams SSDKSetupShareParamsByText:self.share_content images:self.share_img url:[NSURL URLWithString:self.share_url] title:self.share_title type:SSDKContentTypeAuto];
                }else if(aa==3){
                    [self maskClickGesture];
                    //朋友圈
                    type = SSDKPlatformSubTypeWechatTimeline;
                    [shareParams SSDKSetupShareParamsByText:self.share_content images:self.share_img url:[NSURL URLWithString:self.share_url] title:self.share_title type:SSDKContentTypeAuto];
                }else {
                    [self maskClickGesture];
                    //微信
                    type = SSDKPlatformSubTypeWechatSession;
                    [shareParams SSDKSetupShareParamsByText:self.share_content images:self.share_img url:[NSURL URLWithString:self.share_url] title:self.share_title type:SSDKContentTypeAuto];
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


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.inviteBtn setTitle:LocalizationKey(@"Invitingnow") forState:0];
    //[self.huodongBtn setTitle:[NSString stringWithFormat:@"  %@",LocalizationKey(@"Activityrules")] forState:0];
    
    self.inviteL.text = LocalizationKey(@"invitefriends");
    self.descL.text = LocalizationKey(@"incomearegiventoyou");
    
    [self getData];
    
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
-(void)getData{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:[YLUserInfo shareUserInfo].ID forKey:@"memberId"];
    
    NSLog(@"=====%@",bodydic);
    
    [MineNetManager getUserSigParam:nil CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
//                self.share_rule = resPonseObj[@"data"][@"share_rule"];
//                self.share_img = resPonseObj[@"data"][@"share_img"];
//                self.share_title = resPonseObj[@"data"][@"share_title"];
//                self.share_url = resPonseObj[@"data"][@"share_url"];
//                self.share_content = resPonseObj[@"data"][@"share_content"];
//                self.codeL.text = [NSString stringWithFormat:@"%@: %@",LocalizationKey(@"invite"),resPonseObj[@"data"][@"promotion_code"]];
//                [self.codeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HOST,@"uc/member/showPromotionCodeQr?codeUrl=",resPonseObj[@"data"][@"promotion_code"]]] placeholderImage:[UIImage imageNamed:@""]];
                
                
                // 1. 实例化二维码滤镜
                CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
                // 2. 恢复滤镜的默认属性
                [filter setDefaults];
                
                // 3. 将字符串转换成NSData
                NSString *urlStr = resPonseObj[@"data"];//测试二维码地址,次二维码不能支付,需要配合服务器来二维码的地址(跟后台人员配合)
                NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
                // 4. 通过KVO设置滤镜inputMessage数据
                [filter setValue:data forKey:@"inputMessage"];
                
                // 5. 获得滤镜输出的图像
                CIImage *outputImage = [filter outputImage];
                
                self.codeImage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];//重绘二维码,使其显示清晰
                
                
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


- (IBAction)inviteBtnClick:(UIButton *)sender {
//    UIWindow * window=[UIApplication sharedApplication].keyWindow;
//    [window addSubview:self.maskTheView];
//    [window addSubview:self.invitefriendView];
//    self.invitefriendView.frame=CGRectMake(0, kWindowH-134, kWindowW, 134);
}

- (IBAction)huodongBtnClick:(UIButton *)sender {
    //安全设置
    ruleofactivityController *accountVC = [[ruleofactivityController alloc] init];
    accountVC.share_rule = self.share_rule;
    [[AppDelegate sharedAppDelegate] pushViewController:accountVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
