//
//  ConsumeSubmitListFourLabelCell.m
//  Ericsson
//
//  Created by xuming on 16/1/6.
//  Copyright (c) 2016年 范传斌. All rights reserved.
//

#import "ConsumeSubmitListFourLabelCell.h"
#define mmCellHeight 50
#define mmFontSize 15

@interface ConsumeSubmitListFourLabelCell ()

{
    NSArray  *titleArray;
    int titleLength;

}
@end

@implementation ConsumeSubmitListFourLabelCell

- (void)awakeFromNib {
    // Initialization code

}

-(void)setOthers{
    titleArray=[[NSArray alloc]initWithObjects:@"申请单编号",@"耗材名称",@"数量",@"申请时间", nil];

}

-(instancetype)init{

    if (self=[super init]) {
        [self setOthers];
        [self setUpAllChildView];
    }
    return self;
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
    label1.textColor=[UIColor grayColor];
    [self addSubview:label1];
    _label1=label1;
    titleLengthI=((NSString *)[titleArray objectAtIndex:0]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label1.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;
    
    
    UILabel *label2=[[UILabel alloc]init];
    label2.font= [UIFont systemFontOfSize:mmFontSize];
    label2.textColor=[UIColor grayColor];
    [self addSubview:label2];
    _label2=label2;
    titleLengthI=((NSString *)[titleArray objectAtIndex:1]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label2.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;
    
    UILabel *label3=[[UILabel alloc]init];
    label3.font= [UIFont systemFontOfSize:mmFontSize];
    label3.textColor=[UIColor grayColor];
    [self addSubview:label3];
    _label3=label3;
    titleLengthI=((NSString *)[titleArray objectAtIndex:2]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label3.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;

    
    UILabel *label4=[[UILabel alloc]init];
    label4.font= [UIFont systemFontOfSize:mmFontSize];
    label4.textColor=[UIColor grayColor];
    [self addSubview:label4];
    _label4=label4;
    titleLengthI=((NSString *)[titleArray objectAtIndex:3]).length;
    widthI=KIphoneWidth/titleLength*titleLengthI;
    _label4.frame= CGRectMake(x, 0, widthI, mmCellHeight);
    x+=widthI;

    
}
    


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"cell";
    ConsumeSubmitListFourLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ConsumeSubmitListFourLabelCell alloc]init];

    }
    
    return cell;
}


-(void)setBorrowConsume:(BorrowConsume *)model{

    _label1.text=model.consumableApplyId;
    _label2.text=model.consumableName;
    _label3.text=model.borrowNum;
    _label4.text=model.borrowDate;
    
    if (![model.flag isEqualToString:@"1"]) {
        _label1.textColor=[UIColor blueColor];
        _label2.textColor=[UIColor blueColor];
        _label3.textColor=[UIColor blueColor];
        _label4.textColor=[UIColor blueColor];
    }
    else{
        _label1.textColor=[UIColor grayColor];
        _label2.textColor=[UIColor grayColor];
        _label3.textColor=[UIColor grayColor];
        _label4.textColor=[UIColor grayColor];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end





