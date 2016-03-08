//
//  Search_1ViewController.h
//  Ericsson
//
//  Created by slark on 15/12/21.
//  Copyright © 2015年 范传斌. All rights reserved.

// 备件列表

#import <UIKit/UIKit.h>

@interface Search_1ViewController : BaseViewController


/** 备件名称 */
@property (copy, nonatomic) NSString *boardName;
/** 所属专业 */
@property (copy, nonatomic) NSString *boardType;
/** 厂商 */
@property (copy, nonatomic) NSString *factory;
@end
