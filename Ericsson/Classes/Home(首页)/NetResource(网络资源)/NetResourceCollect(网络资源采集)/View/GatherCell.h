//
//  GatherCell.h
//  Ericsson
//
//  Created by xuming on 16/2/19.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GatherCellFrame.h"
#import "GatherObject.h"

@class GatherCell;

@protocol GatherCellDelegate<NSObject>
-(void)gatherCellButtonDidTouchDown:(GatherObject *)gatherObject cell:(GatherCell *)cell;
//结束编辑的时候的时候，把填的textField，和tag的值传给代理，tag里面存的是row，row表示tableview里面第几个cell
-(void)gatherCellTextFieldDidEndEditing:(GatherCell *)gatherCell;
-(void)gatherCellInputDate:(GatherCell *)gatherCell;
@end


@interface GatherCell : UITableViewCell

/*cell上的子view*/
@property(nonatomic, weak) UILabel *starImgView;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UITextField *textField;
@property(nonatomic, weak) UIButton *button;
@property(nonatomic, weak) UIImageView *buttonImgView;

//cell对应的tableview
@property(nonatomic, strong) UITableView *tableView;




@property(nonatomic, strong) GatherCellFrame *gatherCellFrame;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property (weak, nonatomic) id<GatherCellDelegate> delegate;



@end
