//
//  DelayStartViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/11.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "DelayStartViewController.h"
#import "RejectReason.h"
#import "RejectReasonsView.h"
#import "WorkOrder.h"
#import "UnAccpetedOrderViewController.h"
#import "HandlingOrderViewController.h"


@interface DelayStartViewController ()<RejectReasonChooseDelegate, UIGestureRecognizerDelegate>

@property (nonatomic,strong)NSMutableArray *delayReasons;

@property (nonatomic,strong)RejectReason *selectedReason;

- (IBAction)ChooseReason:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *reasonBtn;
- (IBAction)delayReasonCommit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *CommitBtn;
@property (weak, nonatomic) IBOutlet UITextView *reasonDescTextView;
//稍后出发原因选择弹出框
@property (nonatomic,strong)FDAlertView *alert;
@end

@implementation DelayStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"稍后出发原因";
    
    //加载稍后出发原因(数据库读取)
    self.delayReasons = [self queryDelayReasons];
    
    self.alert = [[FDAlertView alloc] init];
    

    
    [self addGesture];
}

-(void)addGesture{
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handle:)];
    [self.view addGestureRecognizer:tapRecognizer];//关键语句，给self.view添加一个手势监测；
    tapRecognizer.delegate = self;

}

-(void)viewDidAppear:(BOOL)animated{

   // NSLog(@"===%@",NSStringFromCGRect(self.view.frame));
}

-(void)handle:(UITapGestureRecognizer*)recognizer {

    [_reasonDescTextView resignFirstResponder];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)queryDelayReasons{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    NSMutableArray *delayReasons = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        NSString * sql = @"select * from startLaterReasons";
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            RejectReason *reason = [[RejectReason alloc] init];
            reason.reasonId = [rs stringForColumn:@"reasonId"];
            reason.reasonName = [rs stringForColumn:@"reasonName"];
            
            [delayReasons addObject:reason];
        }
        [db close];
    }
    return delayReasons;
}

- (IBAction)ChooseReason:(UIButton *)sender {
    [self.view endEditing:YES];

    //弹出稍后出发原因列表
    RejectReasonsView *contentView = [[[NSBundle mainBundle] loadNibNamed:@"RejectReasonsView" owner:nil options:nil] lastObject];
    [contentView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 300)];
    
    contentView.rejectReasons = self.delayReasons;
    
    contentView.delegate = self;
    self.alert.contentView = contentView;
    [self.alert show];
}

- (IBAction)delayReasonCommit:(UIButton *)sender {
    if (self.selectedReason == nil) {
        [MBProgressHUD showError:@"请选择稍后出发原因"];
        return;
    }
    
    if (self.reasonDescTextView.text.length <= 0) {
        [MBProgressHUD showError:@"请填写具体稍后出发原因说明"];
        return;
    }
    
    //发送拒收请求
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSMutableArray *woIds = [[NSMutableArray alloc] init];
    if (self.workOrders && self.workOrders.count > 0) {
        for (WorkOrder *workOrder in self.workOrders) {
            [woIds addObject:workOrder.woId];
        }
    }
    
    NSDictionary *params = @{@"userId":userId,@"woIds":woIds,@"reasonId":self.selectedReason.reasonId,@"reason":self.reasonDescTextView.text,@"localTs":currentDateStr,@"processId":@"0",@"operMBPS":@"稍后出发",@"taskName":@"出发"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMDepartLater";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送稍后出发请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
//            NSLog(@"受理成功并选择稍后出发");
            HandlingOrderViewController *vc=[[HandlingOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            [self.navigationController.view makeToast:@"请求成功"];
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

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - RejectReasonChooseDelegate
-(void)RejectReasonDidSelected:(RejectReason *)reason{
    self.selectedReason = reason;
    [self.reasonBtn setTitle:reason.reasonName forState:UIControlStateNormal];
}
@end
