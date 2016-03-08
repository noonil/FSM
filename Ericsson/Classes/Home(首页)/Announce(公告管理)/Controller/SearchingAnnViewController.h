//
//  SearchingAnnViewController.h
//  Ericsson
//
//  Created by Min on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.

// 查询

// 在哪一个里面，查找 显示对应的公告

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface SearchingAnnViewController : BaseViewController
/** 请求类型 */
@property (nonatomic,assign) NSInteger  requestType;
/** 控制器的标题 */
@property (nonatomic,copy) NSString * navTitle;
/** 数据源 */
@property (nonatomic,strong) NSMutableArray * announceContentData;
@end
