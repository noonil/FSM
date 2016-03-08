//
//  HandlingOrderDetailController.m
//  Ericsson
//
//  Created by 范传斌 on 15/11/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//


#import "HandlingOrderDetailController.h"
#import "HeaderView.h"
#import "BottomTabBar.h"
#import "OrderSectionHeaderView.h"
#import "OrderInfoCell.h"
#import "OrderHandleTypeView.h"
#import "OilMachineInfoCell.h"
#import "WorkOrderDetail.h"
#import "WorkOrder.h"
#import "WorkOrderResource.h"
#import "OrderResourceViewCell.h"
#import "FeedBackInfoCell.h"
#import "PhaseFeedBackViewController.h"
#import "GenerateEleResultViewController.h"
#import "WithWorkResultViewController.h"
#import "TroubleResultViewController.h"
#import "WorkOrderBaseInfoFrame.h"
#import "BindOilMachine.h"
#import "BindOilMachineViewController.h"
#import "SearchViewController.h"//耗材查询
#import "SparesearchViewController.h"//备件查询
#import "ResourceAddViewController.h"//添加资源
#import "AvtiveTableViewController.h" // 告警查询
#import "TechnicalManualViewController.h" // 技术手册
#import "OperatingGuideViewController.h" // 操作规程
#import "HistoryListDetailViewController.h" // 排障历史
#import "NetResourceInfoViewController.h"//维护对象
#import "DetailViewController.h"//巡检详情
#import "RMDateSelectionViewController.h"
#import "MyLKDBHelper.h"
#import "ElectricTime.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能的头文件



#import "BusinessOwnerView.h"
#import "MaintanceObjInfoView.h"

#import "mediaViewController.h"

@interface HandlingOrderDetailController ()<UITableViewDataSource,UITableViewDelegate,OrderSectionHeaderViewDelegate,FeedBackInfoCellDelegate,BindOilMachineViewDelegate,UIGestureRecognizerDelegate, PopButtonsViewDelegate,BusinessOwnerViewDelegate,BMKLocationServiceDelegate, UIAlertViewDelegate>
{
    
    NSString *userId ;
    NSString *sessionId ;
    BMKLocationService * locService;
    
    double latitude;
    double longitude;
    
    double distance;

}
@property (nonatomic,strong)OrderHandleTypeView *handleView;
@property (nonatomic,strong)WorkOrderDetail *orderDetail;

@property (nonatomic,strong)NSMutableDictionary *showFlag;
@property (nonatomic,strong)WorkOrderStep *currentStep;
@property (nonatomic,strong)NSMutableArray *buttonTitleArray ;
@property (nonatomic,strong)ElectricTime *electricTime;

@property (nonatomic,strong)BusinessOwnerView *businessOwnerView;
//详情弹出框
@property (nonatomic,strong)FDAlertView *detailalert;


//弹出管理控制器
@property (nonatomic,strong)FDAlertView *alert;

@end

@implementation HandlingOrderDetailController

-(NSMutableDictionary *)showFlag{
    if (!_showFlag) {
        _showFlag = [[NSMutableDictionary alloc] init];
        for (int i = 0; i < 4; i++) {
            [_showFlag setObject:@1 forKey:[NSString stringWithFormat:@"%d",i]];
        }
    }
    return _showFlag;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"正在处理工单";

    
    // Do any additional setup after loading the view from its nib.
    self.HeaderView.imageView.image = [UIImage imageNamed:[self iconNameWithResourceType:self.workOrder.type]];
    
    if ([self.workOrder.type isEqualToString:@"发电"]) {
        [self.BottomBar.firstBtn setTitle:@"开始发电" forState:UIControlStateNormal];
         [self.BottomBar.thirdBtn setTitle:@"发电结束" forState:UIControlStateNormal];
    }else{
        [self.BottomBar.firstBtn setTitle:@"开始处理" forState:UIControlStateNormal];
         [self.BottomBar.thirdBtn setTitle:@"处理结束" forState:UIControlStateNormal];
    }
    
    [self.BottomBar.secondBtn setTitle:@"阶段反馈" forState:UIControlStateNormal];
   
    
    [self.BottomBar.firstBtn addTarget:self action:@selector(HandleStep:) forControlEvents:UIControlEventTouchUpInside];
    [self.BottomBar.secondBtn addTarget:self action:@selector(PhaseFeedBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.BottomBar.thirdBtn addTarget:self action:@selector(EndWorkOrder:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加工单操作视图
    self.handleView = [[OrderHandleTypeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.handleView.hidden = YES;
    [self.navigationController.view addSubview:self.handleView];
    
    self.alert = [[FDAlertView alloc] init];
    
    //接口油机绑定成功通知继续开始发电步骤
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartGenerateElectricity) name:@"SuccessBindOilMachine" object:nil];
    
    [self setOthers];
    
    //添加弹出界面的手势
    [self addGesture];
    

}

-(void)setOthers{
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    userId = [defaulsts objectForKey:@"username"];
    sessionId = [defaulsts objectForKey:@"sessionId"];
    
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;

}


#pragma mark - Gesture

-(void)addGesture{
    
    UITapGestureRecognizer* recognizer2;
    recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView)];
    recognizer2.delegate=self;
    [self.HeaderView addGestureRecognizer:recognizer2];
    
    

    
}


-(void)cellAddGesture:(UITableViewCell *) cell{
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell)];
    recognizer.delegate=self;
    [cell addGestureRecognizer:recognizer];
}


