//
//  ApplyStateList.m
//  Ericsson
//
//  Created by xuming on 15/12/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "ApplyStateList.h"
#import "MJExtension.h"
#import "NetResourceApplyChange.h"
#import "ThreeLabelCell.h"
#import "ApplyStateDetail.h"
#import "AttributeModifyInfo.h"


@interface ApplyStateList ()
{
    NSString *sessonId;

}

@property (nonatomic, assign)int currentPage;   //记录当前页码
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation ApplyStateList

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOthers];
    
    [self loadApplyStateData];
}
-(void)setOthers{
    self.title = @"资源属性变更申请列表";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    
    [self.tableView addHeaderWithTarget:self action:@selector(reloadResources)];
    [self.tableView addFooterWithTarget:self action:@selector(reloadNewResources)];
    
    
    self.currentPage = 1;
    
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    sessonId = [defaulsts objectForKey:@"sessionId"];

}


- (void)reloadResources{
    self.currentPage = 1;
    [self loadApplyStateData];
}

- (void)reloadNewResources{
    self.currentPage ++;
    [self loadApplyStateData];
}

#pragma mark -request Data
- (void)loadApplyStateData
{
    //请求数据示例
    
    NSDictionary *params = @{ @"pageIdx":@(self.currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMQueryMaintenanceAboutAppliedAttr" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSArray *dataArray = [NetResourceApplyChange objectArrayWithKeyValuesArray:dic[@"maintenaceAboutAttrList"]];
            if (self.currentPage == 1) {
                [self.dataArray removeAllObjects];
            }
            
            [self.dataArray addObjectsFromArray:dataArray];
            [self.tableView reloadData];
            //            NSLog(@"dic:%@",dic);
            
            if (dataArray == nil || dataArray.count == 0) {
                self.currentPage --;
            }
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    } falure:^(NSError *err) {
        if (self.currentPage > 1) {
            self.currentPage --;
        }
        [self.tableView headerEndRefreshing];
        [self.tableView footerEndRefreshing];
    }];
    
}

- (void)loadApplyStateDetailData:(NSString *)recordId
{
    //请求数据示例
    
    NSDictionary *params = @{@"recordId":recordId, @"pageIdx":@(self.currentPage)};
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"FSMQueryAttrApplyState" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"]  isEqual: @0]) {
            NSMutableArray *dataArray = [AttributeModifyInfo objectArrayWithKeyValuesArray:dic[@"attrApplyStateList"]];
            
            ApplyStateDetail *vc = [[ApplyStateDetail alloc] initWithNibName:@"ApplyStateDetail" bundle:nil];
            vc.dataArray=dataArray;
            vc.recordId=recordId;
            [self.navigationController pushViewController:vc animated:YES];
        }

    } falure:^(NSError *err) {

    }];
    
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NetResourceApplyChange *data = self.dataArray[indexPath.row];
    
    ThreeLabelCell *cell = [ThreeLabelCell cellWithTableView:tableView];
    cell.resourchNameLabel.text = data.maintenanceName;
    cell.stateLabel.text = data.State;
    cell.dateLabel.text =  data.submitTime;
    
    return cell;
}

- (NSString *)iconNameWithResourceType:(NSString *)type{
    if ([type containsString:@"发电"]) {
        return @"wo_elect";
    }else if ([type containsString:@"故障"]){
        return @"wo_tr";
    }else
        return @"wo_with";
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NetResourceApplyChange *model = self.dataArray[indexPath.row];

    [self loadApplyStateDetailData:model.recordId];

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

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
