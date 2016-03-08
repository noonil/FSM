//
//  OneButtonCell.h
//  Ericsson
//
//  Created by xuming on 15/12/23.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OneButtonCell;

@protocol OneButtonCellSetupCoordinateOrTime <NSObject>
@optional
- (void)clickBtnToSetupCoordinateOrWithCell:(OneButtonCell*)cell;
@end

@interface OneButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (strong, nonatomic) id model;

@property (nonatomic,weak) id<OneButtonCellSetupCoordinateOrTime> delegate;

- (IBAction)button_TouchDown:(id)sender;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
