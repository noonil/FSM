//
//  HandingDetailViewController.m
//  Ericsson
//
//  Created by Slark on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "HandingDetailViewController.h"
#import "HeaderView.h"
#import "handDetailTableViewCell.h"
#import "HandingDeatilModel.h"
#import "stateBackViewController.h"
#import "FinishCommitViewController.h"
#import "feedBackListModel.h"
#import "feedBackTableViewCell.h"
#import "WorkOrderBaseInfo.h"
#import "MatainObject.h"
#import "ResourceAddViewController.h"//添加资源
#import "NetResourceInfoViewController.h"//维护对象
#import "SearchViewController.h"//耗材查询
#import "SparesearchViewController.h"//备件查询
#import "ResourceAddViewController.h"//添加资源
#import "AvtiveTableViewController.h" // 告警查询
#import "TechnicalManualViewController.h" // 技术手册
#import "OperatingGuideViewController.h" // 操作规程
#import "HistoryListDetailViewController.h" // 排障历史
#import "DetailViewController.h" //操作项
#import "MeViewController.h"
#import "WorkOrderStep.h"
#import "OrderSectionHeaderView.h"
#import "OrderInfoCell.h"
#import "OrderHandleTypeView.h"
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

@interface HandingDetailViewController ()<UITableViewDataSource,UITableViewDelegate,sendBackDelegate,PopButtonsViewDelegate,UIGestureRecognizerDelegate,BMKLocationServiceDelegate>{
    int _num[30];
    UIButton * ffirstButton;
    UIButton * ssecondButton;
    UIButton * threeButton;
    BOOL isSelected;
    BOOL isSelect;
    NSString *userId ;
    NSString *sessionId ;
    BMKLocationService * locService;
    double latitude;
    double longitude;
    CLLocationDistance distance;
    NSString *phoneNum;
}
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSArray * array;
@property (nonatomic,strong)NSDictionary * dict;
@property (nonatomic,copy)NSString * taskName;
@property (nonatomic,copy)NSString * taskId;
@property (nonatomic,strong)WorkOrderBaseInfo * model;
@property (nonatomic,strong)NSMutableArray * feedBackArray;
@property (nonatomic,copy)NSString * timeStr;
@property (nonatomic,copy)NSString * str;
@property (nonatomic,strong) NSMutableArray * giveArray;
@property (nonatomic, strong) NSMutableArray *buttonTitleArray;
@property (nonatomic,strong)UITapGestureRecognizer * tap;
@property (nonatomic,strong)NSMutableArray * woIdsArr;
@property (nonatomic,strong)WorkOrderStep *currentStep;
@property (nonatomic,strong)OrderHandleTypeView *handleView;
@property (nonatomic,strong)WorkOrderDetail *orderDetail;
@property (nonatomic,strong)NSMutableDictionary *showFlag;
@property (nonatomic,strong)ElectricTime *electricTime;
- (IBAction)callClick:(id)sender;

//详情弹出框
@property (nonatomic,strong)FDAlertView *detailalert;

@end

@implementation HandingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestDatam];
    self.navigationItem.title = @"正在处理巡检工单详情";
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    [self setOthers];
    [self createUI];
    self.RView.hidden = YES;
    self.feedBackArray = [NSMutableArray array];
    
    [self LoadMaintenanceObjectInfo];

    ffirstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    ssecondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    threeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
}
-(void)setOthers{
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    userId = [defaulsts objectForKey:@"username"];
    sessionId = [defaulsts objectForKey:@"sessionId"];
    
}
- (NSMutableArray*)woIds{
    
    if(_woIdsArr == nil){
        
        _woIdsArr = [[NSMutableArray alloc]init];
        
    }
    return _woIdsArr;
}

- (NSMutableArray*)giveArray{
    
    if (_giveArray == nil) {
        
        _giveArray = [[NSMutableArray alloc]init];
        
    }
    return _giveArray;
}

- (void)feedBackValues:(NSString *)str andTimeString:(NSString *)timeStr{
    
    self.str = str;
    self.timeStr = timeStr;
    feedBackListModel * model = [[feedBackListModel alloc]init];
    model.str = self.str;
    model.time = self.timeStr;
    [self.feedBackArray addObject:model];
    [self.tabelView reloadData];
    
}

