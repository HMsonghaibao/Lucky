//
//  invitefriendView.m
//  digitalCurrency
//
//  Created by mac on 2019/5/17.
//  Copyright © 2019年 XinHuoKeJi. All rights reserved.
//

#import "invitefriendView.h"

@implementation invitefriendView

+(instancetype)loadinvitefriendView:(invitefriendViewBlock)loadinvitefriendView{
    invitefriendView*inviteView=[[NSBundle mainBundle] loadNibNamed:@"invitefriendView" owner:nil options:nil].lastObject;
    inviteView.invitefriendViewBlock=loadinvitefriendView;
    return inviteView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.weiboBtn setTitle:LocalizationKey(@"Weibo") forState:0];
    [self.pyqBtn setTitle:LocalizationKey(@"WeChatcircle") forState:0];
    [self.weixinBtn setTitle:LocalizationKey(@"WeChat") forState:0];
    [self.cancelBtn setTitle:LocalizationKey(@"cancel") forState:0];
    
    [self setbtnway:self.weiboBtn];
    [self setbtnway:self.qqBtn];
    [self setbtnway:self.pyqBtn];
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

- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.invitefriendViewBlock) {
        self.invitefriendViewBlock(0);
    }
}

- (IBAction)weiboBtnClick:(UIButton *)sender {
    if (self.invitefriendViewBlock) {
        self.invitefriendViewBlock(1);
    }
}
- (IBAction)qqBtnClick:(UIButton *)sender {
    if (self.invitefriendViewBlock) {
        self.invitefriendViewBlock(2);
    }
}
- (IBAction)pyqBtnClick:(UIButton *)sender {
    if (self.invitefriendViewBlock) {
        self.invitefriendViewBlock(3);
    }
}
- (IBAction)weixinBtnClick:(UIButton *)sender {
    if (self.invitefriendViewBlock) {
        self.invitefriendViewBlock(4);
    }
}

@end
