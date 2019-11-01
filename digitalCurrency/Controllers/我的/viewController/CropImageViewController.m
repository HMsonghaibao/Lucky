//
//  CropImageViewController.m
//  digitalCurrency
//
//  Created by mac on 2019/8/6.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "CropImageViewController.h"
#import "JPImageresizerView.h"
@interface CropImageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *xuanzhuanBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic, weak) JPImageresizerView *imageresizerView;
@end

@implementation CropImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(50, 0, (40 + 30 + 30 + 10), 0);
    BOOL isX = [UIScreen mainScreen].bounds.size.height > 736.0;
    if (isX) {
        contentInsets.top += 24;
        contentInsets.bottom += 34;
    }
    
    JPImageresizerConfigure *configure1 = [JPImageresizerConfigure defaultConfigureWithResizeImage:self.image make:^(JPImageresizerConfigure *configure) {
        configure.jp_contentInsets(contentInsets);
//        configure.jp_isClockwiseRotation(YES);
//        configure.jp_resizeWHScale(16.0 / 9.0);
        
    }];
    
    __weak typeof(self) wSelf = self;
    JPImageresizerView *imageresizerView = [JPImageresizerView imageresizerViewWithConfigure:configure1 imageresizerIsCanRecovery:^(BOOL isCanRecovery) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当不需要重置设置按钮不可点
//        sSelf.recoveryBtn.enabled = isCanRecovery;
    } imageresizerIsPrepareToScale:^(BOOL isPrepareToScale) {
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;
        // 当预备缩放设置按钮不可点，结束后可点击
        BOOL enabled = !isPrepareToScale;
//        sSelf.rotateBtn.enabled = enabled;
//        sSelf.resizeBtn.enabled = enabled;
//        sSelf.horMirrorBtn.enabled = enabled;
//        sSelf.verMirrorBtn.enabled = enabled;
    }];
    [self.view insertSubview:imageresizerView atIndex:0];
    self.imageresizerView = imageresizerView;
//    [self.imageresizerView setResizeWHScale:16.0/9.0 isToBeArbitrarily:YES animated:YES];
    [self.imageresizerView rotation];
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)xuanzhuanBtnClick:(UIButton *)sender {
    [self.imageresizerView rotation];
}
- (IBAction)saveBtnClick:(UIButton *)sender {
    __weak typeof(self) wSelf = self;
    
    // 1.自定义压缩比例进行裁剪
//    [self.imageresizerView imageresizerWithComplete:^(UIImage *resizeImage) {
//        __strong typeof(wSelf) sSelf = wSelf;
//        if (!sSelf) return;
//
//        if (!resizeImage) {
//            NSLog(@"没有裁剪图片");
//            return;
//        }
//
//        [self dismissViewControllerAnimated:YES completion:nil];
//        if (self.cropSucess) {
//            self.cropSucess(resizeImage);
//        }
//
//    } scale:0.3];
    
    
     //2.以原图尺寸进行裁剪
    [self.imageresizerView originImageresizerWithComplete:^(UIImage *resizeImage) {
        // 裁剪完成，resizeImage为裁剪后的图片
        // 注意循环引用
        __strong typeof(wSelf) sSelf = wSelf;
        if (!sSelf) return;

        if (!resizeImage) {
            NSLog(@"没有裁剪图片");
            return;
        }

        if (self.cropSucess) {
            self.cropSucess(resizeImage);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
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
