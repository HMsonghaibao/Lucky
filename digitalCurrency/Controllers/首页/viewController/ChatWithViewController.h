//
//  ChatWithViewController.h
//  digitalCurrency
//
//  Created by 宋海保 on 2019/8/23.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TUIChatController.h"
#import "TUnReadView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChatWithViewController : UIViewController
@property (nonatomic, strong) TUIConversationCellData *conversationData;
@property (nonatomic, strong) TUnReadView *unRead;
@end

NS_ASSUME_NONNULL_END
