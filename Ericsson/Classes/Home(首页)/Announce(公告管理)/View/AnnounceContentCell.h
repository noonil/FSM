//
//  AnnounceContentCell.h
//  Ericsson
//
//  Created by Min on 15/12/22.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnnounceContentFrame;


@interface AnnounceContentCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,strong) AnnounceContentFrame * contentFrame;
@end
