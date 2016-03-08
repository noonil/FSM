//
//  AnnounceSearchContentViewController.h
//  Ericsson
//
//  Created by Min on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.

/******************************
 *  没有下面的查询和添加按钮
 *
 * 我的公告
 * 查询公告 --> 显示的为全部公告
 *
 */

#import <UIKit/UIKit.h>

@interface AnnounceSearchContentViewController : BaseViewController

/** 请求的类型 */
@property (nonatomic,assign) NSInteger  requestType;
/** 是否是查询到 */
@property (nonatomic,assign) BOOL  isSearchAnn;

@property (nonatomic,copy) NSString * navTitle;
@property (nonatomic,copy) NSString * theTitle;
@property (nonatomic,copy) NSString * startTime;
@property (nonatomic,copy) NSString * endTime;

@end
