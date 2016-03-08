//
//  PhaseFeedBackDescInputViewController.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/2.
//  Copyright © 2015年 范传斌. All rights reserved.
//  输入说明内容主界面

#import <UIKit/UIKit.h>
@class OrderResultItem;

@protocol PhaseFeedBackDescInputDelegate <NSObject>
- (void)PhaseFeedBackDescInputWithContent:(NSString *)content;

- (void)ContentDidInputWithItem:(OrderResultItem *)item Content:(NSString *)content;//用于处理正在处理工单处理结束界面多处输入反馈
@end

@interface PhaseFeedBackDescInputViewController : BaseViewController

@property (nonatomic,strong)OrderResultItem *item;//用于处理正在处理工单处理结束界面多处输入反馈

@property (nonatomic,weak)id<PhaseFeedBackDescInputDelegate> delegate;

@property (nonatomic,strong)NSString *content;
@end
