//
//  NetResourceListViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/3.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "NetResourceListViewController.h"
#import "MatainObjectCell.h"
#import "NetResourceInfoViewController.h"
#import "RejectReason.h"
#import "MatainObject.h"
#import "MBProgressHUD+MJ.h"

@interface NetResourceListViewController ()<UITableViewDataSource, UITableViewDelegate>
{

    //维护对象id
    NSString *maintenanceId;

}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)NSMutableArray *    dataArray;


@end

@implementation NetResourceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"网络资源查询与变更";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    [self setOthers];
}

-(void)setOthers{
    self.title=@"网络资源查询与变更";
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self loadData];

}
- (void)reloadResources{
    currentPage = 1;
    [self loadData];
}

#pragma mark -request data
- (void) loadData
{
    //请求数据示例
    
    NSDictionary *params = @{@"userId":userId,
                             @"maintenanceObjectType":_matainObject.maintenanceObjectType,
                             @"maintenanceObjectName":_matainObject.maintenanceObjectName,
                             @"orgId":self.matainObject.orgId,
                             @"pageIdx":@(currentPage)};
    
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMQueryMObject" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [self.tableView headerEndRefreshing];
        [MBProgressHUD hideHUD];

        if ([dic[@"retCode"]  isEqual: @0]) {
            NSMutableArray *dataArray = [MatainObject objectArrayWithKeyValuesArray:dic[@"mainatenanceList"]];
            
            for (MatainObject *model in  dataArray) {
                //维护对象名称和维护对象标题，是一样的。
                model.maintenanceObjectName=model.maintenanceObjectTitle;
            }
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:dataArray];
            [_tableView reloadData];
            
        }
        else if ([dic[@"retCode"]  isEqual: @(-1)]) {
            [self.view makeToast:KHudResponse1];
        }
        else if ([dic[@"retCode"]  isEqual: @(-2)]) {
            [self.view makeToast:KHudResponse2];
        }


    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.tableView headerEndRefreshing];
        
        [self.view makeToast:KHudErrorMessage];

        
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_dataArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    // Configure the cell...
    MatainObjectCell *cell=[MatainObjectCell cellWithTableView:tableView];
    MatainObject *model=_dataArray[indexPath.row];
    NSString * itemText = model.maintenanceObjectTitle;
    itemText = [itemText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; //去除首尾的空白字符串和换行字符
    cell.item.text=itemText;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MatainObject *model=_dataArray[indexPath.row];
    NSRange range=[model.maintenanceObjectId rangeOfString:@","];
    maintenanceId=[model.maintenanceObjectId substringToIndex:range.location];
    

    
    /*从上页，传来的数据*/
    
    //维护对象类型id
    model.maintenanceObjectType=_matainObject.maintenanceObjectType;
    ///维护对象类型名称
    model.maintenanceTypeName=_matainObject.maintenanceTypeName;
    //组织机构id
    model.orgId=_matainObject.orgId;
    
    
    
    
    /*从本页面，请求到的数据，取值。*/
    
    //维护对象名称
    //有的维护对象名称里面带换行符，要把换行符替换掉。
    model.maintenanceObjectName=[model.maintenanceObjectTitle   stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    model.maintenanceObjectTitle=model.maintenanceObjectName;
    //维护对象id
    model.maintenanceId=maintenanceId;


    NetResourceInfoViewController *vc=[[NetResourceInfoViewController alloc]init];
    vc.matainObject=model;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark- get/set
-(UITableView *)tableView{
    
    if (_tableView==nil) {
        _tableView=[[UITableView alloc]init];
        _tableView.dataSource=self;
        _tableView.delegate=self;
        _tableView.frame=CGRectMake(0, 0, KIphoneWidth, KIphoneHeight);
        [self.view addSubview:_tableView];
    }

    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[[NSMutableArray alloc]init];
    }
    return _dataArray;

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
