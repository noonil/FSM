//
//  GatherCellFrame.m
//  Ericsson
//
//  Created by xuming on 16/2/19.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "GatherCellFrame.h"
#import "GatherObject.h"
#define mmPadding 5;
#define mmTopH 15;//上部title的高度
#define mmButtomH 47.5;//下部，textfield的高度


@implementation GatherCellFrame



-(void)setGatherObject:(GatherObject *)gatherObject{
    _gatherObject=gatherObject;
    
    
    /*计算各个frame的值。*/
    
    //如果是必填项，显示star图标
    if ([gatherObject.isnull isEqualToString:@"N" ]) {
        
        //star的frame
        CGFloat starViewX=mmPadding;
        CGFloat starViewY=mmPadding;
        CGFloat starViewW=15;
        CGFloat starViewH=mmTopH;
        _starImgViewF=CGRectMake(starViewX, starViewY, starViewW, starViewH);
        
        //title的frame
        CGFloat titleViewX = CGRectGetMaxX(_starImgViewF) + mmPadding;
        CGFloat titleViewY = mmPadding;
        CGFloat titleViewW = 100;
        CGFloat titleViewH = mmTopH;
        _titleLabelF=CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
        
    }
    else{
        //title的frame
        CGFloat titleViewX = mmPadding;
        CGFloat titleViewY = mmPadding;
        CGFloat titleViewW = 100;
        CGFloat titleViewH = mmTopH;
        _titleLabelF = CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
    
    }
    
    CGFloat textFieldX = mmPadding;
    CGFloat textFieldY = CGRectGetMaxY(_titleLabelF)+0.5*mmPadding;
    CGFloat textFieldW = KIphoneWidth-2*mmPadding;
    CGFloat textFieldH = mmButtomH;
    _textFieldF = CGRectMake(textFieldX, textFieldY, textFieldW, textFieldH);
    
    if ([gatherObject.isSelect isEqualToString:@"Y"]) {
        CGFloat buttonW = 50;
        CGFloat buttonH = mmButtomH;
        CGFloat buttonX = CGRectGetMaxX(_textFieldF)-buttonW;
        CGFloat buttonY = textFieldY;
    
        _buttonF = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        CGFloat buttonImgViewW = 30;
        CGFloat buttonImgViewH = 20;
        CGFloat buttonImgViewX = buttonX+(buttonW-buttonImgViewW)/2;
        CGFloat buttonImgViewY = buttonY+(buttonH-buttonImgViewH)/2;
        _buttonImgViewF = CGRectMake(buttonImgViewX, buttonImgViewY, buttonImgViewW, buttonImgViewW);

    }
    
    

    

}
@end









