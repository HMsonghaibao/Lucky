//
//  AccountSettingViewController.m
//  digitalCurrency
//
//  Created by iDog on 2018/1/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AccountSettingViewController.h"
#import "AccountImageTableViewCell.h"
#import "AccountSettingTableViewCell.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MoneyPasswordViewController.h"
#import "IdentityAuthenticationViewController.h"
#import "BindingEmailViewController.h"
#import "BindingPhoneViewController.h"
#import "ChangeLoginPasswordViewController.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"
#import "UIImageView+WebCache.h"
#import "ResetPhoneViewController.h"
#import "GestureTableViewCell.h"
#import "ZLGestureLockViewController.h"
#import "UpdateIDCardViewController.h"
#import "TZImagePickerController.h"
#import "TZImageUploadOperation.h"
#import "TZLocationManager.h"
#import "NicknameSettingTableViewCell.h"
#import "PhoneSettingTableViewCell.h"
#import "ChangePhoneViewController.h"
@interface AccountSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,TZImagePickerControllerDelegate>{
    BOOL _phoneVerified;
    BOOL _emailVerified;
    BOOL _loginVerified;
    BOOL _fundsVerified;
    BOOL _realVerified;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
//上传路径
@property(nonatomic,strong) NSMutableArray *accountInfoArr;
@property(nonatomic,strong)NSMutableArray *accountColorArr;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,strong) UIImage *headImage;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (strong, nonatomic) CLLocation *location;
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@end

@implementation AccountSettingViewController


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
//    self.title = [[ChangeLanguage bundle] localizedStringForKey:@"securitySetting" value:nil table:@"English"];
    self.title = LocalizationKey(@"Personalinformation");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = [UIColor blackColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"NicknameSettingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([NicknameSettingTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"AccountImageTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountImageTableViewCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhoneSettingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([PhoneSettingTableViewCell class])];
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.headImage = [[UIImage alloc] init];
    
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self accountSettingData];
}
//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
   
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"loading" value:nil table:@"English"]];
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"resPonseObj ---- %@",resPonseObj);
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {

                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
               
                [self.tableView reloadData];
            }else if ([resPonseObj[@"code"] integerValue]==4000){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}


- (NSMutableArray *)accountInfoArr {
    if (!_accountInfoArr) {
        _accountInfoArr = [NSMutableArray arrayWithArray:@[@"",[[ChangeLanguage bundle] localizedStringForKey:@"uncertified" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"unbounded" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"unbounded" value:nil table:@"English"],LocalizationKey(@"unSetting"),LocalizationKey(@"unSetting")]];
    }
    return _accountInfoArr;
}
- (NSMutableArray *)accountColorArr {
    if (!_accountColorArr) {
        _accountColorArr = [NSMutableArray arrayWithArray:@[baseColor,baseColor,baseColor,baseColor,baseColor,baseColor,baseColor,baseColor]];
    }
    return _accountColorArr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0){
        return 75;
    }else{
      return 63;
    }
}
//-(NSArray *)getNameArr{
//    NSArray * nameArr = @[@"",[[ChangeLanguage bundle] localizedStringForKey:@"identityAuthentication" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"bindingEmail" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"bindPhoneNumber" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"loginPassword" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"moneyPassword" value:nil table:@"English"]];
//
//    return nameArr;
//}

-(NSArray *)getNameArr{
    NSArray * nameArr = @[@"",[[ChangeLanguage bundle] localizedStringForKey:@"bindingEmail" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"bindPhoneNumber" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"loginPassword" value:nil table:@"English"],[[ChangeLanguage bundle] localizedStringForKey:@"moneyPassword" value:nil table:@"English"]];
    
    return nameArr;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.row == 0) {
            AccountImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountImageTableViewCell class]) forIndexPath:indexPath];
            cell.selectionStyle = 0;
            cell.headImage.clipsToBounds = YES;
            cell.headImage.layer.cornerRadius = 30;
            if (self.accountInfo.avatar == nil || [self.accountInfo.avatar isEqualToString:@""]) {
            }else{
                NSURL *headUrl = [NSURL URLWithString:self.accountInfo.avatar];
                [cell.headImage sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"defaultImage"]];
            }
            return cell;
        }else if(indexPath.row == 1){
            PhoneSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PhoneSettingTableViewCell class])];
            cell.selectionStyle = 0;
            cell.rightLabel.text = self.accountInfo.nickName;
//            cell.leftLabel.text = [self getNameArr][indexPath.row];
            return cell;
        }else{
            NicknameSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NicknameSettingTableViewCell class])];
            cell.selectionStyle = 0;
            cell.rightLabel.text = self.accountInfo.mobile;
//            cell.leftLabel.text = [self getNameArr][indexPath.row];
            return cell;
        }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        NSString *tixing = LocalizationKey(@"securityTiXing");
