//
//  HandledOrderDetailController.m
//  Ericsson
//F
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HandledOrderDetailController.h"
#import "HeaderView.h"
#import "OrderSectionHeaderView.h"
#import "OrderInfoCell.h"
#import "OrderHandleTypeView.h"
#import "OilMachineInfoCell.h"
#import "WorkOrderDetail.h"
#import "WorkOrder.h"
#import "WorkOrderResource.h"
#import "OrderResourceViewCell.h"
#import "FeedBackInfoCell.h"
#import "ProcessResult.h"
#import "ProcessResultFrame.h"
#import "ProcessResultViewCell.h"
#import "WorkOrderBaseInfoFrame.h"
#import "MaintanceObjInfoView.h"
#import "SearchViewController.h"//耗材查询
#import "SparesearchViewController.h"//备件查询
#import "ResourceAddViewController.h"//添加资源
#import "AvtiveTableViewController.h" // 告警查询
#import "TechnicalManualViewController.h" // 技术手册
#import "OperatingGuideViewController.h" // 操作规程
#import "HistoryListDetailViewController.h" // 排障历史
#import "NetResourceInfoViewController.h"//维护对象
#import "DetailViewController.h"//巡检详情


@interface HandledOrderDetailController ()<UITableViewDataSource,UITableViewDelegate,OrderSectionHeaderViewDelegate,FeedBackInfoCellDelegate,UIGestureRecognizerDelegate, PopButtonsViewDelegate>

@property (nonatomic,strong)OrderHandleTypeView *handleView;
@property (nonatomic,strong)WorkOrderDetail *orderDetail;

@property (nonatomic,strong)NSMutableDictionary *showFlag;
@property (nonatomic,strong)NSMutableArray *buttonTitleArray ;
//详情弹出框
@property (nonatomic,strong)FDAlertView *detailalert;


@end

@implementation HandledOrderDetailController

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
    // Do any additional setup after loading the view from its nib.
    self.title = @"已处理工单";
    
    // Do any additional setup after loading the view from its nib.
    self.headerView.imageView.image = [UIImage imageNamed:[self iconNameWithResourceType:self.workOrder.type]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //添加工单操作视图
    self.handleView = [[OrderHandleTypeView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.handleView.hidden = YES;
    [self.navigationController.view addSubview:self.handleView];
    
    //添加弹出界面的手势
    [self addGesture];
}

#pragma mark - Gesture

-(void)addGesture{
    UITapGestureRecognizer* recognizer2;
    recognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeaderView)];
    recognizer2.delegate=self;
    [self.headerView addGestureRecognizer:recognizer2];
    

}

-(void)tapHeaderView{
    //    self.alert.contentView = self.businessOwnerView;
    //    self.alert.contentView.hidden=NO;
    //    [self.alert show];
    [self LoadMaintenanceObjectInfo];
    
}

-(void)tapCell{
    
    self.popButtonView.backgroundColor=[UIColor colorWithRed:200 green:200 blue:200 alpha:0.8];
    _popButtonView.delegate=self;
    _popButtonView.hidden=NO;
    _popButtonView.buttonTitleArray=self.buttonTitleArray;
    [self.navigationController.view addSubview:_popButtonView];
}


#pragma mark -展示业主信息
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


#pragma mark -PopButtonsViewDelegate

-(void)PopButtonsViewTap{
    
    
}

//点击弹出界面上的一个按钮
-(void)PopButtonsViewButtonTouchDown:(UIButton *)button{
    
    if ([button.titleLabel.text isEqualToString:@"耗材申请"]) {
        SearchViewController *vc=[[SearchViewController alloc]init];
        vc.handledOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];
        
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        [defaulsts setObject:_woId forKey:@"woId"];
    }
    else if ([button.titleLabel.text isEqualToString:@"备件申请"]) {
        SparesearchViewController *vc=[[SparesearchViewController alloc]init];
        
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        
        //        申请原因 ：获取对工单的内容描述
        //        申请目的地：获取这个工单的维护对象名称
        NSDictionary * dicOrder = @{
                                    @"name":_workOrder.name,
                                    @"woId":_workOrder.woId
                                    };
        [defaulsts setObject:dicOrder forKey:@"dicAssociateOrder"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"告警查询"]) {
        AvtiveTableViewController * vc = [[AvtiveTableViewController alloc]init];
        vc.maintenanceType_Id   = self.orderDetail.baseInfo.mObjectTypeId;
        vc.maintenance_Id           = self.orderDetail.baseInfo.maintenanceObjectId;
        vc.handledOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"技术手册"]) {
        TechnicalManualViewController * vc = [[TechnicalManualViewController alloc]init];
        vc.handledOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"操作规程"]) {
        OperatingGuideViewController * vc = [[OperatingGuideViewController alloc]init];
        
        vc.woType           = self.orderDetail.baseInfo.woType;
        vc.woTypeId         = self.orderDetail.baseInfo.woType;
        vc.woChildType      = self.orderDetail.baseInfo.woChildType;
        vc.woChildTypeId    = self.orderDetail.baseInfo.woChildTypeId;
        vc.handledOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"排障历史"]) {
        HistoryListDetailViewController * vc = [[HistoryListDetailViewController alloc]init];
        NSString * station = self.workOrder.title;
        NSRange range = [station rangeOfString:@"_"];
        NSString * name = [station substringToIndex:range.location];
        vc.maintenanceName = name;
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([button.titleLabel.text isEqualToString:@"添加资源"]) {
        ResourceAddViewController *vc=[[ResourceAddViewController alloc]init];
        vc.handledOrderDetail=self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    else if ([button.titleLabel.text isEqualToString:@"操作项"]) {
        DetailViewController *vc=[[DetailViewController alloc]init];
        vc.handledOrderDetail=self;
        vc.woId=_woId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([button.titleLabel.text isEqualToString:@"维护对象"]) {
        NetResourceInfoViewController *vc=[[NetResourceInfoViewController alloc]init];
        vc.handledOrderDetail=self;
        
        MatainObject *model=[[MatainObject alloc]init];
        model.maintenanceId=_orderDetail.baseInfo.maintenanceObjectId;
        model.maintenanceObjectType=_orderDetail.baseInfo.mObjectTypeId;
        model.maintenanceObjectTitle=_orderDetail.baseInfo.maintenanceObjectCode;
        vc.matainObject=model;
        
        [self.navigationController pushViewController:vc animated:YES];
    }

    
    
    
    
}


#pragma mark - view

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadWorkOrderInfo];
}

