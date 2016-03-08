//
//  HomeViewController.m
//  Ericsson
//
//  Created by xuming on 15/10/2.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableCell.h"
#import "HomeTable_SectionHeadView.h"
#import "NetResouceViewController.h"
#import "ResourceMaintenanceViewController.h"
#import "InspectionViewController.h"
#import "WarningTableViewController.h"
#import "SparepartsViewController.h"
#import "HomeButton.h"
#import "OrderManagerController.h"
#import "ConsumeViewController.h"
#import "AnnounceViewContrller.h"
#import "HomeTableCellModel.h"
#import "AnnounceViewContrller.h"
#import "HandlingOrderViewController.h"
#import "HandlingOrderDetailController.h"
#import "WorkOrder.h"
#import "UnAcceptedOrderDetailViewController.h"
#import "UnAccpetedOrderViewController.h"
#import "AnnounceDetails.h"
#import "AnnounceContentModel.h"
#import "AllAnnounceViewController.h"
#import "MainViewController.h"
#import "EricssonTabBar.h"

@interface HomeViewController () <HomeTable_SectionHeadViewDelegate,EricssonTabBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *buttonsBackgroundView;

/** 正在处理工单细节 */
@property (nonatomic,strong) NSMutableArray * handlingWorkDetailList;
@property(nonatomic,strong)NSMutableArray *unhandedWorkorderArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeView];
    [self setTableView];

//    [self requestData];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.bounces = NO;
    self.leastNotice = [NSMutableArray array];
    self.unhandleWorkList = [NSMutableArray array];
    self.handlingWork = [NSMutableArray array];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self requestData];
    [self securityLoadData];
}

//判断用户是否有安全响应
-(void)securityLoadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:KSessionId forKey:@"sessionId"];
    
    NSString *sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMBase" methodName:@"FSMGetSecurityInfos" sessonId:KSessionId requestData:params];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"] isEqual:@0]) {
            NSArray *arr = dic[@"securityInfos"];
            
            if (arr.count > 0) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:arr forKey:@"securityInfos"];
                
                //有安全响应消息的时候 改变button的样式
                for (UIButton *btn in self.tabBarController.tabBar.subviews) {
                    Class class = NSClassFromString(@"UIButton");
                    if ([btn isKindOfClass:class]) {
                        btn.selected = YES;
                    }
                }
                
            }
            else{
                for (UIButton *btn in self.tabBarController.tabBar.subviews) {
                    Class class = NSClassFromString(@"UIButton");
                    if ([btn isKindOfClass:class]) {
                        btn.selected = NO;
                    }
                }
            }
        }
        
        
        else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [self.view makeToast:@"请求失败"];
            
        }
        
        
        else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController * rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [self.view makeToast:@"会话超时,请重新登录"];
        }
        
    } falure:^(NSError *response) {
        
    }];
}

-(void)requestData{
   
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
  //  NSString * userId = [defaults objectForKey:@"username"];
    NSString * sessionId = [defaults objectForKey:@"sessionId"];
    
    NSDictionary * params = @{};
    
    NSString * modelName = @"FSMBase";
    NSString * methodName = @"getMainPageInfos";
    NSString * sessonId = sessionId;
    
    NSString * sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    [MBProgressHUD showSuccess:@"正在请求数据"];
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            
            NSArray * dataArray = dic[@"newDaiBanWorks"];
            self.unhandedWorkorderArray=[WorkOrder objectArrayWithKeyValuesArray: dic[@"newDaiBanWorks"]];
            [self.unhandleWorkList removeAllObjects];
            for (NSDictionary * dict in dataArray) {
                
                HomeTableCellModel * model = [[HomeTableCellModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dict];
                
                [self.unhandleWorkList addObject:model];
                
                [_tableView reloadData];
            }
            
            
            
            NSArray * array = dic[@"processingWorks"];
            self.handlingWorkDetailList = [WorkOrder objectArrayWithKeyValuesArray:array];
            [self.handlingWork removeAllObjects];
            for (NSDictionary * dict1 in array) {
                
                HomeTableCellModel * model = [[HomeTableCellModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dict1];
                
                [self.handlingWork addObject:model];
            
                [_tableView reloadData];
            }
            
            NSArray * bArray = dic[@"newNotices"];
            [self.leastNotice removeAllObjects];
            for (NSDictionary * dict2 in bArray) {
    
                HomeTableCellModel * model = [[HomeTableCellModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dict2];
                
                [self.leastNotice addObject:model];
                
                [_tableView reloadData];
                
            }
            
    
          //  NSLog(@"%ld",bArray.count);
            
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"请求数据失败"];
            
        }
        
        
       
        
    } falure:^(NSError *response) {
        
    }];
    
    
}