#pragma mark 请求数据
- (void)requestDatam{
      self.currentStep = nil;
    
    self.dataArr = [NSMutableArray array];
    self.dict = [[NSDictionary alloc]init];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * userId = [defaults objectForKey:@"username"];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMGetAcceptWODetail";
    NSDictionary * params = @{@"userId":userId,
                              @"woId":self.woId,
                              @"isGetFinishDetail":@"false"};
    
    NSString * sopStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
    [MBProgressHUD showMessage:@"正在请求数据请稍后"];
    [[SoapService shareInstance] PostAsync:sopStr Success:^(NSDictionary *dicm) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showSuccess:@"请求成功"];
    
        if ([dicm[@"retCode"] isEqual:@0])
        {
          self.orderDetail = [WorkOrderDetail objectWithKeyValues:dicm];
           
            [self.tabelView reloadData];
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
                    
                    [self.firstButton setTitle:taskName forState:UIControlStateNormal];
                    self.currentStep = step;
                    break;
                }
                
            }
            
            if (self.currentStep == nil) {
                self.firstButton.enabled = NO;
                [self.firstButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
            }

                
                
                
            
//            NSArray * array = dicm[@"steps"];
//            for (NSDictionary * dict in array) {
//            
//                if ([dict[@"finish"] isEqual:@0]) {
//                    
//                    if ([dict[@"name"] isEqualToString:@"稍后出发"]) {
//
//                        continue;
//                    }
//                    
//                    if ([dict[@"name"] isEqualToString:@"处理结束"]) {
//                        [self.firstButton setTitle:@"开始处理" forState:UIControlStateNormal];
//                        self.firstButton.userInteractionEnabled = NO;
//                        self.firstButton.alpha = 0.4;
//                        break;
//                    }
//                    
//                    [self.firstButton setTitle:dict[@"name"] forState:UIControlStateNormal];
//                    
//                    break;
//                    
//                }
//                
//                
//            }
            
            _dict = dicm[@"baseInfo"];
           _model  = [[WorkOrderBaseInfo alloc]init];
            [_model setValuesForKeysWithDictionary:_dict];
            self.dataArr = [NSMutableArray arrayWithObjects:_model.maintenanceObjectType,_model.maintenanceObjectLevel,_model.priority,_model.woType,@"",_model.woNumber,_model.planArriveTime,_model.planFinishTime,@"",@"",_model.state, nil];
            
            self.machineName.text = _model.title;
            self.machineNumber.text = _model.maintenanceObjectCode;
            self.machineLevel.text = _model.maintenanceObjectLevel;
            self.machineAddress.text = _model.address;
            self.connectStyle.text = phoneNum;
            self.longitude.text = _model.mObjectLon;
            self.latitude.text = _model.mObjectLan;
            self.ownerName.text = @"";
            
            
            
            
            
            
            [self.tabelView reloadData];
        }else if ([dicm[@"retCode"] isEqual:@(-1)]){
            
            [self.navigationController.view makeToast:@"请求失败"];
            
            
        }else if ([dicm[@"retCode"] isEqual:@(-2)]){
            
            
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时,请重新登录"];

        }
       
    } falure:^(NSError *response) {
     
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:KHudErrorMessage];

    }];
    
    
    
    
}
-(void)LoadMaintenanceObjectInfo{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessonId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,
                             @"woId":_woId};
 
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMworkOrder" methodName:@"FSMGetWOMObjectDetail" sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    

    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
     
        if ([dic[@"retCode"] isEqual:@0]) {
            //弹出维护对象详情
            NSLog(@"%@",dic);
           NSArray *arr = dic[@"objectDetail"];
            
            phoneNum = arr[4][@"value"];

        }    } falure:^(NSError *err) {
        
        [self.navigationController.view makeToast:@"请求发生错误"];
      
    }];

}

#pragma mark 距离定位
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
        [self workStart];
        
    }
    
}

#pragma mark - alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //如果是关联工单的alertView
    if (buttonIndex==1) {
        
        [self workStart];
    }
}





- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        
    if (indexPath.section == 0) {
      
        handDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OPP" forIndexPath:indexPath];
        NSString * str = _array[indexPath.row];
        
        cell.TopLabel.text = str;
        
        NSMutableArray * arr = [NSMutableArray arrayWithArray:_dataArr];
        
        cell.TextLabel.text = arr[indexPath.row];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnce)];
        _tap.delegate=self;
        
        [cell addGestureRecognizer:_tap];
         return cell;
    }
    else if(indexPath.section == 2){
        
        feedBackTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PEACE" forIndexPath:indexPath];
        
        feedBackListModel * model  = _feedBackArray[indexPath.row];
        cell.timeLabel.text = model.time;
        cell.secLabel.text = model.str;
        
        return cell;
    }else if(indexPath.section == 3){
        
        return nil;
        
    }else{
        
        return nil;
    }


}





- (void)createUI{
   
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
  
    self.headerView.imageView.image = [UIImage imageNamed:@"wo_with"];
    self.headerView.title.text = self.Maintitle;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapTouch)];
    [self.headerView addGestureRecognizer:tap];
    
    self.array = [NSArray arrayWithObjects:@"维护对象类型:",@"维护对象等级",@"优先级:",@"工单类型:",@"告警级别:",@"工单编号",@"要求到达时间",@"要求完成时间",@"内容描述",@"工单影响范围",@"工单状态",nil];
    
    [self.tabelView registerNib:[UINib nibWithNibName:@"handDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"OPP"];

    [self.tabelView registerNib:[UINib nibWithNibName:@"feedBackTableViewCell" bundle:nil] forCellReuseIdentifier:@"PEACE"];
}

- (void)tapTouch{
    
    if (_num[20] == 0) {
        self.RView.hidden = NO;
        self.RView.alpha = 1;
        self.RView.backgroundColor = [UIColor whiteColor];
        self.tabelView.alpha = 0.3;
        self.headerView.alpha = 0.3;
        self.tabelView.userInteractionEnabled = NO;
    }else{
        self.RView.hidden = YES;
        self.tabelView.alpha = 1;
        self.headerView.alpha = 1;
        self.tabelView.userInteractionEnabled = YES;
           }
    
    _num[20] = !_num[20];
    
    
   
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 3;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    
    
     if (section == 0) {
     
     if (isSelected) {
     return 0;
     
     }else{
     
     return _dataArr.count;
     }
     }
     
     if (section == 1) {
     return 0;
     }
     
     if (section == 2) {
         if (isSelect) {
             return 0;
             
         }else{
             
             return _feedBackArray.count;
         }

         
         
     }
     if (section == 3) {
     return 0;
     }else{
     
     return 0;
     }
     
     }

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     
     UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
     
     if (section == 0) {
     UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
     label.text = @"工单信息";
     
     ffirstButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 30, 30);
     [ffirstButton setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
     [ffirstButton setImage:[UIImage imageNamed:@"uppoint.png"] forState:UIControlStateSelected];
     [ffirstButton addTarget:self action:@selector(ClickSe:) forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:label];
     [view addSubview:ffirstButton];
      
         UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
         button.frame = CGRectMake(0 , 0, 280, 40);
         [button addTarget:self action:@selector(ClickSe:) forControlEvents:UIControlEventTouchUpInside];
         
         [view addSubview:button];
         
     return view;
     }
     if (section == 1) {
     
     UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
     label.text = @"维护资源";
     
     ssecondButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 30, 30);
     [ssecondButton setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
     [ssecondButton setImage:[UIImage imageNamed:@"uppoint.png"] forState:UIControlStateSelected];
     [ssecondButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:label];
     [view addSubview:ssecondButton];
     return view;
     
     }
     if (section == 2) {
     
     UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
     label.text = @"阶段反馈";
     
     threeButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 30, 30);
     [threeButton setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
     [threeButton setImage:[UIImage imageNamed:@"uppoint.png"] forState:UIControlStateSelected];
     [threeButton addTarget:self action:@selector(thirClick:) forControlEvents:UIControlEventTouchUpInside];
     [view addSubview:label];
     [view addSubview:threeButton];
     return view;
     }
    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 30;
}





- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 50;
}

