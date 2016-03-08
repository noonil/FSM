//
//  ProcessResultViewCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/18.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProcessResult,ProcessResultFrame;

@interface ProcessResultViewCell : UITableViewCell

@property (nonatomic,strong)ProcessResult *processResult;
@property (nonatomic,strong)ProcessResultFrame *processResultFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