-(void)tapCell{
    
    //如果不是故障类工单，显示默认按钮数组
    if (![_workOrder.type  containsString:@"故障"]) {
        self.buttonTitleArray[0]=@"费用申请";
        
        self.popButtonView.hidden=NO;
        _popButtonView.buttonTitleArray=self.buttonTitleArray;
        [self.navigationController.view addSubview:_popButtonView];
        
        return;
        
        
        
    }
    
    
    //查询electricTime，确定popButtonView展示的开始发电按钮，结束发电按钮，展示的样子
    
    NSString *sql=[NSString stringWithFormat:@"select * from @t where woId='%@' and userId='%@'",self.woId, userId];
    NSMutableArray *array=[[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:sql toClass:[ElectricTime class]];
    
    

    if (array.count==0) {
        self.popButtonView.hidden=NO;
        _popButtonView.buttonTitleArray=self.buttonTitleArray;
    }
    else
    {
        ElectricTime *model=array[0];
        
        //如果选了发电开始时间，没选发电结束时间
        if (model.startElectricTime!=nil && model.endElectricTime==nil){
            
            
            self.popButtonView.buttonTitleArray=self.buttonTitleArray;
            [self.popButtonView.electricButton setTitle:@"结束发电" forState:UIControlStateNormal];
            self.popButtonView.hidden=NO;
            
        }
        //如果选了发电开始时间，也选了发电结束时间
        else if (model.startElectricTime!=nil && model.endElectricTime!=nil){
            
            
            self.popButtonView.buttonTitleArray=self.buttonTitleArray;
            [self.popButtonView.electricButton setTitle:@"结束发电" forState:UIControlStateNormal];
            self.popButtonView.hidden=NO;
            
            //把结束发电的按钮置灰
            self.popButtonView.electricButton.enabled=false;
            [self.popButtonView.electricButton setBackgroundImage:nil forState:UIControlStateNormal];
            [self.popButtonView.electricButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];

        }
        
    }
    

    [self.navigationController.view addSubview:_popButtonView];
}



-(void)tapHeaderView{
//    self.alert.contentView = self.businessOwnerView;
//    self.alert.contentView.hidden=NO;
//    [self.alert show];
    [self LoadMaintenanceObjectInfo];
    
}



#pragma mark -展示业主信息
-(void)LoadMaintenanceObjectInfo{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *params = @{@"userId":userId,
                             @"woId":_woId};
    

    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMworkOrder" methodName:@"FSMGetWOMObjectDetail" sessonId:sessionId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取取站点对象详情" toView:self.view];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([dic[@"retCode"] isEqual:@0]) {
            //            NSLog(@"dic:%@",dic);
            //弹出维护对象详情
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideDetailAlert)];
            [self.detailalert addGestureRecognizer:tap];
            
            MaintanceObjInfoView *contentView = [[MaintanceObjInfoView alloc] initWithFrame:CGRectMake(0, 0, 300, 350)];
            contentView.MaintanceOjbInfoArray = dic[@"objectDetail"];
            contentView.backgroundColor = [UIColor lightGrayColor];
            
            _detailalert.contentView = contentView;
            
            [_detailalert show];
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUDForView:self.view];
        [self.navigationController.view makeToast:@"请求发生错误"];
        
    }];
}


#pragma mark -delegate

- (void)hideDetailAlert
{
    [self.detailalert hide];
}
#pragma mark -BusinessOwnerViewDelegate

//-(void)BusinessOwnerViewTap{
//    
//    [self.alert hide];
//
//
//}

#pragma mark -PopButtonsViewDelegate

-(void)PopButtonsViewTap{
    

}

