//
//  OrderHandleTypeView.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//
typedef NS_ENUM(NSInteger, OrderHandleType) {
    OrderHandleTypeCostApply,           //费用申请
    OrderHandleTypeAddResource,         //添加资源
    OrderHandleTypeQueryAlarm,          //告警查询
    OrderHandleTypeCostRport,           //费用上报
    OrderHandleTypeMaintenanceObj,      //维护对象
    OrderHandleTypeTechnicalManual,     //技术手册
    OrderHandleTypeCostShare,           //费用分摊
    OrderHandleTypeOperationItem,       //操作项
    OrderHandleTypeOperationProcedure,  //操作规程
    OrderHandleTypeConsumableApply,     //耗材申请
    OrderHandleTypeSparepartsApply,     //备件申请
    OrderHandleTypeSolveObstacleHis     //排障历史
};

#define OrderHandleBtnWH 80
#define OrderHandleBtnMarginX ([UIScreen mainScreen].bounds.size.width - OrderHandleBtnWH * 3) / 4
#define OrderHandleBtnMarginY ([UIScreen mainScreen].bounds.size.height - OrderHandleBtnWH * 4) / 5


#import "OrderHandleTypeView.h"
#import "UIView+Extension.h"

@interface OrderHandleTypeView()
@property (nonatomic,strong)NSMutableArray *handleBtns;
@end

@implementation OrderHandleTypeView

-(NSMutableArray *)handleBtns{
    if (!_handleBtns) {
        _handleBtns = [[NSMutableArray alloc] init];
    }
    return _handleBtns;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor blackColor];
//        self.alpha = 0.3;
        
        //添加操作按钮
        [self addBtnWithTitle:@"费用\n申请" type:OrderHandleTypeCostApply];
        [self addBtnWithTitle:@"添加\n资源" type:OrderHandleTypeAddResource];
        [self addBtnWithTitle:@"告警\n查询" type:OrderHandleTypeQueryAlarm];
        [self addBtnWithTitle:@"费用\n上报" type:OrderHandleTypeCostRport];
        [self addBtnWithTitle:@"维护\n对象" type:OrderHandleTypeMaintenanceObj];
        [self addBtnWithTitle:@"技术\n手册" type:OrderHandleTypeTechnicalManual];
        [self addBtnWithTitle:@"费用\n分摊" type:OrderHandleTypeCostShare];
        [self addBtnWithTitle:@"操作\n项" type:OrderHandleTypeOperationItem];
        [self addBtnWithTitle:@"操作\n规程" type:OrderHandleTypeOperationProcedure];
        [self addBtnWithTitle:@"耗材\n申请" type:OrderHandleTypeConsumableApply];
        [self addBtnWithTitle:@"备件\n申请" type:OrderHandleTypeSparepartsApply];
        [self addBtnWithTitle:@"排障\n历史" type:OrderHandleTypeSolveObstacleHis];
        
    }
    return self;
}


- (UIButton *)addBtnWithTitle:(NSString *)title type:(OrderHandleType)type
{
    UIButton *btn = [[UIButton alloc] init];
//    btn.titleLabel.text = title;
    btn.titleLabel.numberOfLines = 0;
    [btn setTitle:title forState:UIControlStateNormal];
    //77-134-179
    [btn setTitleColor:[UIColor colorWithRed:77/255.0 green:134/255.0 blue:179/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [btn setBackgroundImage:[UIImage imageNamed:@"kong_quan"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"shi_quan"] forState:UIControlStateSelected];
    
    btn.tag = type;
    [btn addTarget:self action:@selector(OrderHandle:) forControlEvents:UIControlEventTouchUpInside];
    [self.handleBtns addObject:btn];
    [self addSubview:btn];
    return btn;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    NSInteger count = self.handleBtns.count;
    for (int i = 0; i < count; i++) {
        UIButton *menuBtn = self.handleBtns[i];
        int delX = i % 3;
        int delY = i / 3;
        if (delX == 0) {
            menuBtn.x = OrderHandleBtnMarginX;
        }else{
            menuBtn.x = OrderHandleBtnMarginX + (OrderHandleBtnWH + OrderHandleBtnMarginX) * delX;
        }
        
        menuBtn.y = OrderHandleBtnMarginY + (OrderHandleBtnMarginY + OrderHandleBtnWH) * delY;
        
        menuBtn.width = OrderHandleBtnWH;
        menuBtn.height = OrderHandleBtnWH;
//        NSLog(@"menuBtn.frame:%@",NSStringFromCGRect(menuBtn.frame));
    }
}

- (void)OrderHandle:(UIButton *)handlBtn
{
    handlBtn.selected = !handlBtn.selected;
    NSLog(@"你点击了%ld",handlBtn.tag);
}
@end
