//
//  SpareReturningViewController.m
//  Ericsson
//
//  Created by Min on 16/1/4.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "SpareReturningViewController.h"
#import "ImgLabelHeadView.h"
#import "ThreeLabelView.h"
#import "ThreeLabelOneImgView.h"
#import "ReturningOrderModel.h"
#import "FiveLabelCell.h"
#import "ReturningOrderDetailModel.h"

@interface SpareReturningViewController () <UITableViewDataSource,UITableViewDelegate,ThreeLabelOneImgViewDelegate>



@property (weak, nonatomic) IBOutlet ImgLabelHeadView *headView;
@property (weak, nonatomic) IBOutlet ThreeLabelView *threeLabelView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
/** 存放 所有数据,包含 每个row的数据 */
@property (nonatomic,strong)  NSMutableDictionary *detailDataDictionary;

@property (nonatomic,strong)NSMutableDictionary *showFlagDic;

@property (nonatomic,assign) int currentPage;

@end

@implementation SpareReturningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOthers];
    
    self.currentPage = 1;
    [self loadData];
}


-(void)setOthers{
    self.title = @"待返还申请单列表";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.view.backgroundColor = KBaseGray;
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    self.headView.oneLabel.text=@"列表及明细";
    self.threeLabelView.oneLabel.text=@"申请单编号";
    self.threeLabelView.twoLabel.text=@"所属仓库";
    self.threeLabelView.threeLabel.text=@"申请时间";
}

#pragma mark -request Data
- (void)loadData
{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    NSDictionary *params = @{
                             @"pageIdx":@(1)};
    
    NSString *modelName=@"FSMSparePart";
    NSString *methodName=@"FSMQuerySpareApplyList";
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
    [MBProgressHUD showMessage:@"正在获取待返还备件"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"]  isEqual: @0]) {
            // 字典数组 转换成 模型数组
            NSArray *dataArray = [ReturningOrderModel objectArrayWithKeyValuesArray:dic[@"spareApplyList"]];
            
            if(self.currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
                [self.dataArray addObjectsFromArray:dataArray];
                
                for (int i=0; i<dataArray.count; i++) {
                    [self.showFlagDic setObject:[NSNumber numberWithBool:NO] forKey:@(i)];
                }
            
            [self.tableView reloadData];
            
            if (dataArray == nil || dataArray.count == 0) {
                self.currentPage --;
            }
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.navigationController.view makeToast:@"请求发生错误"];
        
        if (self.currentPage > 1) {
            self.currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
    
}
// 当上面数据请求完成是，for循环中 会把每一个 申请单种的 所有 子数据全部请求一次
- (void)loadDetailData:(NSInteger )row withFlag:(NSNumber*)flag{
    
    ReturningOrderModel *returningOrderModel=_dataArray[row];
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    
    
    NSDictionary *params = @{
                             @"spareApplyId":returningOrderModel.spareApplyId
                             };
    
    NSString *modelName=@"FSMSparePart";
    NSString *methodName=@"FSMQueryMySpareParts";
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"]  isEqual: @0]) {
            // dataArray的数据是 row的数据
            NSMutableArray *dataArray = [ReturningOrderDetailModel objectArrayWithKeyValuesArray:dic[@"sparePartList"]];
            
            if (dataArray.count > 0) {
                [dataArray insertObject:@"" atIndex:0];
                // 把数据加到字典中
                NSString * key = [NSString stringWithFormat:@"%ld",row];
                
                [self.detailDataDictionary setObject:dataArray forKey:key];
                
                [self setupFlag:flag withSection:row];
                
            }
        }
        
        [self.tableView headerEndRefreshing];
    } falure:^(NSError *err) {
        
    }];
    
}


- (void)reloadResources{
    [self loadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return _dataArray.count; // 根据section来判断个数
}

// 判断 第N个section中的,的flag  来确认我们的cell个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if ([[self.showFlagDic objectForKey:@(section)] isEqual:[NSNumber numberWithBool:YES]] && _detailDataDictionary.count > 0) {
        
        NSString * key = [NSString stringWithFormat:@"%ld",section];
        NSArray * array = [_detailDataDictionary objectForKey:key];
        // 返回 第section个中的 row的个数
        return array.count;
    }
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
// section中的view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ReturningOrderModel *model=_dataArray[section];
    
    ThreeLabelOneImgView *view = [ThreeLabelOneImgView threeLabelOneImgView];
    view.delegate = self;
    view.section = section;
    view.oneLabel.text=model.spareApplyId;
    view.twoLabel.text=model.storeRoomName;
    view.threeLabel.text=model.appliedDate;
    
    
    if ([[self.showFlagDic objectForKey:@(section)] isEqual:[NSNumber numberWithBool:YES]]) {
        view.imgView.image = [UIImage imageNamed:@"downpoint"];
    }else
        view.imgView.image = [UIImage imageNamed:@"uppoint"];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString * key = [NSString stringWithFormat:@"%ld",indexPath.section];
    NSMutableArray * array = [_detailDataDictionary objectForKey:key];
    
    FiveLabelCell *cell = [FiveLabelCell cellWithTableView:tableView];
    if (indexPath.row==0) {
        
        cell.oneLabel.text = @"备件名";
        cell.twoLabel.text = @"型号";
        cell.threeLabel.text=@"厂商";
        cell.fourLabel.text=@"待还数";
        cell.fiveLabel.text=@"领取时";
    }
    else {
        
        ReturningOrderDetailModel *model = array[indexPath.row];
        cell.oneLabel.text      = model.sparePartName	;
        cell.twoLabel.text      = model.sparePartType;
        cell.threeLabel.text    = model.factoryName;
        cell.fourLabel.text     = model.applyNumber;
        cell.fiveLabel.text     = model.takingTime;
    }
    return cell;
}





#pragma mark - OrderSectionHeaderViewDelegate

-(void)ThreeLabelOneImgViewClick:(NSInteger)section{
    
    //做收缩切换
    NSNumber *flag = [self.showFlagDic objectForKey:@(section)];
    if ([flag boolValue] == NO) { // 如果flag == NO（收缩） 就打开 且请求
        // 请求数据
        [self loadDetailData:section withFlag:flag];
    }else {
        [self setupFlag:flag withSection:section];
    }
    
    
    
    
    //    if ([flag boolValue]==YES) {
    //        flag = [NSNumber numberWithBool:NO];
    //    }else{
    //        flag = [NSNumber numberWithBool:YES];
    //    }
    //    [self.showFlagDic setObject:flag forKey:@(section)];
    //    NSLog(@"111111111111111");
    //    [self.tableView reloadData];
}
- (void)setupFlag:(NSNumber*)flag withSection:(NSInteger)section
{
    
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
- (NSMutableDictionary *)detailDataDictionary
{
    if (!_detailDataDictionary) {
        _detailDataDictionary = [[NSMutableDictionary alloc]init];
    }
    return _detailDataDictionary;
}
-(NSMutableDictionary *)showFlagDic{
    
    if (_showFlagDic==nil) {
        _showFlagDic=[[NSMutableDictionary alloc]init];
    }
    return _showFlagDic;
    
}
@end
