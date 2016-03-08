//
//  SpareSubmitListFourLabelCell.m
//  Ericsson
//
//  Created by Min on 16/1/9.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "SpareSubmitListFourLabelCell.h"
#define kTxtBlackColor [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1]
#define kTxtGrayColor [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]
#define mmCellHeight 50
#define mmFontSize 15

@interface SpareSubmitListFourLabelCell()
{
    NSArray  *titleArray;
    int titleLength;
    
}
@end


@implementation SpareSubmitListFourLabelCell

-(instancetype)init{
    
    if (self=[super init]) {
        [self setOthers];
        [self setUpAllChildView];
    }
    return self;
}

-(void)setOthers{
    titleArray=[[NSArray alloc]initWithObjects:@"申请单编号",@"备件名称",@"数量",@"申请时间", nil];
    
}
-(void)setUpAllChildView
{
    
    titleLength=0;
    int x=0;
    unsigned long titleLengthI;
    unsigned long widthI;
    
    
    for (int i=0; i<4; i++) {
        titleLength+=((NSString *)[titleArray objectAtIndex:i]).length;
    }
    
    
  

    UILabel *label1=[[UILabel alloc]init];
    label1.font= [UIFont systemFontOfSize:mmFontSize];
    [self addSubview:label1];
    _label1=label1;
    titleLengthI=((NSString *)[titleArray objectAtIndex:0]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label1.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;
    
    
    UILabel *label2=[[UILabel alloc]init];
    label2.numberOfLines = 0;
    label2.font= [UIFont systemFontOfSize:mmFontSize];
    [self addSubview:label2];
    _label2=label2;
    titleLengthI=((NSString *)[titleArray objectAtIndex:1]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label2.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;
    
    UILabel *label3=[[UILabel alloc]init];
    label3.font= [UIFont systemFontOfSize:mmFontSize];
    [self addSubview:label3];
    _label3=label3;
    titleLengthI=((NSString *)[titleArray objectAtIndex:2]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label3.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;
    
    
    UILabel *label4=[[UILabel alloc]init];

    label4.font= [UIFont systemFontOfSize:mmFontSize];
    [self addSubview:label4];
    _label4=label4;
    
    titleLengthI=((NSString *)[titleArray objectAtIndex:3]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label4.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;
    
    UIView * bottomView = [[UIView alloc]initWithFrame:CGRectMake(x, CGRectGetMaxY(label4.frame),self.width, 2)];
    bottomView.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [self.contentView addSubview:bottomView];  
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"spareCell";
    SpareSubmitListFourLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[SpareSubmitListFourLabelCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}


-(void)setBorrowSpare:(BorrowSpare *)model{
    
    
    UIColor *txtColor = nil;
    if ([model.flag isEqualToString:@"0"]) {
        txtColor = [UIColor blackColor];
    }else {
        txtColor = [UIColor grayColor];
    }
    _label1.textColor = txtColor;
    _label2.textColor = txtColor;
    _label3.textColor = txtColor;
    _label4.textColor = txtColor;
    
    _label1.text=model.spareApplyId;
    _label2.text=model.spareName;
    _label3.text=model.borrowNum;
    _label4.text=model.borrowTime;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
