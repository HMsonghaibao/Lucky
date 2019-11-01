//
//  SLSegmentView.h
//  digitalCurrency
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SLSegmentComeView : UIView

@property (nonatomic, copy) void (^clickSegmentButton)(NSInteger index);

- (instancetype)initWithSegmentWithTitleArray:(NSArray *)segementTitleArray;

//滑动到当前选中的segment
- (void)movieToCurrentSelectedSegment:(NSInteger)index;
//修改按钮标题
-(void)modifyButtonTitle:(NSString*)title;
@end


