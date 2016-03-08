//
//  GatherViewController.m
//  Ericsson
//
//  Created by xuming on 16/2/18.
//  Copyright © 2016年 范传斌. All rights reserved.
//

#import "GatherViewController.h"
#import "GatherObject.h"
#import "GatherCellFrame.h"
#import "GatherCell.h"
#import "PopupObjectList.h"
#import "GatherAttributeModel.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能的头文件
#import "RMDateSelectionViewController.h"



@interface GatherViewController ()<GatherCellDelegate,PopupObjectListDelegate,BMKLocationServiceDelegate, UIAlertViewDelegate, UIGestureRecognizerDelegate>{

    PopupObjectList *pop;
    BMKLocationService * locService;
    
    double latitude;
    double longitude;
    
    GatherCell *latCell;
    GatherCell *lonCell;
}
@property (nonatomic, strong) NSMutableArray *gatherCellFrameArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)upload_TouchDown:(id)sender;
- (IBAction)fillTextFieldAddress_TouchDown:(id)sender;

@end

@implementation GatherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setOthers];
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setOthers{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"资源变更";
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelection=NO;
    
    locService = [[BMKLocationService alloc]init];
    locService.delegate = self;
    
    [self addTapGesture];


}

#pragma mark -隐藏键盘

-(void)handleSingleTap{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];

    
}

-(void)addTapGesture{
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
    [self.view addGestureRecognizer:singleTap];
    singleTap.delegate = self;
}


- (void) loadData
{
    //请求数据示例
    [MBProgressHUD showMessage:KHudIsRequestMessage];
    
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessonId = [defaulsts objectForKey:@"sessionId"];
    NSString *userId = [defaulsts objectForKey:@"userId"];
    
    NSDictionary *params = @{@"userId":userId,
                             @"resType":_resType
                             };
    
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"queryResInfoList" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        if ([dic[@"retCode"]  isEqual: @0]) {
            
            NSMutableArray *newFrames=[NSMutableArray array];
            
            NSMutableArray *dataArray =[GatherObject objectArrayWithKeyValuesArray: dic[@"objectList"]];
            
            NSMutableArray *dataArrayIsnullY=[NSMutableArray array];//非必填项
            NSMutableArray *dataArrayIsnullN=[NSMutableArray array];//必填项
            
            
            for (GatherObject *model in dataArray) {
                if ([model.isnull isEqualToString:@"Y"])
                    [dataArrayIsnullY addObject:model];
                else
                    [dataArrayIsnullN addObject:model];
            }
            
            
            //添加必填的model
            for (GatherObject *model in dataArrayIsnullN) {
                GatherCellFrame *gatherCellFame = [[GatherCellFrame alloc]init];
                gatherCellFame.gatherObject=model;
                [newFrames addObject:gatherCellFame];
            }
            //添加非必填的model
            for (GatherObject *model in dataArrayIsnullY) {
                GatherCellFrame *gatherCellFame = [[GatherCellFrame alloc]init];
                gatherCellFame.gatherObject=model;
                [newFrames addObject:gatherCellFame];
            }
            
            
            //把创建的frame数组，赋值给全局数组。
            self.gatherCellFrameArray=newFrames;
            
            [_tableView reloadData];
            
            
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        
    } falure:^(NSError *err) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUD];
        });
        
        
    }];
    
}

/*提交数据*/
- (void) uploadData
{
    //请求数据示例
    [MBProgressHUD showMessage:KHudIsUpdataMessage];
    
    NSMutableDictionary *params=[NSMutableDictionary dictionary];

    NSMutableArray *paramArr=[NSMutableArray array];
    for (GatherCellFrame *frame in _gatherCellFrameArray) {
        
        GatherObject *model=frame.gatherObject;
        
        //如果没有填值，跳到下一个。
        NSLog(@"enname=%@,value=%@,",model.enfield,model.value);

        if ([model.enfield isEqualToString:@"LONGITUDE"]) {
            NSLog(@"LONGITUDE=%@",model.value);
        }
        
        //如果不是必填项
        if (model.value==nil && [model.isnull isEqualToString:@"Y"]) {
            continue;
        }
        //如果是必填项
        if (model.value==nil && [model.isnull isEqualToString:@"N"]) {
            
         UIAlertView *alertView=   [[UIAlertView alloc]initWithTitle:nil message:@"必填项没有填全！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alertView show];
            
            [MBProgressHUD hideHUD];
            return;
        }


        NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];

        [paramDic setObject:model.tablename forKey:@"tablename"];
        [paramDic setObject:model.datatype forKey:@"datatype"];
        [paramDic setObject:model.value forKey:@"value"];
        [paramDic setObject:model.enfield forKey:@"enfield"];
        [paramArr addObject:paramDic];

    }
    [params setObject:paramArr forKey:@"objectList"];

    
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessonId = [defaulsts objectForKey:@"sessionId"];
    
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMInformation" methodName:@"insertCollectResouce" sessonId:sessonId requestData:params];
    
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];

        if ([dic[@"retCode"]  isEqual: @0]) {
        
            [self.view makeToast:KHudSuccessMessage];
            
        }
        
        else if ([dic[@"retCode"]  isEqual: @(-1)]) {
            [self.view makeToast:KHudResponse1];
        }
            
        else if ([dic[@"retCode"]  isEqual: @(-2)]) {
            [self.view makeToast:KHudResponse2];
        }

        
    } falure:^(NSError *err) {
        [MBProgressHUD hideHUD];
        [self.view makeToast:KHudErrorMessage];
    }];
    
}


