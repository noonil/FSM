//
//  MaintanceObjInfoView.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/3.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#define MaintanceObjMarginXY 10
#define MaintanceObjKeyW 100
#define MaintanceObjKeyH (self.frame.size.height - 9 *MaintanceObjMarginXY) / 8

#define MaintanceObjValueW (self.frame.size.width - MaintanceObjKeyW-MaintanceObjMarginXY*2)
#define MaintanceObjValueH MaintanceObjKeyH
#define MaintanceObjFont [UIFont systemFontOfSize:15]

#import "MaintanceObjInfoView.h"

@interface MaintanceObjInfoView() <UIGestureRecognizerDelegate>

@end

@implementation MaintanceObjInfoView

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    for (int i = 0; i < self.MaintanceOjbInfoArray.count; i++) {
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaintanceObjMarginXY, MaintanceObjMarginXY + (MaintanceObjMarginXY + MaintanceObjKeyH) * i, MaintanceObjKeyW, MaintanceObjKeyH)];
        keyLabel.font = MaintanceObjFont;
        keyLabel.numberOfLines = 0;
        keyLabel.textColor = [UIColor blackColor];
        
        keyLabel.text = [NSString stringWithFormat:@"%@:",self.MaintanceOjbInfoArray[i][@"name"]];
        
        [self addSubview:keyLabel];
        
        UILabel *valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(MaintanceObjMarginXY + MaintanceObjKeyW, MaintanceObjMarginXY + (MaintanceObjMarginXY + MaintanceObjValueH) * i, MaintanceObjValueW, MaintanceObjValueH)];
        valueLabel.font = MaintanceObjFont;
        valueLabel.numberOfLines = 0;
        valueLabel.text = self.MaintanceOjbInfoArray[i][@"value"];
        valueLabel.textColor = [UIColor darkGrayColor];
        
        if (i==4) {
            UITapGestureRecognizer* recognizer;
            recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(call)];
            recognizer.delegate=self;
            [valueLabel addGestureRecognizer:recognizer];
            valueLabel. userInteractionEnabled=YES;
            
            //添加一个电话图标
            UIButton *button=[[UIButton alloc]init];
            [button setImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
            CGFloat x=CGRectGetMaxX(valueLabel.frame)-MaintanceObjValueH;
            CGFloat y=CGRectGetMinY(valueLabel.frame);
            CGFloat width=MaintanceObjValueH;
            CGFloat height=MaintanceObjValueH;

            button.frame=CGRectMake(x, y, width, height);
            
            [self addSubview:button];
            
        }
        
        
        //添加地址，多行显示
        if (i==self.MaintanceOjbInfoArray.count-1) {
             UITextView *oneTextView = [[UITextView alloc] init];
            CGRect frame=valueLabel.frame;
            frame.origin.y-=MaintanceObjMarginXY;
            frame.size.height+=MaintanceObjMarginXY;
            oneTextView.frame=frame;
             oneTextView.text = self.MaintanceOjbInfoArray[i][@"value"]; // 设置文字
            oneTextView.font=MaintanceObjFont;
            oneTextView.textColor = [UIColor darkGrayColor];
            oneTextView.editable=NO;
            oneTextView.backgroundColor=[UIColor lightGrayColor];
            [self addSubview:oneTextView];
            
            break;

        }
        [self addSubview:valueLabel];
        
    }

    self.layer.borderColor = [UIColor redColor].CGColor;
    
}

-(void)call{
    NSString *telStr=[NSString stringWithFormat:@"tel://%@",self.MaintanceOjbInfoArray[4][@"value"]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
    
}


-(void)setMaintanceOjbInfoArray:(NSArray *)MaintanceOjbInfoArray{
    _MaintanceOjbInfoArray = MaintanceOjbInfoArray;
    [self setNeedsDisplay];
}

@end
