//
//  BindOilMachine.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/23.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BindOilMachineViewDelegate<NSObject>
- (void)bindOilMachineWithCancelType;
- (void)bindOilMachineWithBindType;
@end

@interface BindOilMachine : UIView
@property (nonatomic,strong)id<BindOilMachineViewDelegate> delegate;

@end