//点击弹出界面上的一个按钮
-(void)PopButtonsViewButtonTouchDown:(UIButton *)button{
    
    if ([button.titleLabel.text isEqualToString:@"耗材申请"]) {
        SearchViewController *vc=[[SearchViewController alloc]init];
        vc.handlingOrderDetail=self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        //显示可以关联工单用。
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        //[defaulsts setObject:self.orderDetail.baseInfo forKey:@"baseInfo"];
        NSData *tokenObject = [NSKeyedArchiver archivedDataWithRootObject:self.orderDetail.baseInfo];
        [defaulsts setObject:tokenObject forKey:@"baseInfo"];
        [defaulsts synchronize];
    }
    else if ([button.titleLabel.text isEqualToString:@"备件申请"]) {
        
        SparesearchViewController *vc=[[SparesearchViewController alloc]init]; 
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];

//        申请原因 ：获取对工单的内容描述
//        申请目的地：获取这个工单的维护对象名称
        NSDictionary * dicOrder = @{
                                    @"woNumber":_orderDetail.baseInfo.woNumber,
                                    @"woId":_workOrder.woId,
                                    @"applyReason":_orderDetail.baseInfo.contentDescribe,
                                    @"applyDestination":_orderDetail.baseInfo.maintenanceObject
                                    };
        [defaulsts setObject:dicOrder forKey:@"dicAssociateOrder"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"告警查询"]) {
        AvtiveTableViewController * vc = [[AvtiveTableViewController alloc]init];
        vc.maintenanceType_Id   = self.orderDetail.baseInfo.mObjectTypeId;
        vc.maintenance_Id           = self.orderDetail.baseInfo.maintenanceObjectId;
        vc.handlingOrderDetail=self;
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }else if ([button.titleLabel.text isEqualToString:@"技术手册"]) {
        TechnicalManualViewController * vc = [[TechnicalManualViewController alloc]init];
        vc.handlingOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"操作规程"]) {
        OperatingGuideViewController * vc = [[OperatingGuideViewController alloc]init];
        
        vc.woType           = self.orderDetail.baseInfo.woType;
        vc.woTypeId         = self.orderDetail.baseInfo.woTypeId;
        vc.woChildType      = self.orderDetail.baseInfo.woChildType;
        vc.woChildTypeId    = self.orderDetail.baseInfo.woChildTypeId;
        vc.handlingOrderDetail=self;

        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"排障历史"]) {
        HistoryListDetailViewController * vc = [[HistoryListDetailViewController alloc]init];
        NSString * station = self.workOrder.title;
        NSRange range = [station rangeOfString:@"_"];
        NSString * name = [station substringToIndex:range.location];
        vc.maintenanceName = name;
        NSLog(@"vc.maintenanceName=%@",name);
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([button.titleLabel.text isEqualToString:@"添加资源"]) {
        ResourceAddViewController *vc=[[ResourceAddViewController alloc]init];
        vc.handlingOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else if ([button.titleLabel.text isEqualToString:@"操作项"]) {
        DetailViewController *vc=[[DetailViewController alloc]init];
        vc.handlingOrderDetail=self;
        vc.woId=_woId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([button.titleLabel.text isEqualToString:@"维护对象"]) {
        NetResourceInfoViewController *vc=[[NetResourceInfoViewController alloc]init];
        vc.handlingOrderDetail=self;
        
        MatainObject *model=[[MatainObject alloc]init];
        model.maintenanceId=_orderDetail.baseInfo.maintenanceObjectId;
        model.maintenanceObjectType=_orderDetail.baseInfo.mObjectTypeId;
        model.maintenanceObjectTitle=_orderDetail.baseInfo.maintenanceObjectCode;
        vc.matainObject=model;

        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([button.titleLabel.text isEqualToString:@"开始发电"]) {
        RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
            NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
            
            NSString *startTimeStr= [self stringFromDate:((UIDatePicker *)controller.contentView).date];
            //把开始发电时间存到数据库
            ElectricTime *model=[[ElectricTime alloc]init];
            model.startElectricTime=startTimeStr;
            model.userId=userId;
            model.woId=_woId;
            self.electricTime=model;
            [[MyLKDBHelper getUsingLKDBHelper]insertToDB:model];
            

            
            
            self.popButtonView.hidden=NO;
            [self.popButtonView.electricButton setTitle:@"结束发电" forState:UIControlStateNormal];
            [self.navigationController.view addSubview:self.popButtonView];
            
        }];
        
        //Create cancel action
        RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
            NSLog(@"Date selection was canceled");

            self.popButtonView.hidden=NO;
            [self.navigationController.view addSubview:self.popButtonView];
            
            
        }];
        
        RMDateSelectionViewController *dateSelectionController=[self getDate:selectAction andCancelAction:cancelAction];
        

        [self presentViewController:dateSelectionController animated:YES completion:nil];
    }
    else if ([button.titleLabel.text isEqualToString:@"结束发电"]) {
        RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
            NSLog(@"Successfully selected date: %@", ((UIDatePicker *)controller.contentView).date);
            
            NSString *endTime= [self stringFromDate:((UIDatePicker *)controller.contentView).date];
            
            //把结束发电时间存到数据库
      
            
            
            NSString *sql=[NSString stringWithFormat:@"select * from @t where userId='%@' and woId='%@'", userId, _woId];
            NSMutableArray *array= [[MyLKDBHelper getUsingLKDBHelper]searchWithSQL:sql toClass:[ElectricTime class]];
            if (array.count>0) {
                ElectricTime *model=array[0];
                model.endElectricTime=endTime;
                self.electricTime=model;
                [[MyLKDBHelper getUsingLKDBHelper]updateToDB:model where:nil];
            }
            
            
 
        
            self.popButtonView.electricButton.enabled=false;
            [self.popButtonView.electricButton setBackgroundImage:nil forState:UIControlStateNormal];
            [self.popButtonView.electricButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            self.popButtonView.hidden=NO;
            [self.navigationController.view addSubview:self.popButtonView];
        }];
        
        //Create cancel action
        RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
            NSLog(@"Date selection was canceled");
            
            
            self.popButtonView.hidden=NO;
            [self.navigationController.view addSubview:self.popButtonView];
            
        }];
        
        //Create date selection view controller
        RMDateSelectionViewController *dateSelectionController=[self getDate:selectAction andCancelAction:cancelAction];
        
        [self presentViewController:dateSelectionController animated:YES completion:nil];
    }


}

