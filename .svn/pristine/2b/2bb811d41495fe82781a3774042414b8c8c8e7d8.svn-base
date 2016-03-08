//
//  HelpObjectList.m
//  Ericsson
//
//  Created by admin on 15/12/9.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HelpObjectList.h"
#import "ContactOrderViewCell.h"
#import "TechnicalManualDetailViewController.h"

@interface HelpObjectList()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong)NSIndexPath *selectedIndexpath;


@property (nonatomic, strong) UIWindow *applicationWindow;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITapGestureRecognizer *backgroundTapRecognizer;
@property (nonatomic, strong) UIView *popupView;
@property (nonatomic, strong) NSArray *views;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSString *selectedData;
@property (nonatomic, strong) UITextField *selectedObject;




@end
@implementation HelpObjectList

- (instancetype)initWithData:(NSMutableArray *)dataArr selectedData:(NSString *)selectedData selectedObject:(id )selectedObject{
    self = [super init];
    if (self) {
        _name = [[NSString alloc]init];
        _dataArr=dataArr;
        _selectedData=selectedData;
        _selectedObject=selectedObject;
        
        
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
    CGFloat maxPopupWidth = KIphoneWidth - 20;
    return maxPopupWidth;
}

#pragma mark - Presentation

- (void)presentPopupControllerAnimated {
    
    if ([self.delegate respondsToSelector:@selector(popupObjectListWillPresent:)]) {
        [self.delegate popupObjectListWillPresent:self];
    }
    
    // Keep a record of if the popup was presented with animation
    
    //[self applyTheme];
    [self calculateContentSizeThatFits:CGSizeMake([self popupWidth], self.maskView.bounds.size.height) andUpdateLayout:YES];
    //    self.popupView.center = [self originPoint];
    [self.applicationWindow addSubview:self.maskView];
    self.maskView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1.0;
        //  self.popupView.center = [self endingPoint];;
    } completion:^(BOOL finished) {
        self.popupView.userInteractionEnabled = YES;
        //        if ([self.delegate respondsToSelector:@selector(popupControllerDidPresent:)]) {
        //          //  [self.delegate popupControllerDidPresent:self];
        //        }
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
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_not_choose"] forState:UIControlStateNormal];
    }else{
        [cell.doneBtn setImage:[UIImage imageNamed:@"dialog_choose"] forState:UIControlStateNormal];
    }
    
    
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadAlertData];
    
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
/*
 requestModel  :  FSMInformation模块名
 requestMethod  : FSMGetTechManual方法名
 
 sessionId     :   会话id
 requestData   :{
 "techManualName":””  告警标题
 
 }
 
 响应数据值
 含义
 {
 “retCode”:”x” ;     0:请求成功  -1:请求失败  -2:回话sessionId 失效
 "techManuaList":{
 “techName”:””,    文档名
 “techUrl”:””     文档预览路径(注:手机端打开预览路径需要用techUrl+.android的路径)
 }
 }
*/
#pragma mark -- loadAlertData
- (void)loadAlertData{
    //准备请求参数
    NSString *modelName=@"FSMInformation";
    NSString *methodName=@"FSMGetTechManual";
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    //requestData是一个字典类型的参数  把参数与值一一对应存入数组中
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    //告警ID
    [parmeters setValue:_name forKey:@"techManualName"];
    NSString *sopeStr1= [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:parmeters];
    
    
    //最后，异步请求
    [[SoapService shareInstance] PostAsync:sopeStr1 Success:^(NSDictionary *dic) {
        
        if ([dic[@"retCode"] isEqual:@0]) {
            //将请求到的数据加入数组中
            dataArray = [NSMutableArray array];
            dataArray = dic[@"techManuaList"];
            
            //通知传值
            [[NSNotificationCenter defaultCenter]postNotificationName:@"presentwebviewNotification" object:dataArray];
        }
        
    } falure:^(NSError *response) {
        [self.maskView makeToast:@"告警详细查询出错！"];
    }];
    
    
}




- (UIWindow *)applicationWindow {
    return [[UIApplication sharedApplication] keyWindow];
}

@end

