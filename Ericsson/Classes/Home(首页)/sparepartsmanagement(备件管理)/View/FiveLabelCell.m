//
//  FiveLabelCell.m
//  Ericsson
//
//  Created by Min on 16/1/9.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "FiveLabelCell.h"

@implementation FiveLabelCell


+ (instancetype)cellWithTableView:(UITableView*)tableView
{
    static NSString * ID = @"fiveLabelCell";
    FiveLabelCell * cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
#warning 这里 使用 NSBundel加载 有什么区别
//        cell = [[FiveLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"FiveLabelCell" owner:nil options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = KBaseGray;
    }
    return cell;

}

@end
