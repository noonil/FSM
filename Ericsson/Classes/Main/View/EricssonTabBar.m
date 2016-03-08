//
//  EricssonTabBar.m
//  Ericsson
//
//  Created by zhangyongpeng on 16/2/2.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "EricssonTabBar.h"

@implementation EricssonTabBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"my"] forState:UIControlStateNormal];
        UIImage *img = [[UIImage imageNamed:@"my_choosed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [btn setImage:img forState:UIControlStateSelected];
        
        //设置title
        [btn setTitle:@"安全响应" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [btn setTitle:@"安全响应" forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithRed:33/255.0 green:118/255.0 blue:188/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        self.SRButton = btn;
        
        
//        NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:100 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
//        [myTimer setFireDate:[NSDate distantPast]];
                
    }
    return self;
}

-(void)btnClick{
    //通知代理
    if ([self.delegate respondsToSelector:@selector(SecurityResponseButtonClick:)]) {
        [self.delegate SecurityResponseButtonClick:self.SRButton];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
//    NSLog(@"hhhh = %f",self.height); //49
    
    CGFloat tabbarButtonW = self.width / 4;
    CGFloat tabbarButtonIndex = 0;
    
    self.SRButton.width = tabbarButtonW;
    self.SRButton.height = self.height;
    
    //1. 设置  安全响应 按钮的位置
    self.SRButton.centerX = self.width / 8 * 5;
    self.SRButton.centerY = self.height * 0.5;
    
    self.SRButton.titleLabel.font = [UIFont systemFontOfSize:10];
    self.SRButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    //自定义 img 和 title 的位置
    CGFloat imgLeftEdge = (self.width / 4 - self.SRButton.currentImage.size.width) / 2;
//    NSLog(@"1111 %f",self.width / 4);
//    NSLog(@"2222 %f",btn.currentImage.size.width);//22
    self.SRButton.imageEdgeInsets = UIEdgeInsetsMake(10,imgLeftEdge-7,20,0);
    self.SRButton.titleEdgeInsets = UIEdgeInsetsMake(30, -self.SRButton.titleLabel.width+10, -4, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    
    //2. 设置其他tabbarButton的位置和尺寸
    
    //遍历所有的subview
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        // 判断如果是 tabbarButton  进行相应操作
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW;
            // 设置x
            child.x = tabbarButtonW * tabbarButtonIndex;
            
//            child.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];
            // 增加索引
            tabbarButtonIndex++;
            if (tabbarButtonIndex == 2) {
                tabbarButtonIndex++;
            }
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
