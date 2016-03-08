//
//  FeedBackAttachmentViewCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WorkOrderAttachFile;

@protocol FeedBackAttachmentViewCellDelegate <NSObject>

- (void)FeedBackAttachmentDeleteClick:(NSIndexPath *)indexPath;
@end

@interface FeedBackAttachmentViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@property (nonatomic,strong)NSIndexPath *indexPath;

@property (nonatomic,strong)WorkOrderAttachFile *attachInfo;
- (IBAction)deleteAttachFile:(UIButton *)sender;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,weak)id<FeedBackAttachmentViewCellDelegate> delegate;
@end
