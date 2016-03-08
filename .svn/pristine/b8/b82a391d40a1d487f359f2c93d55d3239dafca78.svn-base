//
//  AddAnnoucneTitleVC.h
//  Ericsson
//
//  Created by Min on 15/12/25.
//  Copyright © 2015年 范传斌. All rights reserved.

// 添加公告内部 "标题和内容" 控制器

#import <UIKit/UIKit.h>

@protocol addAnnoucneTitleVCDelegate <NSObject>

- (void)submitBtnSelected:(NSString *)content;

@end




@interface AddAnnoucneTitleVC : UIViewController

@property (nonatomic,weak) id<addAnnoucneTitleVCDelegate> delegate;
/** content */
@property (nonatomic,copy) NSString * titleContent;
/** 控制器 title */
@property (nonatomic,copy) NSString * titleVC;

@end


