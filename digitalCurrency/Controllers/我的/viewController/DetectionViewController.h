//
//  DetectionViewController.h
//  IDLFaceSDKDemoOC
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "FaceBaseViewController.h"
typedef void(^cropSucess)(UIImage *image);
@interface DetectionViewController : FaceBaseViewController
@property (nonatomic, copy) cropSucess cropSucess;
@end
