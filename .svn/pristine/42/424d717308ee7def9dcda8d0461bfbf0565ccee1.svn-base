//
//  RejectOrderController.m
//  Ericsson
//
//  Created by 范传斌 on 15/12/4.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "RejectOrderController.h"
#import "RejectReasonsView.h"
#import "MBProgressHUD.h"
#import "RejectReason.h"
#import "WorkOrder.h"
#import "UnAccpetedOrderViewController.h"

@interface RejectOrderController ()<RejectReasonChooseDelegate>
@property (nonatomic,strong)NSMutableArray *rejectReasons;

@property (nonatomic,strong)RejectReason *selectedReason;
- (IBAction)ChooseReason:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *reasonBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITextView *reasonDescTextView;


- (IBAction)RejectCommit:(id)sender;
@end

@implementation RejectOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //加载拒收原因(数据库读取)
    self.rejectReasons = [self queryRejectReasons];
    self.title=@"拒收原因";
    
    //处理提交按钮位置
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.commitBtn.y = keyboardRect.origin.y - (50 + 64);
    });
    
}

- (NSMutableArray *)queryRejectReasons{
    FMDatabase * db = [FMDatabase databaseWithPath:DBPATH];
    NSMutableArray *rejectReasons = [[NSMutableArray alloc] init];
    
    if ([db open]) {
        NSString * sql = @"select * from woRejectReasons";
        FMResultSet * rs = [db executeQuery:sql];
        
        while ([rs next]) {
            RejectReason *reason = [[RejectReason alloc] init];
            reason.reasonId = [rs stringForColumn:@"reasonId"];
            reason.reasonName = [rs stringForColumn:@"reasonName"];
            
            [rejectReasons addObject:reason];
        }
        [db close];
    }
    return rejectReasons;
}

- (IBAction)ChooseReason:(UIButton *)sender {
    [self.view endEditing:YES];

    //弹出拒收原因选择列表
    FDAlertView *alert = [[FDAlertView alloc] init];
    RejectReasonsView *contentView = [[[NSBundle mainBundle] loadNibNamed:@"RejectReasonsView" owner:nil options:nil] lastObject];
    [contentView setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, 300)];
    
    contentView.rejectReasons = self.rejectReasons;
    contentView.delegate = self;
    alert.contentView = contentView;
    [alert show];
}

#pragma mark - RejectReasonChooseDelegate
-(void)RejectReasonDidSelected:(RejectReason *)reason{
    self.selectedReason = reason;
    [self.reasonBtn setTitle:reason.reasonName forState:UIControlStateNormal];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (IBAction)RejectCommit:(id)sender {
    if (self.selectedReason == nil) {
        [MBProgressHUD showError:@"请选择拒收原因"];
        return;
    }
    
    //发送拒收请求
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    NSDictionary *params = @{@"userId":userId,@"woId":self.workOrder.woId,@"rejectReasonId":self.selectedReason.reasonId,@"rejectReason":self.reasonDescTextView.text,@"localTs":currentDateStr,@"processId":@"0",@"operMBPS":@"拒收",@"taskName":@"拒收"};
    
    NSString *modelName=@"FSMworkOrder";
    NSString *methodName=@"FSMRejectWO";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在发送工单拒收请求"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        if ([dic[@"retCode"] isEqual:@0]) {
//            NSLog(@"拒收成功");
            [self.navigationController popToViewController:self.rootController animated:YES];
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
@end