-(RMDateSelectionViewController *)getDate:(nullable RMAction *)selectAction andCancelAction:(nullable RMAction *)cancelAction
{
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    
    dateSelectionController.title = @"录入时间选择";
    
    
    RMAction<RMActionController<UIDatePicker *> *> *nowAction = [RMAction<RMActionController<UIDatePicker *> *> actionWithTitle:@"Now" style:RMActionStyleAdditional andHandler:^(RMActionController<UIDatePicker *> * _Nonnull controller) {
        controller.contentView.date = [NSDate date];
        NSLog(@"Now button tapped");
    }];
    nowAction.dismissesActionController = NO;
    
    [dateSelectionController addAction:nowAction];
    
    //You can enable or disable blur, bouncing and motion effects
    //        dateSelectionController.disableBouncingEffects = !self.bouncingSwitch.on;
    //        dateSelectionController.disableMotionEffects = !self.motionSwitch.on;
    //        dateSelectionController.disableBlurEffects = !self.blurSwitch.on;
    
    //You can access the actual UIDatePicker via the datePicker property
    dateSelectionController.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    dateSelectionController.datePicker.minuteInterval = 5;
    dateSelectionController.datePicker.date = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
    
    //On the iPad we want to show the date selection view controller within a popover. Fortunately, we can use iOS 8 API for this! :)
    //(Of course only if we are running on iOS 8 or later)
    if([dateSelectionController respondsToSelector:@selector(popoverPresentationController)] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        //First we set the modal presentation style to the popover style
        dateSelectionController.modalPresentationStyle = UIModalPresentationPopover;
        
        //Then we tell the popover presentation controller, where the popover should appear
        dateSelectionController.popoverPresentationController.sourceView = self.tableView;
        dateSelectionController.popoverPresentationController.sourceRect = [self.tableView rectForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    return dateSelectionController;
}

- (NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-mm-dd hh:mm";
    NSString * dateStr = [fmt stringFromDate:date];
    NSLog(@"date======%@",dateStr);
    return dateStr;
}

#pragma mark - view controller
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //用于处理其他操作返回此界面刷新操作，否则界面保留旧数据
    [self loadWorkOrderInfo];
}

- (void)loadWorkOrderInfo{
    //重新加载前清除当前步骤
    self.currentStep = nil;
    
    //请求数据示例

    
    NSDictionary *params = @{@"userId":userId,@"woId":self.woId,@"isGetFinishDetail":@(self.isGetFinishDetail)};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetAcceptWODetail";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    MBProgressHUD *hud=[self showMessage:@"正在获取正在处理工单详情"];

    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [self hideHUDForView:nil mbProgressHud:hud];

        if ([dic[@"retCode"] isEqual:@0]) {
            self.orderDetail = [WorkOrderDetail objectWithKeyValues:dic];
            self.HeaderView.title.text = self.orderDetail.baseInfo.title;

            [self.tableView reloadData];
            
            //根据工单详情以及工单步骤确定底部工具栏
            for (WorkOrderStep *step in self.orderDetail.steps) {
                if ([step.taskName isEqualToString:@"阶段反馈"] || [step.taskName isEqualToString:@"稍后出发"] || [step.taskName containsString:@"费用"]) {
                    continue;
                }
                
                if (!step.finish && ![step.name isEqualToString:@"处理结束"] && ![step.name isEqualToString:@"结束发电"]) {
                    NSString *taskName = step.taskName;
                    if ([self.workOrder.type isEqualToString:@"发电"]) {
                        if ([step.taskName isEqualToString:@"开始处理"]) {
                            taskName = @"开始发电";
                        }
                    }
                    
                    [self.BottomBar.firstBtn setTitle:taskName forState:UIControlStateNormal];
                    self.currentStep = step;
                    break;
                }
                
            }
            
            if (self.currentStep == nil) {
                self.BottomBar.firstBtn.enabled = NO;
                [self.BottomBar.firstBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
            }
            
//            NSLog(@"step.taskName:%@,step.Name:%@",self.currentStep.taskName,self.currentStep.name);

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:KHudResponse1];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:KHudResponse2];
        }

    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:KHudErrorMessage];
    }];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.workOrder.type isEqualToString:@"发电"]) {
        return 4;
    }else
        return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderDetail == nil) {
        return 0;
    }
    
    if ([[self.showFlag objectForKey:[NSString stringWithFormat:@"%ld",section]] isEqual:@0]) {
        return 0;
    }
    
    if ([self.workOrder.type isEqualToString:@"发电"]) {
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return self.orderDetail.resourceList.count;
        }else if (section == 2){
            return 2;
        }else if (section == 3){
            return 1;
        }
    }else{
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return self.orderDetail.resourceList.count;
        }else if (section == 2){
            return 1;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderSectionHeaderView *headerView = [OrderSectionHeaderView orderSectionHeaderView];
    headerView.delegate = self;
    headerView.section = section;

    if ([self.workOrder.type isEqualToString:@"发电"]) {
        if (section == 0) {
            headerView.title.text = @"工单信息";
        }else if (section == 1){
            headerView.title.text = @"维护资源";
        }else if (section == 2){
            headerView.title.text = @"油机信息";
        }else{
            headerView.title.text = @"阶段反馈";
        }
    }else{
        if (section == 0) {
            headerView.title.text = @"工单信息";
        }else if (section == 1){
            headerView.title.text = @"维护资源";
        }else{
            headerView.title.text = @"阶段反馈";
        }
    }
    
    if ([[self.showFlag objectForKey:[NSString stringWithFormat:@"%ld",section]] isEqual:@0]) {
        headerView.tailIcon.image = [UIImage imageNamed:@"downpoint"];
    }else
        headerView.tailIcon.image = [UIImage imageNamed:@"uppoint"];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.workOrder.type isEqualToString:@"发电"]) {
        if (indexPath.section == 0) {
            OrderInfoCell *cell = [OrderInfoCell cellWithTableView:tableView];
            cell.workOrderBaseInfo = self.orderDetail.baseInfo;
            [self cellAddGesture:cell];
            return cell;
        }else if (indexPath.section == 1){
            WorkOrderResource *orderResource = self.orderDetail.resourceList[indexPath.row];
            OrderResourceViewCell *cell = [OrderResourceViewCell cellWithTableView:tableView];
            cell.resource = orderResource;
            [self cellAddGesture:cell];
            return cell;
        }else if (indexPath.section == 2){
            OilMachineInfoCell *cell = [OilMachineInfoCell cellWithTableView:tableView];
            if (indexPath.row == 1){
                cell.oilMachineInfo = self.orderDetail.oilMachine;
            }
            [self cellAddGesture:cell];
            return cell;
        }else if (indexPath.section == 3){
            FeedBackInfoCell *cell = [FeedBackInfoCell cellWithTableView:tableView];
            cell.FeedBacks = self.orderDetail.phaseFeedBack;
            cell.section = indexPath.section;
            cell.delegate = self;
            [self cellAddGesture:cell];
            return cell;
        }
    }else{
        if (indexPath.section == 0) {
            OrderInfoCell *cell = [OrderInfoCell cellWithTableView:tableView];
            cell.workOrderBaseInfo = self.orderDetail.baseInfo;
            [self cellAddGesture:cell];
            return cell;
        }else if (indexPath.section == 1){
            WorkOrderResource *orderResource = self.orderDetail.resourceList[indexPath.row];
            OrderResourceViewCell *cell = [OrderResourceViewCell cellWithTableView:tableView];
            cell.resource = orderResource;
            [self cellAddGesture:cell];
            return cell;
        }else if (indexPath.section == 2){
            FeedBackInfoCell *cell = [FeedBackInfoCell cellWithTableView:tableView];
            cell.FeedBacks = self.orderDetail.phaseFeedBack;
            cell.section = indexPath.section;
            cell.delegate = self;
            [self cellAddGesture:cell];
            return cell;
        }
    }
    
    return  nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.workOrder.type isEqualToString:@"发电"]) {
        if (indexPath.section == 0) {
            WorkOrderBaseInfoFrame *baseInfoFrame = [[WorkOrderBaseInfoFrame alloc] init];
            baseInfoFrame.baseInfo = self.orderDetail.baseInfo;
            return baseInfoFrame.cellHeight;
            
        }else if (indexPath.section == 1){
            return 50;
        }else if (indexPath.section == 2){
            return 50;
        }else if (indexPath.section == 3){
            CGFloat height = 0;
            for (WorkOrderPhaseFeedBack *feedBack in self.orderDetail.phaseFeedBack) {
                height +=(50 + feedBack.attachFiles.count * 50);
            }
            return height;
        }
    }else{
        if (indexPath.section == 0) {
            WorkOrderBaseInfoFrame *baseInfoFrame = [[WorkOrderBaseInfoFrame alloc] init];
            baseInfoFrame.baseInfo = self.orderDetail.baseInfo;
            return baseInfoFrame.cellHeight;
        }else if (indexPath.section == 1){
            return 50;
        }else if (indexPath.section == 2){
            CGFloat height = 0;
            for (WorkOrderPhaseFeedBack *feedBack in self.orderDetail.phaseFeedBack) {
                height +=(50 + feedBack.attachFiles.count * 50);
            }
            return height;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)HandleStep:(UIButton *)btn
{
    NSLog(@"点击了第一个按钮");
    
    
    NSString *methodName;
    NSDictionary *params = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    if ([self.currentStep.name isEqualToString:@"到达"]) {
        methodName = @"FSMWOArrive";
        params = @{@"userId":userId,@"woId":self.workOrder.woId,@"operMBPS":self.currentStep.name,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"processId":@"0"};
        [self HandleStepWithMethodName:methodName andParams:params];

    }else if ([self.currentStep.name isEqualToString:@"出发"]){
        methodName = @"FSMStartOff";
        params = @{@"userId":userId,@"woIds":@[self.workOrder.woId],@"operMBPS":self.currentStep.name,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"processId":@"0"};
        [self HandleStepWithMethodName:methodName andParams:params];

    }else if ([self.currentStep.name isEqualToString:@"入站"]){
        methodName = @"FSMWOEnter";
        params = @{@"userId":userId,@"woId":self.workOrder.woId,@"operMBPS":self.currentStep.name,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"processId":@"0"};
        [self HandleStepWithMethodName:methodName andParams:params];

    }else if ([self.currentStep.name isEqualToString:@"暂停发电"]){
        methodName = @"FSMWOPauseGenerateElectricity";
        params = @{@"userId":userId,@"woId":self.workOrder.woId,@"operMBPS":self.currentStep.name};
        [self HandleStepWithMethodName:methodName andParams:params];

    }else if ([self.currentStep.name isEqualToString:@"恢复发电"]){
        methodName = @"FSMWORecoverGenerateElectricity";
        params = @{@"userId":userId,@"woId":self.workOrder.woId,@"operMBPS":self.currentStep.name,@"remark":@"",@"time":currentDate};
        [self HandleStepWithMethodName:methodName andParams:params];

    }else if ([self.currentStep.name isEqualToString:@"稍后出发"]){
        methodName = @"FSMDepartLater";
        params = @{@"woId":self.workOrder.woId,@"operMBPS":self.currentStep.name,@"remark":@"",@"time":currentDate};
        [self HandleStepWithMethodName:methodName andParams:params];

    }
    
    //特殊处理，发电类型工单开始节点为“开始发电”，但是数据返回为"开始处理"
    
    if ([self.BottomBar.firstBtn.titleLabel.text isEqualToString:@"开始处理"]) {
        [MBProgressHUD showMessage:@"经纬度获取中"];
        
        // 启动LocaltionSerview
        [locService startUserLocationService];
        
        
        


    }else if ([self.BottomBar.firstBtn.titleLabel.text isEqualToString:@"开始发电"]){
        //进行油机绑定选择
        BindOilMachine *contentView = [[NSBundle mainBundle] loadNibNamed:@"BindOilMachine" owner:nil options:nil].lastObject;
        contentView.delegate = self;
        contentView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 200);
        self.alert.contentView = contentView;
        [self.alert show];
        
    }
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    latitude = userLocation.location.coordinate.latitude;
    longitude = userLocation.location.coordinate.longitude;
    NSLog(@"1===%f",latitude);
    NSLog(@"2===%f",longitude);
    

    
    [locService stopUserLocationService];
    
    [MBProgressHUD hideHUD];
    
    [self caculateDistance:latitude lon:longitude lat2:[self.orderDetail.baseInfo.mObjectLan doubleValue] lon:[self.orderDetail.baseInfo.mObjectLon doubleValue]];
    

    
    
}

