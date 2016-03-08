//
//  completeDetailViewController.m
//  Ericsson
//
//  Created by Slark on 16/1/18.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "completeDetailViewController.h"
#import "HeaderView.h"
#import "HandingDeatilModel.h"
#import "handDetailTableViewCell.h"
#import "WorkOrderBaseInfo.h"

#import "SearchViewController.h"//耗材查询
#import "SparesearchViewController.h"//备件查询
#import "ResourceAddViewController.h"//添加资源
#import "AvtiveTableViewController.h" // 告警查询
#import "TechnicalManualViewController.h" // 技术手册
#import "OperatingGuideViewController.h" // 操作规程
#import "HistoryListDetailViewController.h" // 排障历史
#import "DetailViewController.h" //操作项
#import "MatainObject.h"
#import "ResourceAddViewController.h"//添加资源
#import "NetResourceInfoViewController.h"//维护对象
#import "WorkOrderDetail.h"
@interface completeDetailViewController ()<UITableViewDataSource,UITableViewDelegate,PopButtonsViewDelegate,UIGestureRecognizerDelegate>{
    
    UIButton * firstButton;
    UIButton * secondButton;
    UIButton * thirdButton;
    UIButton * fouthButton;
    BOOL isSelected;
    BOOL close;
    BOOL isClick;
    BOOL isOpen;
    HandingDeatilModel * model;
}
@property (nonatomic,strong)NSMutableArray * dataArr;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)WorkOrderDetail *orderDetail;
@property (nonatomic,strong)UITapGestureRecognizer * tap;
@property (nonatomic, strong) NSMutableArray *buttonTitleArray;

@end

@implementation completeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.title = @"已处理巡检工单详情";
    self.headerView.title.text = self.sss;
    self.headerView.imageView.image = [UIImage imageNamed:@"wo_with"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"handDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"SOGA"];
    self.tableView.autoresizesSubviews = NO;
    //添加标题手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
   
    [self.headerView addGestureRecognizer:tap];
    _RView.hidden = YES;
   
    firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fouthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self requestData];
    
    // Do any additional setup after loading the view from its nib.
}


- (NSMutableArray *)feedBackArr{
    
    if(_feedBackArr == nil){
        
        self.feedBackArr = [[NSMutableArray alloc]init];
        
    }
    
    return _feedBackArr;
}


- (NSMutableArray *)dealFinish{
    
    if (_dealFinish == nil) {
        
        self.dealFinish = [[NSMutableArray alloc]init];
        
    }
    return _dealFinish;
    
}



- (void)tapClick{
    
    if (close) {
        _RView.hidden = NO;
        
        self.tableView.alpha = 0.3;
    }else{
        
        self.tableView.alpha = 1;
        _RView.hidden = YES;
    }
    
    
    close = !close;
    
    
}


- (void)requestData{
    
    NSString * modelName = @"FSMworkOrder";
    NSString * methodName = @"FSMGetAcceptWODetail";
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    NSString * userId = [defaults objectForKey:@"username"];
    NSDictionary * params =@{@"userId":userId,@"woId":self.woId,@"isGetFinishDetail":@"true"};
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD showMessage:@"正在请求数据"];
        if([dic[@"retCode"] isEqual:@0]){
            [MBProgressHUD hideHUD];
            [MBProgressHUD showSuccess:@"请求成功"];
            self.orderDetail = [WorkOrderDetail objectWithKeyValues:dic];
            NSArray * ar = dic[@"phaseFeedBack"];
            
            NSDictionary * dict = dic[@"baseInfo"];
            NSDictionary * dd = dic[@"processResult"];            
            model = [[HandingDeatilModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            [model setValuesForKeysWithDictionary:dd];
            self.dataArr = [NSMutableArray arrayWithObjects:model.maintenanceObjectType,model.maintenanceObjectLevel,model.priority,model.woType,@"",model.woNumber,@"",@"",@"",@"",model.state,nil];
            self.dealFinish = [NSMutableArray arrayWithObjects:model.finishType,model.handleSummary,model.legacyProblemDesc,model.remark, nil];
            
            
            self.firstLabel.text = model.maintenanceObjectCode;
            self.secondLabel.text = model.title;
            self.thirdLabel.text = model.maintenanceObjectLevel;
            self.fouthLabel.text = @"";
            self.fivethLabel.text = @"";
            self.sixthLabel.text = model.mObjectLon;
            self.seventhLabel.text = model.mObjectLan;
            self.eighthLabel.text = model.address;
            
            
                      [self.tableView reloadData];

            
        }
        
        
    } falure:^(NSError *response) {
        
        
        
    }];
    
    
    
}



- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 40)];
    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
        label.text = @"工单信息";
      
        firstButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 30, 30);
        [firstButton setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
        [firstButton setImage:[UIImage imageNamed:@"uppoint.png"] forState:UIControlStateSelected];
        [firstButton addTarget:self action:@selector(firstClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 40);
        [button addTarget:self action:@selector(firstClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view addSubview:button];
        
        
        [view addSubview:label];
        [view addSubview:firstButton];
        return view;
    }
    if (section == 1) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
        label.text = @"维护资源";
        
        secondButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 30, 30);
        [secondButton setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
        [secondButton setImage:[UIImage imageNamed:@"uppoint.png"] forState:UIControlStateSelected];
        [secondButton addTarget:self action:@selector(secondClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 40);
        [button addTarget:self action:@selector(secondClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view addSubview:button];
        
        [view addSubview:label];
        [view addSubview:secondButton];
        return view;

    }
    if (section == 2) {
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
        label.text = @"阶段反馈";
        
        thirdButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 30, 30);
        [thirdButton setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
        [thirdButton setImage:[UIImage imageNamed:@"uppoint.png"] forState:UIControlStateSelected];
        [thirdButton addTarget:self action:@selector(thirdClick:) forControlEvents:UIControlEventTouchUpInside];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 40);
        [button addTarget:self action:@selector(thirdClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view addSubview:button];
        
        [view addSubview:label];
        [view addSubview:thirdButton];
        return view;

        
        
        
        
    }
    if (section == 3) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
        label.text = @"处理结束";
        
        fouthButton.frame = CGRectMake(self.view.bounds.size.width - 40, 0, 30, 30);
        [fouthButton setImage:[UIImage imageNamed:@"downpoint"] forState:UIControlStateNormal];
        [fouthButton setImage:[UIImage imageNamed:@"uppoint.png"] forState:UIControlStateSelected];
        [fouthButton addTarget:self action:@selector(fouthClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 40);
        [button addTarget:self action:@selector(fouthClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [view addSubview:button];
        
        [view addSubview:label];
        [view addSubview:fouthButton];
        return view;

        
        
    }
    
    
    
    return view;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //工单信息
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
    
    //阶段反馈
    if (section == 2) {
        if (isOpen) {
            return 0;
        }else{
        
        return 0;
            
            
        }
    }

    
    //处理结束
    if (section == 3) {
        
        if (isClick) {
            return 0;
            
        }else{
            
            return _dealFinish.count;
        }
    }else{
        
        
        return 0;
    }
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 4;
}







- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSArray * array = [NSArray arrayWithObjects:@"维护对象类型",@"维护对象等级",@"优先级",@"工单类型",@"告警级别",@"工单编号",@"要求到达时间:",@"要求完成时间",@"内容描述",@"工单影响范围:",@"工单状态", nil];
        handDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SOGA" forIndexPath:indexPath];
        
        
        NSString * str = self.dataArr[indexPath.row];
        
        cell.TextLabel.text  = str;
        cell.TopLabel.text = array[indexPath.row];
        
        [self addGesture];
        [cell addGestureRecognizer:_tap];
        
        
        
        return cell;

    }
    
    if (indexPath.section == 3) {
        NSArray * array= [NSArray arrayWithObjects:@"完成类型",@"遗留问题描述",@"处理总结",@"备注", nil];
        NSString * sss = self.dealFinish[indexPath.row];
        
        handDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SOGA" forIndexPath:indexPath];
        NSString * str = array[indexPath.row];
        
        cell.TextLabel.text =sss;
         cell.TopLabel.text  = str;
        return cell;
        
    }else{
        
        
        return nil;
    }
    
   }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}


- (void)firstClick:(UIButton*)button{
    
    if (isSelected) {
        button.selected =YES;
    }else{
        
        button.selected = NO;
    }
    isSelected = !isSelected;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
- (void)secondClick:(UIButton*)button{
    
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)thirdClick:(UIButton*)button{
    
    if (isOpen) {
        
        button.selected = YES;
    }else{
        button.selected = NO;
    }
    isOpen = !isOpen;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)fouthClick:(UIButton*)button{
    
    if (isClick) {
        button.selected =YES;
    }else{
        
        button.selected = NO;
    }
    isClick = !isClick;
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    
}


#pragma mark - PopButtonsView buttonTitleArray 懒加载
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
        
        vc.woType       = model.woType;
        vc.woTypeId     = model.woTypeId;
        vc.woChildType  = model.woChildType;
        vc.woChildTypeId = model.woChildTypeId;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if ([button.titleLabel.text isEqualToString:@"排障历史"]) {
        HistoryListDetailViewController * vc = [[HistoryListDetailViewController alloc]init];
        
        vc.maintenanceName = model.title;
        
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([button.titleLabel.text isEqualToString:@"操作项"]){
        DetailViewController * detai = [[DetailViewController alloc]init];
        detai.woId = self.woId;
        [self.navigationController pushViewController:detai animated:YES];
        
        
    }else if ([button.titleLabel.text isEqualToString:@"备件申请"]){
        
        SparesearchViewController * spare =  [[SparesearchViewController alloc]init];
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        
        //        申请原因 ：获取对工单的内容描述
        //        申请目的地：获取这个工单的维护对象名称
        NSString * woNumber = model.woNumber;
        NSString * contentDescribe = model.contentDescribe;
        NSString * maintenanceObjectCode = model.maintenanceObjectCode;
        
        NSDictionary * dicOrder = @{
                                    @"woNumber":woNumber,
                                    @"woId":_woId,
                                    @"applyReason":contentDescribe,
                                    @"applyDestination":maintenanceObjectCode
                                    };
        [defaulsts setObject:dicOrder forKey:@"dicAssociateOrder"];
        [self.navigationController pushViewController:spare animated:YES];
        
        
    }else if ([button.titleLabel.text isEqualToString:@"耗材申请"]){
        SearchViewController * vc = [[SearchViewController alloc]init];
        vc.completeDetail = self;
        [self.navigationController pushViewController:vc animated:YES];
        
        //显示可以关联工单用。
        NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
        //[defaulsts setObject:self.orderDetail.baseInfo forKey:@"baseInfo"];
        NSData *tokenObject = [NSKeyedArchiver archivedDataWithRootObject:model];
        [defaulsts setObject:tokenObject forKey:@"baseInfo"];
        [defaulsts synchronize];
        
    }else if ([button.titleLabel.text isEqualToString:@"告警查询"]){
        AvtiveTableViewController * vc = [[AvtiveTableViewController alloc]init];
        
        vc.maintenanceType_Id   = model.mObjectTypeId;
        vc.maintenance_Id       = model.maintenanceObjectId;
        vc.completeDetail       = self;
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

@end
