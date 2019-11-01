//
//  DetectionViewController.m
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "DetectionViewController.h"
#import <IDLFaceSDK/IDLFaceSDK.h>
#import <AVFoundation/AVFoundation.h>

@interface DetectionViewController ()
{
}

@property (nonatomic, readwrite, retain) UIView *animaView;
@end

@implementation DetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 纯粹为了在照片成功之后，做闪屏幕动画之用
    self.animaView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.animaView.backgroundColor = [UIColor whiteColor];
    self.animaView.alpha = 0;
    [self.view addSubview:self.animaView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[IDLFaceDetectionManager sharedInstance] startInitial];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [IDLFaceDetectionManager.sharedInstance reset];
}

- (void)onAppWillResignAction {
    [super onAppWillResignAction];
    [IDLFaceDetectionManager.sharedInstance reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)faceProcesss:(UIImage *)image {
    if (self.hasFinished) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    /*
     *不论带不带黑边，取图片都是：images[@"bestImage"]
     */
    //带黑边的方法
    [[IDLFaceDetectionManager sharedInstance]detectStratrgyWithQualityControlImage:image previewRect:self.previewRect detectRect:self.detectRect completionHandler:^(FaceInfo *faceinfo, NSDictionary *images, DetectRemindCode remindCode) {
        switch (remindCode) {
            case DetectRemindCodeOK: {
                weakSelf.hasFinished = YES;
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verygood")];
                NSArray*arr = images[@"bestImage"];
                if (arr != nil && arr.count != 0) {
                    NSData* data = [[NSData alloc] initWithBase64EncodedString:[images[@"bestImage"] lastObject] options:NSDataBase64DecodingIgnoreUnknownCharacters];
                    UIImage* bestImage = [UIImage imageWithData:data];
                    NSLog(@"bestImage = %@",bestImage);
                    if (self.cropSucess) {
                        self.cropSucess(bestImage);
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.5 animations:^{
                        weakSelf.animaView.alpha = 1;
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            weakSelf.animaView.alpha = 0;
                        } completion:^(BOOL finished) {
                            [weakSelf closeAction];
                        }];
                    }];
                });
                [self singleActionSuccess:true];
                break;
            }
            case DetectRemindCodePitchOutofDownRange:
                [self warningStatus:PoseStatus warning:LocalizationKey(@"Itisrecommendedtoraiseslightly")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodePitchOutofUpRange:
                [self warningStatus:PoseStatus warning:LocalizationKey(@"Itisrecommendedtobowslightly")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeYawOutofLeftRange:
                [self warningStatus:PoseStatus warning:LocalizationKey(@"Itisrecommendedtoturnslightlytotheright")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeYawOutofRightRange:
                [self warningStatus:PoseStatus warning:LocalizationKey(@"Itisrecommendedtoturnslightlytotheleft")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodePoorIllumination:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"Lightagain")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeNoFaceDetected:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"Movethefaceintothebox")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeImageBlured:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"Pleasestaystill")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionLeftEye:
                [self warningStatus:occlusionStatus warning:LocalizationKey(@"Lefteyehasocclusion")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionRightEye:
                [self warningStatus:occlusionStatus warning:LocalizationKey(@"Therighteyeisoccluded")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionNose:
                [self warningStatus:occlusionStatus warning:LocalizationKey(@"Noisynose")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionMouth:
                [self warningStatus:occlusionStatus warning:LocalizationKey(@"Mouthblocked")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionLeftContour:
                [self warningStatus:occlusionStatus warning:LocalizationKey(@"Leftcheekhasocclusion")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionRightContour:
                [self warningStatus:occlusionStatus warning:LocalizationKey(@"Therightcheekisoccluded")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeOcclusionChinCoutour:
                [self warningStatus:occlusionStatus warning:LocalizationKey(@"Thereisocclusioninthelowerjaw")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeTooClose:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"Takealittlelonger")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeTooFar:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"Takeacloserlookatthephone")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeBeyondPreviewFrame:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"Movethefaceintothebox")];
                [self singleActionSuccess:false];
                break;
            case DetectRemindCodeVerifyInitError:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeVerifyDecryptError:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeVerifyInfoFormatError:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeVerifyExpired:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeVerifyMissRequiredInfo:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeVerifyInfoCheckError:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeVerifyLocalFileError:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeVerifyRemoteDataError:
                [self warningStatus:CommonStatus warning:LocalizationKey(@"verificationfailed")];
                break;
            case DetectRemindCodeTimeout: {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController* alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"remindttt") message:LocalizationKey(@"timeoutttt") preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* action = [UIAlertAction actionWithTitle:LocalizationKey(@"Knowit") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        NSLog(@"知道啦");
                    }];
                    [alert addAction:action];
                    UIViewController* fatherViewController = weakSelf.presentingViewController;
                    [weakSelf dismissViewControllerAnimated:YES completion:^{
                        [fatherViewController presentViewController:alert animated:YES completion:nil];
                    }];
                });
                break;
            }
            case DetectRemindCodeConditionMeet: {
                self.circleView.conditionStatusFit = true;
            }
                break;
            default:
                break;
        }
        if (remindCode == DetectRemindCodeConditionMeet || remindCode == DetectRemindCodeOK) {
            self.circleView.conditionStatusFit = true;
        }else {
            self.circleView.conditionStatusFit = false;
        }
    }];
}

- (void)dealloc
{
    
}
@end
