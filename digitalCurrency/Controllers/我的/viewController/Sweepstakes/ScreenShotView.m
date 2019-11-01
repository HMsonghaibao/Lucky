//
//  ScreenShotView.m
//  digitalCurrency
//
//  Created by mac on 2019/6/20.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "ScreenShotView.h"

@implementation ScreenShotView

+(instancetype)loadScreenShotView:(ScreenShotViewBlock)loadScreenShotView{
    ScreenShotView*ShotView=[[NSBundle mainBundle] loadNibNamed:@"ScreenShotView" owner:nil options:nil].lastObject;
    ShotView.ScreenShotViewBlock=loadScreenShotView;
    return ShotView;
}


-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.weiboBtn setTitle:LocalizationKey(@"Weibo") forState:0];
    [self.friendBtn setTitle:LocalizationKey(@"WeChatcircle") forState:0];
    [self.weixinBtn setTitle:LocalizationKey(@"WeChat") forState:0];
    [self.cancelBtn setTitle:LocalizationKey(@"cancel") forState:0];
    
    [self setbtnway:self.weiboBtn];
    [self setbtnway:self.qqBtn];
    [self setbtnway:self.friendBtn];
    [self setbtnway:self.weixinBtn];
    
}

-(void)setbtnway:(UIButton*)button{
    // the space between the image and text
    CGFloat spacing = 6.0;
    
    // lower the text and push it left so it appears centered
    //  below the image
    CGSize imageSize = button.imageView.image.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(
                                              0.0, - imageSize.width, - (imageSize.height + spacing), 0.0);
    
    // raise the image and push it right so it appears centered
    //  above the text
    CGSize titleSize = [button.titleLabel.text sizeWithAttributes:@{NSFontAttributeName: button.titleLabel.font}];
    button.imageEdgeInsets = UIEdgeInsetsMake(
                                              - (titleSize.height + spacing), 0.0, 0.0, - titleSize.width);
    
    // increase the content height to avoid clipping
    CGFloat edgeOffset = fabs(titleSize.height - imageSize.height) / 2.0;
    button.contentEdgeInsets = UIEdgeInsetsMake(edgeOffset, 0.0, edgeOffset, 0.0);
}


- (IBAction)weiboBtnClick:(UIButton *)sender {
    if (self.ScreenShotViewBlock) {
        self.ScreenShotViewBlock(0);
    }
}
- (IBAction)qqBtnClick:(UIButton *)sender {
    if (self.ScreenShotViewBlock) {
        self.ScreenShotViewBlock(1);
    }
}
- (IBAction)friendBtnClick:(UIButton *)sender {
    if (self.ScreenShotViewBlock) {
        self.ScreenShotViewBlock(2);
    }
}
- (IBAction)weixinBtnClick:(UIButton *)sender {
    if (self.ScreenShotViewBlock) {
        self.ScreenShotViewBlock(3);
    }
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.ScreenShotViewBlock) {
        self.ScreenShotViewBlock(4);
    }
}

@end
