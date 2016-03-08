//
//  SearchViewController.h
//  Ericsson
//
//  Created by xuming on 15/12/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConsumeList.h"
#import "HandledOrderDetailController.h"
#import "HandlingOrderDetailController.h"
#import "HandingDetailViewController.h"
#import "completeDetailViewController.h"

@interface SearchViewController : UIViewController

//耗材申请提交成功，返回到这个页面时，consumeList要置为nil
@property (nonatomic, strong) ConsumeList *consumeList;
//显示buttonview页面的回调
@property (nonatomic, copy) void(^showButtonsBlock)();

@property (nonatomic, strong)HandlingOrderDetailController *handlingOrderDetail;
@property (nonatomic, strong)HandledOrderDetailController *handledOrderDetail;


@property (strong ,nonatomic) completeDetailViewController * completeDetail;
@property (strong ,nonatomic) HandingDetailViewController * handlingDetail;

@end
