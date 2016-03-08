//
//  SearchCell.h
//  Ericsson
//
//  Created by xuming on 15/12/15.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchCell;

@protocol SearchCellDelegate<NSObject>
-(void)searchCellEditDidBegin:(NSIndexPath *)indexPath searchCell:(SearchCell *)cell;

@end


@interface SearchCell : UITableViewCell
@property (nonatomic, strong)NSIndexPath *indexPath;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *textField_btn;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) id<SearchCellDelegate> delegate;

- (IBAction)textFieldBtn_TouchUpInside:(id)sender;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

