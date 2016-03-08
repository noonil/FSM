//
//  AllAnnounceViewController.h
//  Ericsson
//
//  Created by Min on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.

// 所有公告列表  -----> 全部公告 已读公告 未读公告 我的草稿

#import <UIKit/UIKit.h>

@interface AllAnnounceViewController : BaseViewController

/** 请求类型 */
@property (nonatomic,assign) NSInteger  annoucneType;
/** 请求标题 */
@property (nonatomic,copy) NSString * navTitle;
/** methodName */
@property (nonatomic,copy) NSString * methodName;
@end
