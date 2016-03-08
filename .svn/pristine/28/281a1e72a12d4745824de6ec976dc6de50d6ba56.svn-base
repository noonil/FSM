//
//  FeedBackInfoCell.h
//  Ericsson
//
//  Created by 范传斌 on 15/12/1.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedBackAttachmentViewCell.h"

@protocol FeedBackInfoCellDelegate <NSObject>
- (void)FeedBackInfoRefreshWith:(NSInteger)section;

@end

@interface FeedBackInfoCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,FeedBackAttachmentViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong)NSArray *FeedBacks;

@property (nonatomic,weak)id<FeedBackInfoCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic,assign)NSInteger section;//反馈阶段模块处于父tableView视图的section，用于定向刷新
@end
