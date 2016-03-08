//
//  EricssonTabBar.h
//  Ericsson
//
//  Created by zhangyongpeng on 16/2/2.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EricssonTabBar;

@protocol  EricssonTabBarDelegate <UITabBarDelegate>

@optional
-(void)SecurityResponseButtonClick:(UIButton*)btn;

//-(void)isSecurityResponse:(UIButton *)btn;//用于判断是否有响应消息，以此来设置btn的样式

@end


@interface EricssonTabBar : UITabBar
@property (nonatomic, strong) UIButton *SRButton;

@property (nonatomic, weak) id <EricssonTabBarDelegate> delegate;
@end
