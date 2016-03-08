//
//  OrderSectionHeaderView.h
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OrderSectionHeaderViewDelegate <NSObject>
- (void)OrderSectionHeaderViewClick:(NSInteger)section;

@end

@interface OrderSectionHeaderView : UIView

@property (nonatomic,assign)NSInteger section;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *tailIcon;

- (IBAction)HeaderClick:(UIButton *)sender;

@property (nonatomic,weak)id<OrderSectionHeaderViewDelegate> delegate;


+ (instancetype)orderSectionHeaderView;

@end
