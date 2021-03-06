//
//  ActiveDetailViewController.m
//  Ericsson
//
//  Created by admin on 15/12/8.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "ActiveDetailViewController.h"
#import "SoapService.h"
#import "MBProgressHUD.h"
#import "HelpObjectList.h"
#import "TechnicalManualDetailViewController.h"
@interface ActiveDetailViewController ()<MBProgressHUDDelegate,HelpObjectListDelegate>
{
    MBProgressHUD *hud;
    HelpObjectList *pop;
    NSMutableArray *dataArray1;
    NSMutableArray *techManuaArr;
}
- (IBAction)doc:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *requestID;
@property (weak, nonatomic) IBOutlet UILabel *requestTitle;
@property (weak, nonatomic) IBOutlet UILabel *detailName;
@property (weak, nonatomic) IBOutlet UILabel *detailLevel;
@property (weak, nonatomic) IBOutlet UILabel *detailTime;
@property (weak, nonatomic) IBOutlet UILabel *detailType;
@property (weak, nonatomic) IBOutlet UILabel *detailClass;
@end

@implementation ActiveDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    techManuaArr = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presentwebviewNotification:) name:@"presentwebviewNotification" object:nil];
    self.title=@"告警详情";
    [self loadAlertData];
    dataArray1 = [NSMutableArray array];
}
/*
 
 requestModel  :  FSMInformation模块名
 requestMethod  : queryAlertInfoDetail方法名
 
 sessionId     :   会话id
 requestData   :{
 "searchHistRecord":false,  // 是否是查询历史告警的详细信息
 "id":””   告警id
 }
 
 响应数据值
 含义
 {
 “retCode”:”x” ;     0:请求成功  -1:请求失败  -2:回话sessionId 失效
 "alertInfoDetail":{
 "name":"栾城大酒店2-9",      名称
 "fp":"75097331",            告警唯一标识
 "subAlarmType":"其他告警",    告警类型
 "alarmNeTypeName":"UTRANCELL",    告警网元级别
 "time":"2015-08-04 03:42:25.0",         时间
 "title":"13UtranCell_ServiceUnavailable",   标题
 "alarmClass":"重大"              严重级别
 }
 }

*/
-(void)presentwebviewNotification:(NSNotification *)notify{
    TechnicalManualDetailViewController *webView = [[TechnicalManualDetailViewController alloc] init];
    
    techManuaArr = notify.object;
    
    for (NSDictionary *techManuaDic in techManuaArr) {
        NSString *techName = techManuaDic[@"techName"];
        NSString *techUrl = techManuaDic[@"techUrl"];
        
        if ([techName isEqualToString:dataArray1[0][@"title"]]) {
            webView.urlStr = techUrl;
            [self presentViewController:webView animated:YES completion:nil];
        }
        
    }
    
    [self.view makeToast:@"抱歉！未找到相关文档"];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark -- loadAlertData
- (void)loadAlertData{
    //提示正在获取
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    hud.labelText = @"正在获取详细告警信息列表";
    hud.delegate=self;
    [hud show:YES];
    
    //准备请求参数
    NSString *modelName=@"FSMInformation";
    NSString *methodName=@"queryAlertInfoDetail";
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];

    //requestData是一个字典类型的参数  把参数与值一一对应存入数组中
    NSMutableDictionary *parmeters = [NSMutableDictionary dictionary];
    
    //传false 和 true要看是否是查询历史警告
    if (self.historyView == nil) {
        [parmeters setValue:@"false" forKey:@"searchHistRecord"];
    }
    else{
        [parmeters setValue:@"true" forKey:@"searchHistRecord"];
    }
    
    //告警ID
    [parmeters setValue:_ID forKey:@"id"];
    NSString *sopeStr1= [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessionId requestData:parmeters];
    
    NSLog(@"sopeStr1:%@",sopeStr1);
    
    //最后，异步请求
    [[SoapService shareInstance] PostAsync:sopeStr1 Success:^(NSDictionary *dic) {
        
        if ([dic[@"retCode"] isEqual:@0]) {//返回正确
            
            hud.hidden = YES;
            
            //将请求到的数据加入数组中
        [dataArray1 addObject:dic[@"alertInfoDetail"]];
            NSLog(@"wwww%@",dataArray1);
            [self configureUI];
        }
        
    } falure:^(NSError *response) {
        NSLog(@"告警详细查询错误：%@",response);
    }];
    
    
}
- (void)configureUI{
    _requestID.text = dataArray1[0][@"fp"];
    _requestTitle.text=dataArray1[0][@"title"];
    _detailName.text=dataArray1[0][@"name"];
    _detailLevel.text=dataArray1[0][@"alarmNeTypeName"];
    _detailTime.text=dataArray1[0][@"time"];
    _detailType.text=@"其他类型";
    _detailClass.text=dataArray1[0][@"alarmClass"];
    NSLog(@"_requestID -- %@",_requestID.text);
   

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 帮助文档点击事件
- (IBAction)doc:(id)sender {
    NSMutableArray * dataArr=[[NSMutableArray alloc]initWithObjects:_requestTitle.text, nil];
    pop=[[HelpObjectList alloc]initWithData:dataArr selectedData:_requestTitle.text selectedObject:_requestTitle];
    pop.delegate=self;
    [pop presentPopupControllerAnimated];
    

}
@end
