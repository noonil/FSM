//
//  AnnounceNumberViewCell.h
//  Ericsson
//
//  Created by Min on 15/12/21.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnnounceNumberViewCell : UITableViewCell


/** 公告管理Cell的Name*/
@property (weak, nonatomic) IBOutlet UILabel *numCell_name;
/** 公告管理Cell的Number*/
@property (weak, nonatomic) IBOutlet UIButton *numCell_numberBtn;
+ (instancetype)cellWithTable:(UITableView*)tableView;
@end
