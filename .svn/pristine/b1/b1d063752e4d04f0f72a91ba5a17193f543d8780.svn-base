//
//  PopupObjectList.m
//  Ericsson
//
//  Created by xuming on 15/11/30.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "PopupObjectList.h"
#import "ContactOrderViewCell.h"

@interface PopupObjectList()<UITableViewDataSource, UITableViewDelegate>{

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *selectedIndexpath;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *selectedData;
@property (nonatomic, strong) id fromWhichObject;

@property (nonatomic, strong) UIWindow *applicationWindow;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapRecognizer;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) UIButton *cancelBtn;





@end
@implementation PopupObjectList


-(instancetype)init{
    if ([super init]) {
        self.popupView = [[UIView alloc] initWithFrame:CGRectZero];
        self.popupView.backgroundColor = [UIColor whiteColor];
        self.popupView.clipsToBounds = YES;
        
        self.maskView = [[UIView alloc] initWithFrame:self.applicationWindow.bounds];
        self.maskView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        [self.maskView addSubview:self.popupView];
        
        [self addPopupContents];
        
    }
    return self;

}

- (instancetype)initWithData:(NSMutableArray *)dataArr selectedData:(NSString *)selectedData fromWhichObject:(id )fromWhichObject{
    
        self=[self init];

        _dataArr=dataArr;
        _selectedData=selectedData;
        _fromWhichObject=fromWhichObject;
        
        


    return self;
}

#pragma mark - Popup Building

- (void)addPopupContents {

    [self.popupView addSubview:self.tableView];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [_cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    _cancelBtn.backgroundColor = KBaseBlue;
    [_cancelBtn addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];

    
    [self.popupView addSubview:_cancelBtn];

}

- (void)buttonTouched {
    [self dismissPopupControllerAnimated];
}

- (void)calculateContentSizeThatFits:(CGSize)size andUpdateLayout:(BOOL)update
{
    float insetWidth = KIphoneWidth * 0.2;
    float insetHeight = KIphoneHeight * 0.3;
    float cancelBtnHeight = 40;
    
    float popWidth=KIphoneWidth-insetWidth;
    float popHeight=KIphoneHeight-insetHeight;
    self.popupView.frame=CGRectMake(insetWidth/2, insetHeight/2, popWidth, popHeight);
    
    float tableHeight=popHeight-cancelBtnHeight;
    self.tableView.frame=CGRectMake(0, 0, popWidth, tableHeight);

    self.tableView.bounces = NO;
    
    CGRect rect=self.cancelBtn.frame;
    rect.origin=CGPointMake(0, tableHeight);
    
    self.cancelBtn.frame=CGRectMake(0, tableHeight, popWidth, popHeight-tableHeight);
    
}



- (CGFloat)popupWidth {
    CGFloat maxPopupWidth = KIphoneWidth-20;
    return maxPopupWidth;
}

#pragma mark - Presentation

- (void)presentPopupControllerAnimated {
    
    if ([self.delegate respondsToSelector:@selector(popupObjectListWillPresent:)]) {
        [self.delegate popupObjectListWillPresent:self];
    }
    
    // Keep a record of if the popup was presented with animation
    
    [self calculateContentSizeThatFits:CGSizeMake([self popupWidth], self.maskView.bounds.size.height) andUpdateLayout:YES];
    [self.applicationWindow addSubview:self.maskView];
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.popupView.userInteractionEnabled = YES;

    }];
}


#pragma  - dismiss
- (void)dismissPopupControllerAnimated{
    if ([self.delegate respondsToSelector:@selector(popupObjectListWillDismiss:)]) {
        [self.delegate popupObjectListWillDismiss:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(popupObjectListDidDismiss:)]) {
            [self.delegate popupObjectListDidDismiss:self];
        }
    }];
}


#pragma  mark -tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ContactOrderViewCell *cell = [ContactOrderViewCell cellWithTableView:tableView ];
    

    
    cell.orderName.text = _dataArr[indexPath.row];
    if ([_dataArr[indexPath.row] isEqualToString:_selectedData]) {
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_choosed"] forState:UIControlStateNormal];
    }else{
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_not_choose"] forState:UIControlStateNormal];
    }
    
    cell.doneBtn.userInteractionEnabled = NO;
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    if ([self.delegate respondsToSelector:@selector(popupObjectListDidSelectRowAtIndexPath:fromWhichObject:row:)]) {
        
        [self.delegate popupObjectListDidSelectRowAtIndexPath :_dataArr[indexPath.row] fromWhichObject:_fromWhichObject row:indexPath.row ];
    }
    
    [self dismissPopupControllerAnimated];
    
}

#pragma  mark -get/set
-(UITableView *)tableView{
    
    if (_tableView==nil) {
        
        _tableView=[[UITableView alloc]initWithFrame:CGRectZero];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        // [_tableView registerClass:[ObjectListCell class] forCellReuseIdentifier:@"Cell"];
        
    }
    return _tableView;
}




- (UIWindow *)applicationWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

@end