-(void)makeView{
    UIScrollView  *scrollView;
    float scrollHeight=_buttonsBackgroundView.frame.size.height;
    float buttonWidth=(KIphoneWidth-3)/4;
    float buttonHeight=(scrollHeight-1)/2;
    
    
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KIphoneWidth, scrollHeight)];

    // 是否支持滑动最顶端
    //    scrollView.scrollsToTop = NO;
    scrollView.delegate = self;
    // 设置内容大小
    scrollView.contentSize = CGSizeMake( buttonWidth*5+4,scrollHeight);
    // 是否反弹
    //    scrollView.bounces = NO;
    // 是否分页
    //    scrollView.pagingEnabled = YES;
    // 是否滚动
    //    scrollView.scrollEnabled = NO;
    //    scrollView.showsHorizontalScrollIndicator = NO;
    // 设置indicator风格
    //    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    // 设置内容的边缘和Indicators边缘
    //    scrollView.contentInset = UIEdgeInsetsMake(0, 50, 50, 0);
    //    scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    // 提示用户,Indicators flash
    [scrollView flashScrollIndicators];
    // 是否同时运动,lock
    scrollView.directionalLockEnabled = YES;
    [self.view addSubview:scrollView];
    
    NSMutableDictionary *iconDic=[NSMutableDictionary dictionary];
    [iconDic setObject:@"broadcast.png" forKey:@0];//公告管理
    [iconDic setObject:@"alert.png" forKey:@3];//告警管理
    [iconDic setObject:@"consume.png" forKey:@12];//耗材管理
    [iconDic setObject:@"fee.png" forKey:@14];//费用管理
    [iconDic setObject:@"inspection.png" forKey:@2];//巡检管理
    [iconDic setObject:@"notice.png" forKey:@10];//网络资源
    [iconDic setObject:@"property.png" forKey:@4];//物业管理
    [iconDic setObject:@"spare.png" forKey:@11];//备件管理
    [iconDic setObject:@"work.png" forKey:@1];//工单管理
    [iconDic setObject:@"task.png" forKey:@13];//维护资源
    
    
    
    for (int j=0; j<=1; j++) {
        for (int i=0; i<=4; i++) {
            CGRect rect=CGRectMake(buttonWidth*i+i, buttonHeight*j+j, buttonWidth, buttonHeight);
            HomeButton *button=[[HomeButton alloc]initWithFrame:rect];
            button.tag=j*10+i;
            NSString *imgStr=[iconDic objectForKey:@(button.tag)];

            button.backgroundColor=[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
;
            button.titleLabel.font = [UIFont systemFontOfSize: 13.0];
            [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            button.titleLabel.textAlignment=NSTextAlignmentCenter;
            [button setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
            [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
            
             [self buttonAddTarget:button ];
            [scrollView addSubview:button];
        }
    }
    

    [_buttonsBackgroundView addSubview:scrollView];

}

-(void)buttonAddTarget:(UIButton *)button {
    switch (button.tag) {
        case 0:
        {
            [button setTitle: @"公告管理" forState: UIControlStateNormal];
            [button addTarget:self action:@selector(announce_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        
        case 1:
        {
            [button setTitle: @"工单管理" forState: UIControlStateNormal];

            [button addTarget:self action:@selector(workOrder_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case 2:
        {
            [button setTitle: @"巡检管理" forState: UIControlStateNormal];

            [button addTarget:self action:@selector(routingInspection_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            }
            break;
        case 3:
            {
            [button setTitle: @"告警管理" forState: UIControlStateNormal];

            [button addTarget:self action:@selector(warning_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
                }
            break;
        case 4:
                {
            [button setTitle: @"物业管理" forState: UIControlStateNormal];

//            [button addTarget:self action:@selector(mm) forControlEvents:UIControlEventTouchUpInside];
                    }
            break;
        case 10:
                    {
            [button setTitle: @"网络资源" forState: UIControlStateNormal];

            [button addTarget:self action:@selector(netResource_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
                        }
            break;
        case 11:
                        {
            [button setTitle: @"备件管理" forState: UIControlStateNormal];

            [button addTarget:self action:@selector(sparePartsManagement_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
                            }
            break;
        case 12:
                            {
            [button setTitle: @"耗材管理" forState: UIControlStateNormal];

            [button addTarget:self action:@selector(consume_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
                                }
            break;
        case 13:
                                {
            [button setTitle: @"维护资源" forState: UIControlStateNormal];
            [button addTarget:self action:@selector(resourceMatain_TouchUpInside) forControlEvents:UIControlEventTouchUpInside];
                                    }
            break;
        case 14:
                                    {
                                    
            [button setTitle: @"费用管理" forState: UIControlStateNormal];
//            [button addTarget:self action:@selector(mm) forControlEvents:UIControlEventTouchUpInside];
                                    }
            break;
        default:
            break;
    }

}

-(void)mm{
    AnnounceViewContrller *vc=[[AnnounceViewContrller alloc]init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTableView{
    _tableView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _tableView.dataSource=self;
    _tableView.delegate=self;

}
- (void)announce_TouchUpInside
{
    AnnounceViewContrller * annoucne = [[AnnounceViewContrller alloc]init];
    [self.navigationController pushViewController:annoucne animated:YES];
}
-(void)consume_TouchUpInside{
    ConsumeViewController *vc=[[ConsumeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    

}

- (void)resourceMatain_TouchUpInside {
    ResourceMaintenanceViewController *resource = [[ResourceMaintenanceViewController alloc] init];
    [self.navigationController pushViewController:resource animated:YES];
}

- (IBAction)netResource_TouchUpInside {
    NetResouceViewController *net=[[NetResouceViewController alloc]init];
    net.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:net animated:YES];
}

- (IBAction)routingInspection_TouchUpInside {
    InspectionViewController *inspection = [[InspectionViewController alloc] init];
    [self.navigationController pushViewController:inspection animated:YES];
}

- (IBAction)workOrder_TouchUpInside {
    OrderManagerController *orderManager = [[OrderManagerController alloc] init];
    [self.navigationController pushViewController:orderManager animated:YES];
}

- (IBAction)sparePartsManagement_TouchUpInside {
    SparepartsViewController *spareparts = [[SparepartsViewController alloc] init];
    [self.navigationController pushViewController:spareparts animated:YES];
}

- (IBAction)warning_TouchUpInside {
    WarningTableViewController *warning = [[WarningTableViewController alloc] init];
    [self.navigationController pushViewController:warning animated:YES];
}



#pragma mark - TableView DATA & DELE
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    HomeTable_SectionHeadView *sectionView=(HomeTable_SectionHeadView *)[[[NSBundle mainBundle]loadNibNamed:@"HomeTable_SectionHeadView" owner:nil options:nil]lastObject];
    sectionView.delegate = self;
    sectionView.moreInfoBtn.tag = section;
    
    if (section==0) {
        sectionView.label.text=@"最新公告";
    }
    else if (section==1) {
        sectionView.label.text=@"待办工单";
    }
    else if (section==2) {
        sectionView.label.text=@"正在处理工单";
    }
    
    return sectionView;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if(section == 0){
        
        return self.leastNotice.count;
  
    }else if (section == 1){
        
        return self.unhandleWorkList.count;
        
    }else{
        
        
        return self.handlingWork.count;
    }
}

-(HomeTableCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *ID=@"HomeTableCell";
    HomeTableCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=(HomeTableCell *)[[[NSBundle mainBundle]loadNibNamed:@"HomeTableCell" owner:nil options:nil]lastObject];
        
        if(indexPath.section == 0){
            if (self.leastNotice.count != 0) {
                HomeTableCellModel * model = self.leastNotice[indexPath.row];
                
                [cell loadDataFromModel:model];
            }else{
                [_tableView reloadData];
            }
            
            
        }else if (indexPath.section == 1){
            
            HomeTableCellModel * model = self.unhandleWorkList[indexPath.row];
            
            [cell loadDataFromModel:model];
            
        }else if (indexPath.section == 2){
            
            HomeTableCellModel * model = self.handlingWork[indexPath.row];
            
            [cell loadDataFromModel:model];
            
            
        }
        
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {

        HomeTableCellModel * model = self.leastNotice[indexPath.row];
        
        AnnounceDetails * vc = [[AnnounceDetails alloc]init];
        vc.annoucneId = model.id;
        
        [self.navigationController pushViewController:vc animated:YES];
     
    }
    else if (indexPath.section == 1) {
        
    UnAcceptedOrderDetailViewController *vc = [[UnAcceptedOrderDetailViewController alloc] initWithNibName:@"UnAcceptedOrderDetailViewController" bundle:nil];
        vc.unAcceptedOrder=_unhandedWorkorderArray[indexPath.row];
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (indexPath.section == 2) {
        
        HandlingOrderDetailController * handing = [[HandlingOrderDetailController alloc]init];
        WorkOrder * model = self.handlingWorkDetailList[indexPath.row];
        handing.woId = model.woId;
        handing.workOrder = model;
        [self.navigationController pushViewController:handing animated:YES];
        
    }
}

#pragma mark - HomeTable_SectionHeadViewDelegate
- (void)didSelectMoreInfoBtn:(UIButton *)sender
{
    if (sender.tag == 0) { // 跳转到最新公告
        AllAnnounceViewController * vc = [[AllAnnounceViewController alloc]init];
        vc.navTitle = @"未阅读公告";
        vc.annoucneType = 2;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (sender.tag == 1) { // 跳转到代办工单
        UnAccpetedOrderViewController *unAccepted = [[UnAccpetedOrderViewController alloc] initWithNibName:@"UnAccpetedOrderViewController" bundle:nil];
        [self.navigationController pushViewController:unAccepted animated:YES];
    
    }else { // 跳转到正在处理工单
        HandlingOrderViewController * vc = [[HandlingOrderViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(NSMutableArray *)unhandedWorkorderArray{
    if (_unhandedWorkorderArray==nil) {
        _unhandedWorkorderArray=[[NSMutableArray alloc]init];
    }
    return _unhandedWorkorderArray;

}

@end
