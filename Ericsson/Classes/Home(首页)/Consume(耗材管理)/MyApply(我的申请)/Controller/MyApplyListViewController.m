//
//  MyApplyListViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/19.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "MyApplyListViewController.h"
#import "ImgLabelHeadView.h"
#import "ThreeLabelView.h"
#import "ThreeLabelOneImgView.h"
#import "ApplyConsume.h"
#import "FourLabelCell.h"
#import "HandledOrderDetailController.h"
#import "HandlingOrderDetailController.h"

@interface MyApplyListViewController ()<ThreeLabelOneImgViewDelegate>
{

    int dataArrayIndex;//数组列表的序列号
}
@property (weak, nonatomic) IBOutlet ImgLabelHeadView *headView;
@property (weak, nonatomic) IBOutlet ThreeLabelView *threeLabelView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableDictionary *showFlagDic;

@end

@implementation MyApplyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setOthers];
    
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    [self loadData];
}

-(void)setOthers{
    self.title = @"我的申请单";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(loadNewResources)];

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.headView.oneLabel.text=@"列表及明细";
    self.threeLabelView.oneLabel.text=@"申请单编号";
    self.threeLabelView.twoLabel.text=@"申请单状态";
    self.threeLabelView.threeLabel.text=@"申请时间";
    
    dataArrayIndex=0;
    
    
    
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    
    [[self navigationItem] setLeftBarButtonItem:leftItem];
    
}





-(void)back{

    //如果是从工单页面跳转过来，跳回时，显示工单的跳转的按钮view
    NSArray * navVCsArray=self.navigationController.viewControllers;
    for (long i=navVCsArray.count-1; i>0; i--) {
        UIViewController *vc=navVCsArray[i];
        if ( [vc isMemberOfClass:[HandlingOrderDetailController class]])
        {
            ((HandlingOrderDetailController *)vc).popButtonView.hidden=NO;
            break;
        }
        else if ( [vc isMemberOfClass:[HandledOrderDetailController class]])
        {
            ((HandledOrderDetailController *)vc).popButtonView.hidden=NO;
            break;
        }

        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark -request Data
- (void)loadData
{
    //请求数据示例
    
    NSDictionary *params = @{
                             @"pageIdx":@(currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMConsumable" methodName:@"FSMMyConsumApplyOrders" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            NSArray *dataArray = [ApplyConsume objectArrayWithKeyValuesArray:dic[@"orderLists"]];
            
            if (currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:dataArray];
            
            [self.tableView reloadData];
            

            
       
        
            if (dataArray == nil || dataArray.count == 0) {
                currentPage --;
            }
            
            //如果有数据，那么去加载明细数据
            if (self.dataArray.count>0) {
                [self loadDetailData:_dataArray];

            }
            
            


        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            [self.view makeToast:KHudResponse1];
            
        }
        else if ([dic[@"retCode"] isEqual:@(-2)]){
            [self.view makeToast:KHudResponse2];
            
        }
     
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];

        [self.view makeToast:KHudErrorMessage];

        if (currentPage > 1) {
            currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
    
}

- (void)loadDetailData:(NSMutableArray * )dataArray{
    
    if (dataArrayIndex==0) {
        [MBProgressHUD showMessage:@"正在请求明细数据"];
    }

    
    //开始遍历数组的每一个数据。
    ApplyConsume *applyConsume=_dataArray[dataArrayIndex];
    
    
    //请求数据
    NSDictionary *params = @{
                             @"consumableApplyId":applyConsume.consumableApplyId
                             };
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMConsumable" methodName:@"FSMApplyOrderList" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *dataArray = [ApplyConsume objectArrayWithKeyValuesArray:dic[@"consumableList"]];
            if (dataArray.count>0) {

            
                ApplyConsume *applyConsumeDetail=(ApplyConsume *)dataArray[0];
                ApplyConsume *applyConsume=(ApplyConsume *)self.dataArray[dataArrayIndex];
                applyConsume.model=applyConsumeDetail.model;
                applyConsume.factoryName=applyConsumeDetail.factoryName;
                applyConsume.depotName=applyConsumeDetail.depotName;
                applyConsume.consumableName=applyConsumeDetail.consumableName;
            }
        }
        
        
        //如果请求到最后一个数据，结束
        if (dataArrayIndex==self.dataArray.count-1) {
            [MBProgressHUD hideHUD];
            
            //刷新下表
            [_tableView reloadData];
        }
        else{
            //接着请求下一个数据
            dataArrayIndex++;
            [self loadDetailData:_dataArray];
        }


    } falure:^(NSError *err) {
        
        //如果请求到最后一个数据，结束
        if (dataArrayIndex==self.dataArray.count-1) {
            [MBProgressHUD hideHUD];
            
            //刷新下表
            [_tableView reloadData];
        }
        else{
            //接着请求下一个数据
            dataArrayIndex++;
            [self loadDetailData:_dataArray];
        }

        
    }];
    
}




- (void)reloadResources{
    currentPage=1;
    [self loadData];
}

- (void)loadNewResources{
    currentPage++;
    [self loadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([[self.showFlagDic objectForKey:@(section)] isEqual:[NSNumber numberWithBool:YES]]) {
        return 2;
    }
    else
        return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ApplyConsume *model=_dataArray[section];
    
    ThreeLabelOneImgView *view = [ThreeLabelOneImgView threeLabelOneImgView];
    view.delegate = self;
    view.section = section;
    view.oneLabel.text=model.consumableApplyId;
    view.twoLabel.text=model.status;
    view.threeLabel.text=model.applyDate;
    



    if ([[self.showFlagDic objectForKey:@(section)] isEqual:[NSNumber numberWithBool:YES]]) {
        view.imgView.image = [UIImage imageNamed:@"downpoint"];
    }else
        view.imgView.image = [UIImage imageNamed:@"uppoint"];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyConsume *model = self.dataArray[indexPath.section];
    
    FourLabelCell *cell = [FourLabelCell cellWithTableView:tableView];
    if (indexPath.row==0) {
        
        cell.oneLabel.text = @"名称";
        cell.twoLabel.text = @"型号";
        cell.threeLabel.text=@"厂商";
        cell.fourLabel.text=@"仓库名";
    }
    else {
        cell.oneLabel.text = model.consumableName;
        cell.twoLabel.text = model.model;
        cell.threeLabel.text=model.factoryName;
        cell.fourLabel.text=model.depotName;
        
    }
    return cell;
}





#pragma mark - OrderSectionHeaderViewDelegate

-(void)ThreeLabelOneImgViewClick:(NSInteger)section{
    //做收缩切换
    NSNumber *flag = [self.showFlagDic objectForKey:@(section)];
    if ([flag boolValue]==YES) {
        flag = [NSNumber numberWithBool:NO];
    }else{
        flag = [NSNumber numberWithBool:YES];
    }
    
    [self.showFlagDic setObject:flag forKey:@(section)];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -get/set
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableDictionary *)showFlagDic{
    
    if (_showFlagDic==nil) {
        _showFlagDic=[[NSMutableDictionary alloc]init];
    }
    return _showFlagDic;

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