//        CGFloat height = [ToolUtil heightForString:tixing andWidth:kWindowW - 20 fontSize:13];
//        return height + 25;
//    }
//    return 10;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    UIView *view = [[UIView alloc] init];
//    if (section == 0) {
//        NSString *tixing = LocalizationKey(@"securityTiXing");
//        CGFloat height = [ToolUtil heightForString:tixing andWidth:kWindowW - 20 fontSize:13];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, kWindowW - 20, height)];
//        label.text = tixing;
//        label.textColor = RGBOF(0x999999);
//        label.font = [UIFont systemFontOfSize:13];
//        [view addSubview:label];
//    }
//    return view;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 0.0001f;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc] init];
//    return view;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        //改变头像
        [self changeHeaderImage];
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


//MARK:--添加头像
-(void)changeHeaderImage{
    __block NSUInteger sourceType = 0;
    [LEEAlert actionsheet].config
    .LeeAddTitle(^(UILabel *label) {
        label.text = [[ChangeLanguage bundle] localizedStringForKey:@"projectNameTip" value:nil table:@"English"];
        label.textColor = AppTextColor_333333;
        label.backgroundColor = mainColor;
    })
    .LeeAddContent(^(UILabel *label){
        label.text = LocalizationKey(@"addHeadImageMessage");
        label.textColor = AppTextColor_333333;
        label.backgroundColor = mainColor;
    })
    .LeeHeaderColor(mainColor)
    .LeeAddAction(^(LEEAction *action) {
        action.type = LEEActionTypeDestructive;
        action.title = [[ChangeLanguage bundle] localizedStringForKey:@"takingPictures" value:nil table:@"English"];
        action.backgroundColor = mainColor;
        action.titleColor = AppTextColor_333333;
        action.borderColor = RGBCOLOR(18, 22, 28);
        action.clickBlock = ^{
//            //判断是否已授权
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
        action.titleColor = AppTextColor_333333;
        action.borderColor = RGBCOLOR(18, 22, 28);
        action.clickBlock = ^{
//            //判断是否已授权
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
        action.titleColor = AppTextColor_333333;
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


// 图片转64base字符串
- (NSString *)imageToString:(UIImage *)image {
    NSData *imagedata = UIImageJPEGRepresentation(image, 0.5f);
    NSString *image64 = [imagedata base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return image64;
}


-(void)updateSelectImage:(UIImage*)headImage{
    NSString*basestr = [self imageToString:headImage];
    
    NSMutableDictionary *bodydic = [NSMutableDictionary dictionary];
    [bodydic setValue:basestr forKey:@"base64Data"];
    [MineNetManager uploadByBase64Param:bodydic CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        
        NSLog(@"=====%@",resPonseObj);
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [self headImage:resPonseObj[@"data"] headimage:headImage];
                
//                [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureSuccess" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [EasyShowLodingView hidenLoding];
            //上传失败
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"upLoadPictureFailure" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
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


#pragma mark UIImagePickerController代理 已经选择了图片,上传到服务器中,返回上传结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
//    //选择图片
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
//        //上传成功
//        if ([responseObject[@"code"] integerValue] == 0) {
//            //[self.view makeToast:@"上传图片成功" duration:1.5 position:CSToastPositionCenter];
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            AccountImageTableViewCell *cell = (AccountImageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
//            cell.headImage.image = headImage;
//            [self headImage:responseObject[@"data"]];
//        }else if([responseObject[@"code"] integerValue] == 4000) {
//            [ShowLoGinVC showLoginVc:self withTipMessage:responseObject[MESSAGE]];
//        }else{
//            [self.view makeToast:responseObject[MESSAGE] duration:1.5 position:CSToastPositionCenter];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//       [EasyShowLodingView hidenLoding];
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
//MARK:--设置头像
-(void)headImage:(NSString *)urlString headimage:(UIImage*)headImage{
    [EasyShowLodingView showLodingText:[[ChangeLanguage bundle] localizedStringForKey:@"settingHeadImage" value:nil table:@"English"]];
    [MineNetManager setHeadImageForUrl:urlString CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"====%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //设置头像成功
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                AccountImageTableViewCell *cell = (AccountImageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
                cell.headImage.image = headImage;
                 [self.view makeToast:@"设置头像成功" duration:1.5 position:CSToastPositionCenter];

            }else if ([resPonseObj[@"code"] integerValue]==4000){
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                 [YLUserInfo logout];
            }else{
                [self.view makeToast:resPonseObj[MESSAGE] duration:1.5 position:CSToastPositionCenter];
            }
        }else{
            [self.view makeToast:[[ChangeLanguage bundle] localizedStringForKey:@"noNetworkStatus" value:nil table:@"English"] duration:1.5 position:CSToastPositionCenter];
        }
    }];
}
//给cell添加动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
//
//    //设置动画时间为0.25秒,xy方向缩放的最终值为1
//    [UIView animateWithDuration:0.25 animations:^{
//
//        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
//
//    }completion:^(BOOL finish){
//
//    }];
}

@end
