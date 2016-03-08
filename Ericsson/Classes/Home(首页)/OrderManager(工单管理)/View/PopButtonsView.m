//
//  PopButtonsView.m
//  Ericsson
//
//  Created by xuming on 16/1/11.
//  Copyright (c) 2016年 范传斌. All rights reserved.
//

#import "PopButtonsView.h"

#define mmHPadding 20//水平方向的填充大小
@interface PopButtonsView()<UIGestureRecognizerDelegate> {

    float buttonLong;
    float mmVPadding;
}

@end

@implementation PopButtonsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{

    self=[super initWithFrame:frame];
    
    _buttonTitleArray=[NSMutableArray array];
    
    
    //添加隐藏界面的手势
    [self addGesture];
    
    return self;
    
}

-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    

}

-(void)addGesture{
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnce)];
    recognizer.delegate=self;
    [self addGestureRecognizer:recognizer];
}


-(void)handleTapOnce{
    self.hidden=YES;
    
    if ([self.delegate respondsToSelector:@selector(PopButtonsViewTap)]) {
        [self.delegate PopButtonsViewTap];
    }



}


-(void)layoutSubviews{
    [super layoutSubviews];
    

}

-(void)cleanSubViews{
    NSArray *arr= self.subviews;
    for (int i=0; i<arr.count; i++) {
        UIView *view=arr[i];
        [view removeFromSuperview];
    }
}

-(void)setButton:(NSString *)buttonTitle index:(NSInteger)i {
    float x;
    float y;

        int iX=i%3;
        long zhengshu=i/3;
    
        x=mmHPadding*(iX+1)+buttonLong*iX;
        y=mmVPadding*(zhengshu+1)+buttonLong*zhengshu;

    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(x, y, buttonLong, buttonLong)];
    [button setBackgroundImage:[UIImage imageNamed:@"kong_aquan.png"] forState:UIControlStateNormal];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
    button.titleLabel.font=[UIFont systemFontOfSize:15];
    button.tag=0;
    
    //记录哪个是发电按钮
    if (i==0) {
        self.electricButton=button;
    }
    
    [self addSubview:button];
}

-(void)buttonTouchDown:(UIButton *)button{
    if (button.tag==0) {
        [button setBackgroundImage:[UIImage imageNamed:@"shi_quan.png"] forState:UIControlStateNormal];
        button.tag=1;
    }
    
    self.hidden=YES;
    
    if ([self.delegate respondsToSelector:@selector(PopButtonsViewButtonTouchDown:)]) {
        [self.delegate performSelector:@selector(PopButtonsViewButtonTouchDown:) withObject:button];
    }
}

#pragma  mark -get/set
-(UIButton *)electricButton{
    if (_electricButton==nil) {
        _electricButton=[[UIButton alloc]init];
    }
    return _electricButton;

}


-(void)setButtonTitleArray:(NSMutableArray *)buttonTitleArray{
    _buttonTitleArray=buttonTitleArray;
    
    
    //添加buttons
    buttonLong=(KIphoneWidth-mmHPadding*4)/3;
    mmVPadding=(KIphoneHeight-buttonLong*4)/5;
    
    //如果已经加上了button，就不用再添加了。
    NSArray *arr= self.subviews;
    if (arr.count>0) {
        return;
    }
    
    for (int i=0; i<=11; i++) {
        [self setButton:self.buttonTitleArray[i] index:i];
        
    }
    
}



@end