- (NSString *)iconNameWithResourceType:(NSString *)type{
    if ([type containsString:@"发电"]) {
        return @"wo_elect";
    }else if ([type containsString:@"故障"]){
        return @"wo_tr";
    }else
        return @"wo_with";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadWorkOrderInfo{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{@"userId":userId,@"woId":self.woId,@"isGetFinishDetail":@(self.isGetFinishDetail)};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMGetAcceptWODetail";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在获取已处理工单详情"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            self.orderDetail = [WorkOrderDetail objectWithKeyValues:dic];
            self.headerView.title.text = self.orderDetail.baseInfo.title;


            [self.tableView reloadData];

        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.navigationController.view makeToast:@"请求失败"];
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.navigationController.view makeToast:@"会话超时，请重新登录"];
        }
    } falure:^(NSError *err) {
//        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.workOrder.type isEqualToString:@"发电"]) {
        return 5;
    }else
        return 4;
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
        }else if (section == 4){
            return 1;
        }
    }else{
        if (section == 0) {
            return 1;
        }else if (section == 1){
            return self.orderDetail.resourceList.count;
        }else if (section == 2){
            return 1;
        }else if (section == 3){
            return 1;
        }
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    OrderSectionHeaderView *sectionHeaderView = [OrderSectionHeaderView orderSectionHeaderView];
    sectionHeaderView.delegate = self;
    sectionHeaderView.section = section;
    
    if ([self.workOrder.type isEqualToString:@"发电"]) {
        if (section == 0) {
            sectionHeaderView.title.text = @"工单信息";
        }else if (section == 1){
            sectionHeaderView.title.text = @"维护资源";
        }else if (section == 2){
            sectionHeaderView.title.text = @"油机信息";
        }else if (section == 3){
            sectionHeaderView.title.text = @"阶段反馈";
        }else if (section == 4){
            sectionHeaderView.title.text = @"处理结束";
        }
    }else{
        if (section == 0) {
            sectionHeaderView.title.text = @"工单信息";
        }else if (section == 1){
            sectionHeaderView.title.text = @"维护资源";
        }else if (section == 2){
            sectionHeaderView.title.text = @"阶段反馈";
        }else if (section == 3){
            sectionHeaderView.title.text = @"处理结束";
        }
    }
    
    if ([[self.showFlag objectForKey:[NSString stringWithFormat:@"%ld",section]] isEqual:@0]) {
        sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"downpoint"];
    }else
        sectionHeaderView.tailIcon.image = [UIImage imageNamed:@"uppoint"];
    return sectionHeaderView;
}


-(void)cellAddGesture:(UITableViewCell *) cell{
    UITapGestureRecognizer* recognizer;
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCell)];
    recognizer.delegate=self;
    [cell addGestureRecognizer:recognizer];
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
        }else if (indexPath.section == 4){
            ProcessResultViewCell *cell = [ProcessResultViewCell cellWithTableView:tableView];
            ProcessResultFrame *processResultFrame = [[ProcessResultFrame alloc] init];
            processResultFrame.processResult = self.orderDetail.processResult;
            cell.processResultFrame = processResultFrame;
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
        }else if (indexPath.section == 3){
            ProcessResultViewCell *cell = [ProcessResultViewCell cellWithTableView:tableView];
            ProcessResultFrame *processResultFrame = [[ProcessResultFrame alloc] init];
            processResultFrame.processResult = self.orderDetail.processResult;
            cell.processResultFrame = processResultFrame;
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
        }else if (indexPath.section == 4){
            ProcessResultFrame *processResultFrame = [[ProcessResultFrame alloc] init];
            processResultFrame.processResult = self.orderDetail.processResult;
            return processResultFrame.cellHeight;
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
        }else if (indexPath.section == 3){
            ProcessResultFrame *processResultFrame = [[ProcessResultFrame alloc] init];
            processResultFrame.processResult = self.orderDetail.processResult;
            return processResultFrame.cellHeight;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

#pragma mark - OrderSectionHeaderViewDelegate

-(void)OrderSectionHeaderViewClick:(NSInteger)section{
    //做收缩切换
    NSLog(@"点击了第%ld个section",section);
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

#pragma mark -get/set

-(FDAlertView *)detailalert{
    
    if (_detailalert==nil) {
        _detailalert=[[FDAlertView alloc]init];
    }
    return _detailalert;
}

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


@end
