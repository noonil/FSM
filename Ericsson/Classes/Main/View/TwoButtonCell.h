//
//  TwoButtonCell.h
//  Ericsson
//
//  Created by xuming on 15/12/23.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwoButtonCell;

@protocol TwoButtonCellDelegate <NSObject>
@optional
- (void)twoButtonCell_firstButton_touchUpInside;
- (void)twoButtonCell_secondButton_touchUpInside;
@end


@interface TwoButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (strong, nonatomic) id model;
@property (nonatomic,weak) id<TwoButtonCellDelegate> delegate;


- (IBAction)oneButton_TouchDown:(id)sender;
- (IBAction)twoButton_TouchDown:(id)sender;
+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
