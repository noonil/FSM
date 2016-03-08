//
//  AttachTableViewCell.h
//  Ericsson
//
//  Created by apple on 16/1/14.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttachTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImg;
@property (weak, nonatomic) IBOutlet UILabel *fileNameText;
@property (weak, nonatomic) IBOutlet UILabel *detailText;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
