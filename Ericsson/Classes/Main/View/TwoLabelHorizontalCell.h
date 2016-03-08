//
//  TwoLabelHorizontalCell.h
//  Ericsson
//
//  Created by xuming on 15/12/22.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwoLabelHorizontalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (nonatomic,assign)BOOL chooseFlag; //在switchFlag标志为true时有效，表示切换按钮标志on/off

-(void)chooseCell;
-(void)notChooseCell;
@end