-(void)caculateDistance:(double)lat1 lon:(double)lon1 lat2:(double)lat2  lon:(double)lon2 {
    //请求数据示例
    CLLocation *orig=[[CLLocation alloc] initWithLatitude:lat1  longitude:lon1] ;
    CLLocation* dist=[[CLLocation alloc] initWithLatitude:lat2  longitude:lon2] ;
    
    distance=[orig distanceFromLocation:dist]/1000;
    NSLog(@"距离:%lf",distance);
    
    if (distance>0.1) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"当前经纬度（%lf, %lf）\n 距离维护对象%lf公里。 \n 距离维护对象的位置超过100米 \n 是否继续",lon1,lat1, distance] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        alert.delegate=self;

        [alert show];
    }
    else{
        [self beginWork];
    
    }
   
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //如果是关联工单的alertView
    if (buttonIndex==1) {

        [self beginWork];
    }
}

//开始处理
-(void)beginWork{
    NSString *methodName;
    NSDictionary *params = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    
    methodName = @"FSMWOStart";
    params = @{@"userId":userId,
               @"startHandleTime":currentDate,
               @"woId":self.workOrder.woId==nil? @"":self.workOrder.woId,
               @"operMBPS":self.currentStep.name==nil? @"":self.currentStep.name,
               @"taskName":self.currentStep.taskName==nil? @"":self.currentStep.taskName,
               @"taskId":self.currentStep.taskId==nil? @"":self.currentStep.taskId,
               @"processId":@"0"};
    
    NSLog(@"userId=%@",userId);
    NSLog(@"workOrder.woId=%@",self.workOrder.woId);
    NSLog(@"currentStep=%@",self.currentStep);
    NSLog(@"currentStep.name=%@",self.currentStep.name);
    NSLog(@"currentStep.taskName=%@",self.currentStep.taskName);
    NSLog(@"currentStep.taskId=%@",self.currentStep.taskId);
    [self HandleStepWithMethodName:methodName andParams:params];
}