- (void)thirClick:(UIButton*)button{
    
   
    if (isSelect) {
        button.selected =YES;
    }else{
        
        button.selected = NO;
    }
    isSelect = !isSelect;
    
    [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)ClickSe:(UIButton*)button{
    
    if (isSelected) {
        button.selected =YES;
    }else{
        
        button.selected = NO;
    }
    isSelected = !isSelected;
    
    [self.tabelView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void)buttonClick:(UIButton*)button{
    
   
    button.selected = !button.selected;
    
    [_tabelView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
     _num[1] = !_num[1];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    [self.tabelView deselectRowAtIndexPath:indexPath animated:YES];
   
    if (indexPath.section == 0) {
       

        _num[18] = !_num[18];
    }
  
    
    
}

- (void)btClick:(UIButton*)button{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark 状态按钮点击
- (IBAction)firstClick:(id)sender {
    
    NSString *methodName;
    NSDictionary *params = nil;
    NSMutableArray * dd = [[NSMutableArray alloc]init];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
        
        if ([self.currentStep.name isEqualToString:@"到达"]) {
            methodName = @"FSMWOArrive";
            params = @{@"userId":userId,
                       @"woId":self.woId,
                       @"operMBPS":self.currentStep.name,
                       @"taskName":self.currentStep.taskName,
                       @"taskId":self.currentStep.taskId,
                       @"processId":@"0"};
            [self HandleStepWithMethodName:methodName andParams:params];
            
        }else if ([self.currentStep.name isEqualToString:@"出发"]){
            methodName = @"FSMStartOff";
            params = @{@"userId":userId,
                       @"woIds":@[self.woId],
                       @"operMBPS":self.currentStep.name,
                       @"taskName":self.currentStep.taskName,
                       @"taskId":self.currentStep.taskId,
                       @"processId":@"0"};
            [self HandleStepWithMethodName:methodName andParams:params];
            
        }else if ([self.currentStep.name isEqualToString:@"入站"]){
            methodName = @"FSMWOEnter";
            params = @{@"userId":userId,@"woId":self.woId,@"operMBPS":self.currentStep.name,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"processId":@"0"};
            [self HandleStepWithMethodName:methodName andParams:params];
            
        }else if ([self.currentStep.name isEqualToString:@"稍后出发"]){
            methodName = @"FSMDepartLater";
            params = @{@"woId":self.workOrder.woId,@"operMBPS":self.currentStep.name,@"remark":@"",@"time":currentDate};
            [self HandleStepWithMethodName:methodName andParams:params];
            
        }
    
        
        if ([self.firstButton.titleLabel.text isEqualToString:@"开始处理"]) {
            
            [locService startUserLocationService];
            


        }
    
    
}

- (void)workStart{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
   NSString * methodName = @"FSMWOStart";
   NSDictionary * params = @{@"userId":userId,@"startHandleTime":currentDate,@"woId":self.woId,@"operMBPS":self.currentStep.name,@"taskName":self.currentStep.taskName,@"taskId":self.currentStep.taskId,@"processId":@"0"};
    [self HandleStepWithMethodName:methodName andParams:params];
    
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
            [self requestDatam];
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



- (IBAction)secondClick:(id)sender {
    
    
    stateBackViewController * state = [[stateBackViewController alloc]init];
    
    state.woId = self.woId;
    state.delegate = self;
    [self.navigationController pushViewController:state animated:YES];
    
    
    }

- (IBAction)thirdClick:(id)sender {
    
        FinishCommitViewController * finish = [[FinishCommitViewController alloc]init];
    
        finish.woId = self.woId;
        finish.ruleId = self.ruleId;
        [self.navigationController pushViewController:finish animated:YES];
    
    
}


#pragma mark - get/set
-(PopButtonsView *)popButtonView{
    if (_popButtonView==nil) {
        _popButtonView=[[PopButtonsView alloc]initWithFrame:CGRectMake(0,0, KIphoneWidth, KIphoneHeight )];
    }
    return _popButtonView;
    
}
-(NSMutableArray *)buttonTitleArray{
    if (_buttonTitleArray==nil) {
        _buttonTitleArray=[NSMutableArray arrayWithObjects:@"费用申请",@"添加资源",@"告警查询",
                           @"费用上报",@"维护对象",@"技术手册",
                           @"费用分摊",@"操作项",@"操作规程",
                           @"耗材申请",@"备件申请",@"排障历史", nil];
    }
    return _buttonTitleArray;
    
}


#pragma mark - Gesture

-(void)addGesture{
    
 
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnce)];
    _tap.delegate=self;
    
  
}

-(void)handleTapOnce{
    
    self.popButtonView.backgroundColor=[UIColor colorWithRed:200 green:200 blue:200 alpha:0.8];
    _popButtonView.delegate=self;
    _popButtonView.hidden=NO;
    _popButtonView.buttonTitleArray=self.buttonTitleArray;
    [self.navigationController.view addSubview:_popButtonView];
}

#pragma mark - PopButtonsViewDelegate
-(void)PopButtonsViewTap{
    
}

-(void)PopButtonsViewButtonTouchDown:(UIButton *)button{
    
    if ([button.titleLabel.text isEqualToString:@"技术手册"]) {
        TechnicalManualViewController * vc = [[TechnicalManualViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"操作规程"]) {
        OperatingGuideViewController * vc = [[OperatingGuideViewController alloc]init];
        
        vc.woType = self.model.woType;
        vc.woTypeId = self.model.woTypeId;
        vc.woChildType = self.model.woChildType;
        vc.woChildTypeId = self.model.woChildTypeId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"排障历史"]) {
        HistoryListDetailViewController * vc = [[HistoryListDetailViewController alloc]init];

        vc.maintenanceName = self.model.title;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"操作项"]){
        DetailViewController * detai = [[DetailViewController alloc]init];
        detai.woId = self.woId;
        [self.navigationController pushViewController:detai animated:YES];
        
        
        
    }else if ([button.titleLabel.text isEqualToString:@"备件申请"]){
        
        SparesearchViewController * spare=  [[SparesearchViewController alloc]init];
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        
        //        申请原因 ：获取对工单的内容描述
        //        申请目的地：获取这个工单的维护对象名称
        NSString * woNumber = self.model.woNumber;
        NSString * contentDescribe = self.model.contentDescribe;
        NSString * maintenanceObject = self.model.maintenanceObject;
        
        NSDictionary * dicOrder = @{
                                    @"woNumber":woNumber,
                                    @"woId":_woId,
                                    @"applyReason":contentDescribe,
                                    @"applyDestination":maintenanceObject
                                    };
        [defaulsts setObject:dicOrder forKey:@"dicAssociateOrder"];
        [self.navigationController pushViewController:spare animated:YES];
    
        
    }else if ([button.titleLabel.text isEqualToString:@"耗材申请"]){
        SearchViewController * vc = [[SearchViewController alloc]init];
        vc.handlingDetail = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        //显示可以关联工单用。
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        //[defaulsts setObject:self.orderDetail.baseInfo forKey:@"baseInfo"];
        NSData *tokenObject = [NSKeyedArchiver archivedDataWithRootObject:self.model];
        [defaulsts setObject:tokenObject forKey:@"baseInfo"];
        [defaulsts synchronize];
        
        
    }else if ([button.titleLabel.text isEqualToString:@"告警查询"]){
        AvtiveTableViewController * vc = [[AvtiveTableViewController alloc]init];
        
        vc.maintenanceType_Id   = _model.mObjectTypeId;
        vc.maintenance_Id       = _model.maintenanceObjectId;
        vc.handlingDetail       = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"添加资源"]){

        ResourceAddViewController *vc=[[ResourceAddViewController alloc]init];
        vc.handlingOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];

        
    }else if ([button.titleLabel.text isEqualToString:@"维护对象"]){
        
        NetResourceInfoViewController *vc=[[NetResourceInfoViewController alloc]init];
        vc.handlingOrderDetail=self;
        
        MatainObject *model=[[MatainObject alloc]init];
        model.maintenanceId=_orderDetail.baseInfo.maintenanceObjectId;
        model.maintenanceObjectType=_orderDetail.baseInfo.mObjectTypeId;
        model.maintenanceObjectTitle=_orderDetail.baseInfo.maintenanceObjectCode;
        vc.matainObject=model;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        
    }
    
    
    
    
}





- (IBAction)callClick:(id)sender {
  
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
    
}
@end
