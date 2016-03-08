//
//  HomeButton.m
//  Ericsson
//
//  Created by xuming on 15/11/29.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "HomeButton.h"

@implementation HomeButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(CGRect)titleRectForContentRect:(CGRect)contentRect

{
    
    CGFloat titleY = contentRect.size.height *0.6;
    
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = contentRect.size.height - titleY;
    
    return CGRectMake(0, titleY, titleW, titleH);
    
}


-(CGRect)imageRectForContentRect:(CGRect)contentRect

{
    CGFloat imageY = contentRect.size.height * 0.1;
    
    CGFloat imageW = CGRectGetWidth(contentRect);
    
    CGFloat imageH = contentRect.size.height * 0.6-imageY;
    
    return CGRectMake(0, imageY, imageW, imageH);
    
}
@end
