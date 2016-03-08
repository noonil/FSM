//
//  AddAnnounceTableViewCell.h
//  Ericsson
//
//  Created by Min on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.

// 

#import <UIKit/UIKit.h>
@class AddAnnounceTableViewCell;

@protocol AddAnnounceTableViewCellDelegate <NSObject>
- (void)chooseBtnClick:(AddAnnounceTableViewCell *)cell;
@end

@interface AddAnnounceTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *isSelectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *departName;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


@property (nonatomic,weak) id<AddAnnounceTableViewCellDelegate> delegate;
+ (AddAnnounceTableViewCell*)cellWithTableView:(UITableView*)tableView;


@end