- (void)StartGenerateElectricity
{
    NSLog(@"油机绑定成功，继续开始发电");
 
#warning 在开始发电之前需要做测距以及操作项管理，考虑此功能属于其他模块功能，考虑在确认没问题后集成进来,暂时不影响流程步骤操作
    

    NSString *methodName = @"FSMWOStartGenerateElectricity";
    NSDictionary *params = @{@"userId":userId,@"woId":self.workOrder.woId,@"operMBPS":self.currentStep.name,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"processId":@"0"};
    [self HandleStepWithMethodName:methodName andParams:params];
}

- (void)PhaseFeedBack:(UIButton *)btn
{
//    PhaseFeedBackViewController *phaseFeedBack = [[PhaseFeedBackViewController alloc] initWithNibName:@"PhaseFeedBackViewController" bundle:nil];
//    phaseFeedBack.workOrder = self.workOrder;
//    phaseFeedBack.currentStep = self.currentStep;
//    [self.navigationController pushViewController:phaseFeedBack animated:YES];

        mediaViewController * meidaVC = [[mediaViewController alloc]init];
        meidaVC.navigationTitle = @"阶段反馈";
        meidaVC.woId = self.workOrder.woId;
        [self.navigationController pushViewController:meidaVC animated:YES];
 
    
}

