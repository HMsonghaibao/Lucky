//
//  UpdateIDCardViewController.m
//  digitalCurrency
//
//  Created by chu on 2018/8/9.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UpdatePassIDCardViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "TZImagePickerController.h"
#import "TZImageUploadOperation.h"
#import "TZLocationManager.h"
@interface UpdatePassIDCardViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger btnTag;

//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
//返回的图片路径数组
@property (nonatomic,strong) NSMutableDictionary *imageDic;

@property (nonatomic, strong) NSMutableArray *btnsArr;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

@implementation UpdatePassIDCardViewController

- (NSMutableArray *)btnsArr{
    if (!_btnsArr) {
        _btnsArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _btnsArr;
}

- (NSMutableDictionary *)imageDic{
    if (!_imageDic) {
        _imageDic = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return _imageDic;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (@available(iOS 9, *)) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
        
    }
    return _imagePickerVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = mainColor;
    self.title = LocalizationKey(@"Realnameauthentication");
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 44);
    [btn setTitle:LocalizationKey(@"save") forState:UIControlStateNormal];
    [btn setTitleColor:RGBOF(0xF0A70A) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*item=[[UIBarButtonItem alloc] initWithCustomView:btn];

    self.navigationItem.rightBarButtonItem = item;

    [self.view addSubview:self.scrollView];
    [self creatUI];
}

-(void)RighttouchEvent{
    if (self.imageDic.count < 1) {
        __weak typeof(self)weakself = self;
        [self addUIAlertControlWithString:@"您的照片没上传完，确定保存吗？" withActionBlock:^{
            [[AppDelegate sharedAppDelegate] popViewController];
            weakself.block(weakself.imageDic);
        } andCancel:^{
            
        }];
    }else{
        [[AppDelegate sharedAppDelegate] popViewController];
        if (self.block) {
            self.block(self.imageDic);
        }
    }
}


//判断是否有相机权限
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        // 无相机权限 做一个友好的提示
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhoto];
                });
            }
        }];
        // 拍照之前还需要检查相册权限
    } else if ([PHPhotoLibrary authorizationStatus] == 2) { // 已被拒绝，没有相册权限，将无法保存拍的照片
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alert show];
    } else if ([PHPhotoLibrary authorizationStatus] == 0) { // 未请求过相册权限
        [[TZImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    } else {
        [self pushImagePickerController];
    }
}


// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[TZLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        NSMutableArray *mediaTypes = [NSMutableArray array];
        [mediaTypes addObject:(NSString *)kUTTypeImage];
        if (mediaTypes.count) {
            _imagePickerVc.mediaTypes = mediaTypes;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}


- (void)pushTZImagePickerController {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 columnNumber:4 delegate:self pushPhotoPickerVc:YES];
    // imagePickerVc.navigationBar.translucent = NO;
    
#pragma mark - 五类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = YES;
    imagePickerVc.allowTakePicture = NO;
    imagePickerVc.allowTakeVideo = NO;
    
    //     imagePickerVc.photoWidth = 1600;
    
    // 2. Set the appearance
    // 2. 在这里设置imagePickerVc的外观
    imagePickerVc.navigationBar.barTintColor = mainColor;
    imagePickerVc.oKButtonTitleColorDisabled = [UIColor lightGrayColor];
    imagePickerVc.oKButtonTitleColorNormal = [UIColor greenColor];
    imagePickerVc.navigationBar.translucent = NO;
    imagePickerVc.iconThemeColor = [UIColor colorWithRed:31 / 255.0 green:185 / 255.0 blue:34 / 255.0 alpha:1.0];
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.cannotSelectLayerColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [imagePickerVc setPhotoPickerPageUIConfigBlock:^(UICollectionView *collectionView, UIView *bottomToolBar, UIButton *previewButton, UIButton *originalPhotoButton, UILabel *originalPhotoLabel, UIButton *doneButton, UIImageView *numberImageView, UILabel *numberLabel, UIView *divideLine) {
        [doneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }];
    /*
     [imagePickerVc setAssetCellDidSetModelBlock:^(TZAssetCell *cell, UIImageView *imageView, UIImageView *selectImageView, UILabel *indexLabel, UIView *bottomView, UILabel *timeLength, UIImageView *videoImgView) {
     cell.contentView.clipsToBounds = YES;
     cell.contentView.layer.cornerRadius = cell.contentView.tz_width * 0.5;
     }];
     */
    
    // 3. Set allow picking video & photo & originalPhoto or not
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = YES;
    imagePickerVc.allowPickingGif = NO;
    imagePickerVc.allowPickingMultipleVideo = NO; // 是否可以多选视频
    //
    //    // 4. 照片排列按修改时间升序
    //    imagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
    
    // imagePickerVc.minImagesCount = 3;
    // imagePickerVc.alwaysEnableDoneBtn = YES;
    
    // imagePickerVc.minPhotoWidthSelectable = 3000;
    // imagePickerVc.minPhotoHeightSelectable = 2000;
    
    /// 5. Single selection mode, valid when maxImagesCount = 1
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = YES;
    //    imagePickerVc.needCircleCrop = YES;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 0;
    NSInteger widthHeight = SCREEN_WIDTH_S - 2 * left;
    NSInteger top = (SCREEN_HEIGHT_S - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.scaleAspectFillCrop = YES;
    // 设置横屏下的裁剪尺寸
    // imagePickerVc.cropRectLandscape = CGRectMake((self.view.tz_height - widthHeight) / 2, left, widthHeight, widthHeight);
    /*
     [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
     cropView.layer.borderColor = [UIColor redColor].CGColor;
     cropView.layer.borderWidth = 2.0;
     }];*/
    
    //imagePickerVc.allowPreview = NO;
    // 自定义导航栏上的返回按钮
    /*
     [imagePickerVc setNavLeftBarButtonSettingBlock:^(UIButton *leftButton){
     [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
     [leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
     }];
     imagePickerVc.delegate = self;
     */
    
    // Deprecated, Use statusBarStyle
    // imagePickerVc.isStatusBarDefault = NO;
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 设置是否显示图片序号
    //    imagePickerVc.showSelectedIndex = self.showSelectedIndexSwitch.isOn;
    
    
    
    // 设置首选语言 / Set preferred language
    // imagePickerVc.preferredLanguage = @"zh-Hans";
    
    // 设置languageBundle以使用其它语言 / Set languageBundle to use other language
    // imagePickerVc.languageBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"tz-ru" ofType:@"lproj"]];
    
#pragma mark - 到这里为止
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [self updateSelectImage:photos.firstObject];
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


-(void)updateSelectImage:(UIImage*)headImage{
    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
    //将图片上传到服务器
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadingHeadPhoto" value:nil table:@"English"]];
    NSString *str=@"uc/upload/oss/image";
    NSString *urlString=[HOST stringByAppendingString:str];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *dic = [NSMutableDictionary new];
    dic[@"x-auth-token"] = [YLUserInfo shareUserInfo].token;
    dic[@"Content-Type"] = @"application/x-www-form-urlencoded";
    NSLog(@"===%@",dic);
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *imageDatas = imageData;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageDatas
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"===%@",responseObject);
        //上传成功
        if ([responseObject[@"code"] integerValue] == 0) {
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureSuccess" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
            UIButton *btn = [self.view viewWithTag:self.btnTag];
            btn.userInteractionEnabled = YES;
            if (self.btnTag == 11) {
                [self.imageDic setObject:responseObject[@"data"] forKey:@"idCardFront"];
                UIButton *btn = self.btnsArr[0];
                [btn setImage:headImage forState:UIControlStateNormal];
            }
            if (self.btnTag == 22) {
                [self.imageDic setObject:responseObject[@"data"] forKey:@"idCardBack"];
                UIButton *btn = self.btnsArr[1];
                [btn setImage:headImage forState:UIControlStateNormal];
            }
            if (self.btnTag == 33) {
                [self.imageDic setObject:responseObject[@"data"] forKey:@"handHeldIdCard"];
                UIButton *btn = self.btnsArr[2];
                [btn setImage:headImage forState:UIControlStateNormal];
            }
        }else if([responseObject[@"code"] integerValue] == 4000) {
            [ShowLoGinVC showLoginVc:self withTipMessage:responseObject[MESSAGE]];
        }else{
            [self.view makeToast:responseObject[MESSAGE] duration:1.5 position:CSToastPositionCenter];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [EasyShowLodingView hidenLoding];
        //上传失败
        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureFailure" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)refreshCollectionViewWithAddedAsset:(PHAsset *)asset image:(UIImage *)image {
    [self updateSelectImage:image];
    
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}


//MARK:--添加头像
-(void)changeHeaderImage{
    __block NSUInteger sourceType = 0;
    [LEEAlert actionsheet].config
//    .LeeAddTitle(^(UILabel *label) {
//        label.text = [[ChangeLanguage bundle] localizedStringForKey:@"projectNameTip" value:nil table:@"English"];
//        label.textColor = RGBOF(0xe6e6e6);
//        label.backgroundColor = mainColor;
//    })
//    .LeeAddContent(^(UILabel *label){
//        label.text = LocalizationKey(@"certifyTakePhotoTip");
//        label.textColor = RGBOF(0xe6e6e6);
//        label.backgroundColor = mainColor;
//    })
    .LeeHeaderColor(mainColor)
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"takingPictures" value:nil table:@"English"];
        action.backgroundColor = mainColor;
        action.titleColor = RGBOF(0xe6e6e6);
        action.borderColor = RGBCOLOR(18, 22, 28);
        action.clickBlock = ^{
            //判断是否已授权
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//                AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//                if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
//                    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"cameraPermissionsTips" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
//                    return ;
//                }
//            }
//            sourceType = UIImagePickerControllerSourceTypeCamera;
//            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                [self chooseImage:sourceType];
//            }else{
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"tips" value:nil table:@"English"] message:[[ChangeLanguage bundle] localizedStringForKey:@"unSupportTakePhoto" value:nil table:@"English"] preferredStyle:UIAlertControllerStyleAlert];
//                [alert addAction:[UIAlertAction actionWithTitle:[[ChangeLanguage bundle] localizedStringForKey:@"ok" value:nil table:@"English"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                }]];
//                [self presentViewController:alert animated:YES completion:nil];
//            }
            
            
            [self takePhoto];
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"photoAlbumSelect" value:nil table:@"English"];
        action.backgroundColor = mainColor;
        action.titleColor = RGBOF(0xe6e6e6);
        action.borderColor = RGBCOLOR(18, 22, 28);
        action.clickBlock = ^{
            //判断是否已授权
//            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//
//                ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
//                if (authStatus == ALAuthorizationStatusDenied) {
//                    [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"cameraPermissionsTips" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
//                    return;
//                }
//            }
//            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//            [self chooseImage:sourceType];
            
            
            [self pushTZImagePickerController];
        };
    }).LeeAddAction(^(LEEAction *action){
        action.type = LEEActionTypeCancel;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"cancel" value:nil table:@"English"];
        action.titleColor = RGBOF(0xe6e6e6);
        action.backgroundColor = mainColor;
    })
    .LeeShow();
    
    
}
//从本地选择照片（拍照或从相册选择）
-(void)chooseImage:(NSInteger)sourceType
{
    //创建对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerVC = imagePickerController;
    //设置代理
    imagePickerController.delegate = self;
    //是否允许图片进行编辑
    imagePickerController.allowsEditing = YES;
    //选择图片还是开启相机
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController代理 已经选择了图片,上传到服务器中,返回上传结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //选择图片
//    UIImage *headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
//    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
//    //将图片上传到服务器
//    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadingHeadPhoto" value:nil table:@"English"]];
//    NSString *str=@"uc/upload/oss/image";
//    NSString *urlString=[HOST stringByAppendingString:str];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSMutableDictionary *dic = [NSMutableDictionary new];
//    dic[@"x-auth-token"] = [YLUserInfo shareUserInfo].token;
//    dic[@"Content-Type"] = @"application/x-www-form-urlencoded";
//    NSLog(@"===%@",dic);
//    //接收类型不一致请替换一致text/html或别的
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
//                                                         @"text/html",
//                                                         @"image/jpeg",
//                                                         @"image/png",
//                                                         @"application/octet-stream",
//                                                         @"text/json",
//                                                         nil];
//    [manager POST:urlString parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSData *imageDatas = imageData;
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        //上传的参数(上传图片，以文件流的格式)
//        [formData appendPartWithFileData:imageDatas
//                                    name:@"file"
//                                fileName:fileName
//                                mimeType:@"image/jpeg"];
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        //打印下上传进度
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [EasyShowLodingView hidenLoding];
//        NSLog(@"===%@",responseObject);
//        //上传成功
//        if ([responseObject[@"code"] integerValue] == 0) {
//            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureSuccess" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
//            UIButton *btn = [self.view viewWithTag:self.btnTag];
//            btn.userInteractionEnabled = YES;
//            if (self.btnTag == 11) {
//                [self.imageDic setObject:responseObject[@"data"] forKey:@"idCardFront"];
//                UIButton *btn = self.btnsArr[0];
//                [btn setImage:headImage forState:UIControlStateNormal];
//            }
//            if (self.btnTag == 22) {
//                [self.imageDic setObject:responseObject[@"data"] forKey:@"idCardBack"];
//                UIButton *btn = self.btnsArr[1];
//                [btn setImage:headImage forState:UIControlStateNormal];
//            }
//            if (self.btnTag == 33) {
//                [self.imageDic setObject:responseObject[@"data"] forKey:@"handHeldIdCard"];
//                UIButton *btn = self.btnsArr[2];
//                [btn setImage:headImage forState:UIControlStateNormal];
//            }
//        }else if([responseObject[@"code"] integerValue] == 4000) {
//            [ShowLoGinVC showLoginVc:self withTipMessage:responseObject[MESSAGE]];
//        }else{
//            [self.view makeToast:responseObject[MESSAGE] duration:1.5 position:CSToastPositionCenter];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [EasyShowLodingView hidenLoding];
//        //上传失败
//        [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureFailure" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
//    }];
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    //    tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
    [tzImagePickerVc showProgressHUD];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image location:self.location completion:^(PHAsset *asset, NSError *error){
            [tzImagePickerVc hideProgressHUD];
            if (error) {
                NSLog(@"图片保存失败 %@",error);
            } else {
                TZAssetModel *assetModel = [[TZImageManager manager] createModelWithAsset:asset];
                // 允许裁剪,去裁剪
                TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                    [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                }];
                imagePicker.allowPickingImage = YES;
                //                imagePicker.needCircleCrop = YES;
                imagePicker.circleCropRadius = self.view.bounds.size.width/2;
                [self presentViewController:imagePicker animated:YES completion:nil];
                
                
            }
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)creatUI{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, kWindowW, 16)];
    label.textColor = RGBOF(0xe6e6e6);
    label.text = @"拍摄上传您的护照内页";
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:label];
    
