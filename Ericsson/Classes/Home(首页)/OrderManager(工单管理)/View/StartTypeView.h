//
//  StartTypeView.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StartTypeViewDelegate <NSObject>
- (void)StartOrderWithType:(NSInteger)type;
@end

@interface StartTypeView : UIView
@property (weak, nonatomic) IBOutlet UILabel *planArriveTime;
@property (nonatomic,weak) id<StartTypeViewDelegate> delegate;

- (IBAction)Start:(UIButton *)sender;
@end