- (void)EndWorkOrder:(UIButton *)btn
{
    if ([self.workOrder.type containsString:@"发电"]) {
        GenerateEleResultViewController *generateEleResult = [[GenerateEleResultViewController alloc] initWithNibName:@"GenerateEleResultViewController" bundle:nil];
        generateEleResult.rootController = self.rootController;
        generateEleResult.workOrder =self.workOrder;
        generateEleResult.currentStep = self.currentStep;
        [self.navigationController pushViewController:generateEleResult animated:YES];
    }else if ([self.workOrder.type containsString:@"故障"]){
        TroubleResultViewController *troubleResult = [[TroubleResultViewController alloc] initWithNibName:@"TroubleResultViewController" bundle:nil];
        troubleResult.rootController = self.rootController;
        troubleResult.workOrderDetail = self.orderDetail;
        troubleResult.workOrder = self.workOrder;
        troubleResult.currentStep = self.currentStep;
        troubleResult.electricTime=_electricTime;
        [self.navigationController pushViewController:troubleResult animated:YES];
    }else{
        WithWorkResultViewController *withWorkResult = [[WithWorkResultViewController alloc] initWithNibName:@"WithWorkResultViewController" bundle:nil];
        withWorkResult.rootController = self.rootController;
        withWorkResult.workOrder = self.workOrder;
        withWorkResult.currentStep = self.currentStep;
        [self.navigationController pushViewController:withWorkResult animated:YES];
    }
    
}