#pragma mark -table delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 70;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.gatherCellFrameArray count];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GatherCell *cell=[GatherCell cellWithTableView:tableView];
    cell.gatherCellFrame=self.gatherCellFrameArray[indexPath.row];
    cell.tag=indexPath.row;
    cell.delegate=self;
    
    
    //如果是经纬度cell，记录一下，获取经纬度的时候，给cell赋值用。

    GatherObject *model=cell.gatherCellFrame.gatherObject;
    if ([model.enfield isEqualToString:@"LATITUDE"]) {
        latCell=cell;
    }
    else if ([model.enfield isEqualToString:@"LONGITUDE"]) {
        lonCell=cell;
    }
    
    return cell;
    
    
}


#pragma mark - GatherCell delegate
-(void)gatherCellTextFieldDidEndEditing:(GatherCell *)gatherCell{
    
    //修改_gatherCellFrameArray数组里存放的model的value值。
    GatherCellFrame *frame=_gatherCellFrameArray[gatherCell.tag];
    frame.gatherObject.value=gatherCell.textField.text;
    
    
}

-(void)gatherCellButtonDidTouchDown:(GatherObject *)gatherObject cell:(GatherCell *)cell{
    NSArray *array=gatherObject.selectDatas;
    NSMutableArray *nameArray=[NSMutableArray new];
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        [nameArray addObject:dic[@"name"]];
    }
    
    pop=[[PopupObjectList alloc]initWithData:nameArray selectedData:cell.textField.text fromWhichObject:cell];
    pop.delegate=self;
    [pop presentPopupControllerAnimated];
}

-(void)gatherCellInputDate:(GatherCell *)cell{

    
    //Create select action
    RMAction *selectAction = [RMAction actionWithTitle:@"确认" style:RMActionStyleDone andHandler:^(RMActionController *controller) {
        
                cell.textField.text = [self stringFromDate:((UIDatePicker *)controller.contentView).date];
        
    }];
    
    //Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"取消" style:RMActionStyleCancel andHandler:^(RMActionController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Create date selection view controller
    RMDateSelectionViewController *dateSelectionController = [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleDefault selectAction:selectAction andCancelAction:cancelAction];
    
    dateSelectionController.title = @"录入时间选择";
    
    
    //Now just present the date selection controller using the standard iOS presentation method
        [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (NSString*)stringFromDate:(NSDate*)date
{
    NSDateFormatter * fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString * dateStr = [fmt stringFromDate:date];
    return dateStr;
}


#pragma mark -PopupObjectListDelegate

-(void)popupObjectListDidSelectRowAtIndexPath:(NSString *)selectedData fromWhichObject:(id)fromWhichObject row:(NSInteger)row{
    
    GatherCell *gatherCell=(GatherCell *)fromWhichObject;
    gatherCell.textField.text=selectedData;
    
    
    //修改_gatherCellFrameArray数组里存放的model的value值。
    GatherCellFrame *frame=_gatherCellFrameArray[gatherCell.tag];
    frame.gatherObject.chineseValue=gatherCell.textField.text;
    
    //找到中文值对应的编码值
    NSArray *array=gatherCell.gatherCellFrame.gatherObject.selectDatas;
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=array[i];
        if ([dic[@"name"] isEqualToString:selectedData]) {
            frame.gatherObject.value=dic[@"value"];
            break;
        }
    }
    
}


#pragma -mark IbAction
- (IBAction)fillTextFieldAddress_TouchDown:(id)sender {
    
    [MBProgressHUD showMessage:@"经纬度获取中"];

    // 启动LocaltionSerview
    [locService startUserLocationService];
    
    
    


}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    latitude = userLocation.location.coordinate.latitude;
    longitude = userLocation.location.coordinate.longitude;
    NSLog(@"1===%f",latitude);
    NSLog(@"2===%f",longitude);
    
    for (GatherCellFrame *frame in _gatherCellFrameArray) {
        GatherObject *model =frame.gatherObject;
        
        if ([model.enfield isEqualToString:@"LATITUDE"]) {
            model.value=[NSString stringWithFormat:@"%F", latitude];
        }
        else if ([model.enfield isEqualToString:@"LONGITUDE"]) {
            model.value=[NSString stringWithFormat:@"%F", longitude];
            
        }
    }
    
    latCell.textField.text=[NSString stringWithFormat:@"%F", latitude];
    lonCell.textField.text=[NSString stringWithFormat:@"%F", longitude];
    
    [locService stopUserLocationService];

    
    
    [MBProgressHUD hideHUD];

    
    
}
- (IBAction)upload_TouchDown:(id)sender {

    [self uploadData];
}


@end