//    NSArray *images = @[@"smrz_zhengmian", @"smrz_fanmian", @"smrz_shouchi"];
    NSArray *images = @[@"护照"];
    for (int i = 0; i < 1; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        btn.frame = CGRectMake((kWindowW - kWindowWHOne * 275) / 2, CGRectGetMaxY(label.frame) + 20 + i * kWindowHOne * 180 + i * 25, kWindowWHOne * 275, kWindowHOne * 180);
        [btn addTarget:self action:@selector(selActoin:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if (i == 0) {
            btn.tag = 11;
        }else if (i == 1){
            btn.tag = 22;
        }else{
            btn.tag = 33;
        }
        [self.btnsArr addObject:btn];
        [self.scrollView addSubview:btn];
    }
    UIButton *btn = [self.btnsArr lastObject];
    
    UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipBtn setTitle:@"示例图片" forState:UIControlStateNormal];
    [tipBtn setTitleColor:RGBOF(0xF0A70A) forState:UIControlStateNormal];
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    tipBtn.frame = CGRectMake(0, CGRectGetMaxY(btn.frame) + 20, kWindowW, 20);
    [tipBtn addTarget:self action:@selector(tipPicture) forControlEvents:UIControlEventTouchUpInside];
    tipBtn.hidden = YES;
    [self.scrollView addSubview:tipBtn];
    
    self.scrollView.contentSize = CGSizeMake(kWindowW, CGRectGetMaxY(tipBtn.frame) + 20);
}

- (void)tipPicture{
    //创建数据源
//    YBImageBrowserModel *model0 = [YBImageBrowserModel new];
//    [model0 setImageWithFileName:@"手持身份证" fileType:@"png"];
//
//    //创建图片浏览器
//    YBImageBrowser *browser = [YBImageBrowser new];
//    browser.dataArray = @[model0];
//    browser.currentIndex = 0;
//    [browser show];
}

- (void)selActoin:(UIButton *)sender{
    self.btnTag = sender.tag;
    if (sender.tag == 33) {
        //判断是否已授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            
            ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (authStatus == ALAuthorizationStatusDenied) {
                [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"cameraPermissionsTips" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
                return;
            }
        }
        [self chooseImage:1];
    }else{
        [self changeHeaderImage];
    }
    
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10, kWindowW, kWindowH - NEW_NavHeight - 10)];
        _scrollView.backgroundColor = mainColor;
    }
    return _scrollView;
}


@end