- (void)HandleStepWithMethodName:(NSString *)methodName andParams:(NSDictionary *)params{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    

    
    NSString *modelName=@"FSMworkOrder";
    
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    
    MBProgressHUD *hud=[self showMessage:@"正在提交请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [self hideHUDForView:nil mbProgressHud:hud];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [self loadWorkOrderInfo];
            [self.navigationController.view makeToast:KHudSuccessMessage];
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:KHudResponse1];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.view makeToast:KHudResponse2];
        }

    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:KHudErrorMessage];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)iconNameWithResourceType:(NSString *)type{
    if ([type containsString:@"发电"]) {
        return @"wo_elect";
    }else if ([type containsString:@"故障"]){
        return @"wo_tr";
    }else
        return @"wo_with";
}

#pragma mark - OrderSectionHeaderViewDelegate

-(void)OrderSectionHeaderViewClick:(NSInteger)section{
    //做收缩切换
    NSNumber *flag = [self.showFlag objectForKey:[NSString stringWithFormat:@"%ld",section]];
    if ([flag isEqual:@0]) {
        flag = @1;
    }else{
        flag = @0;
    }
    
    [self.showFlag setObject:flag forKey:[NSString stringWithFormat:@"%ld",section]];
    [self.tableView reloadData];
}


#pragma mark - FeedBackInfoCellDelegate
-(void)FeedBackInfoRefreshWith:(NSInteger)section{
    [self.tableView reloadData];
}


#pragma mark - BindOilMachineViewDelegate
- (void)bindOilMachineWithCancelType
{
    [self.alert hide];
}

- (void)bindOilMachineWithBindType
{
    [self.alert hide];
    //弹出油机绑定界面
    BindOilMachineViewController *bindOilMachine = [[BindOilMachineViewController alloc] init];
    bindOilMachine.order = self.workOrder;
    [self.navigationController pushViewController:bindOilMachine animated:YES];
    
}


#pragma mark - get/set
-(PopButtonsView *)popButtonView{
    if (_popButtonView==nil) {
        _popButtonView=[[PopButtonsView alloc]initWithFrame:CGRectMake(0,0, KIphoneWidth, KIphoneHeight )];
        _popButtonView.delegate=self;
        _popButtonView.backgroundColor=[UIColor colorWithRed:200 green:200 blue:200 alpha:0.8];


    }
    return _popButtonView;

}
-(NSMutableArray *)buttonTitleArray{
    if (_buttonTitleArray==nil) {
        _buttonTitleArray=[NSMutableArray arrayWithObjects:@"开始发电",@"添加资源",@"告警查询",
                           @"费用上报",@"维护对象",@"技术手册",
                           @"费用分摊",@"操作项",@"操作规程",
                           @"耗材申请",@"备件申请",@"排障历史", nil];
    }
    return _buttonTitleArray;
    
}



-(BusinessOwnerView *)businessOwnerView{
    
    if (_businessOwnerView==nil) {
        _businessOwnerView=[[BusinessOwnerView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth*0.9, KIphoneHeight*0.7)];
        _businessOwnerView.delegate=self;
        
    }
    return _businessOwnerView;
    
}

-(FDAlertView *)detailalert{

    if (_detailalert==nil) {
        _detailalert=[[FDAlertView alloc]init];
    }
    return _detailalert;
}


- (MBProgressHUD *)showMessage:(NSString *)message{
    UIView *view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = YES;
    return hud;
}

- (void)hideHUDForView:(UIView *)view mbProgressHud:(MBProgressHUD *)hud
{
    if (view == nil)
        view = [[UIApplication sharedApplication].windows lastObject];
    
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];

    }

}


#pragma mark -get/set
//-(ElectricTime *)electricTime{
//    if (_electricTime==nil) {
//        _electricTime=[[ElectricTime alloc]init];
//    }
//    return _electricTime;
//
//}



#pragma  mark - dealloc

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
