//
//  SettingViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/9/29.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewCell.h"
#import "ChangePwdViewController.h"
#import "SecurityLogViewController.h"
#import "AttachmentUploadSetViewController.h"
#import  "GPSUpLoadFrequencySetViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "UpdateVersionViewController.h"
#import "shareCodeViewController.h"
#import "BkView.h"
#import "versionIntroduceViewController.h"
#import "mediaViewController.h"
#import "TimerService.h"


@interface SettingViewController ()<UIAlertViewDelegate>{
    UIAlertView *alert;
    
}

@property (nonatomic,strong)NSArray *items;
@property (nonatomic,strong)NSDictionary *dic1;
@property (nonatomic,strong)BkView *bkView;
@end

static int idx=0;

@implementation SettingViewController

-(NSArray *)items
{
    if (!_items) {
        NSString *itemsFile = [[NSBundle mainBundle] pathForResource:@"SettingItems.plist" ofType:nil];
        _items = [NSArray arrayWithContentsOfFile:itemsFile];
    }
    return _items;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(bkviewRemove:) name:@"removeBkView" object:nil];
    //self.dicupdate=[[NSMutableDictionary alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KIphoneWidth, KIphoneHeight)];
    self.tableView .dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.tableView];

}
-(void)bkviewRemove:(NSNotification *)notify{
    [self.bkView removeFromSuperview];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingViewCell *cell = [SettingViewCell cellWithTableView:tableView];
    
    NSDictionary *item = self.items[indexPath.row];
    
    cell.icon.image = [UIImage imageNamed:item[@"icon"]];
    cell.item.text = item[@"name"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.row == 0) {
        ChangePwdViewController *changePwd = [[ChangePwdViewController alloc] initWithNibName:@"ChangePwdViewController" bundle:nil];
        [self.navigationController pushViewController:changePwd animated:YES];
    }else if(indexPath.row == 1){
        SecurityLogViewController *securityLog = [[SecurityLogViewController alloc] init];
        [self.navigationController pushViewController:securityLog animated:YES];
    }else if (indexPath.row == 2){
//        mediaViewController *media = [[mediaViewController alloc] initWithNibName:@"mediaViewController" bundle:nil];;
//        [self.navigationController pushViewController:media animated:YES];
        
        AttachmentUploadSetViewController *uploadSet = [[AttachmentUploadSetViewController alloc] initWithNibName:@"AttachmentUploadSetViewController" bundle:nil];
        [self.navigationController pushViewController:uploadSet animated:YES];
    }else if (indexPath.row == 3){
        GPSUpLoadFrequencySetViewController *GPSUp = [[GPSUpLoadFrequencySetViewController alloc] initWithNibName:@"GPSUpLoadFrequencySetViewController" bundle:nil];
        [self.navigationController pushViewController:GPSUp animated:YES];
        
        
    }else if (indexPath.row == 4){
        shareCodeViewController *share = [[shareCodeViewController alloc] initWithNibName:@"shareCodeViewController" bundle:nil];
        [self.navigationController pushViewController:share animated:YES];
    }else if (indexPath.row == 5){
        
        [self json];
        
    }else if (indexPath.row == 6){
        versionIntroduceViewController *intro = [[versionIntroduceViewController alloc] initWithNibName:@"versionIntroduceViewController" bundle:nil];
        [self.navigationController pushViewController:intro animated:YES];

    }else if (indexPath.row == 7){
        [self finish];
    }


}


-(void)json{
    //请求数据示例
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    //NSString *userId = [defaulsts objectForKey:@"username"];
    NSString *sessionId = [defaulsts objectForKey:@"sessionId"];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *myVersion = [infoDict objectForKey:@"CFBundleShortVersionString"];
    NSArray *arr = [myVersion componentsSeparatedByString:@"."];
    long myversionNum = [arr[0] intValue]*10000+[arr[1] intValue]*100+[arr[2] intValue];
    NSString *myVersionStr = [NSString stringWithFormat:@"%ld",myversionNum];
    NSDictionary *params = @{@"sessionId":sessionId,
                             @"appVersion":myVersionStr,
                             @"appType":@"1"};
    
    NSString *modelName=@"FSMBase";
    NSString *methodName=@"FSMVersionCheck";
    NSString *sessonId= sessionId;
    
    NSString *sopeStr=
    [[SoapUtility shareInstance] BuildSoapWithModelName:modelName methodName:methodName sessonId:sessonId requestData:params];
    NSLog(@"sopeStr:%@",sopeStr);
    
    [MBProgressHUD showMessage:@"正在请求最新版本信息"];
    //异步请求
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        [MBProgressHUD hideHUD];
        
        if ([dic[@"retCode"] isEqual:@0]) {
            [MBProgressHUD showSuccess:@"请求最新版本信息成功"];
            
            NSString *current_version=[dic objectForKey:@"hasNewVersion"];
        
            int i=[current_version intValue];
            
            if (i<1) {
                [self updatealert];
            }else{
                UpdateVersionViewController *updateversion=[[UpdateVersionViewController alloc]initWithNibName:@"UpdateVersionViewController" bundle:nil];
                updateversion.updatedic=[dic mutableCopy];
                updateversion.view.center = self.view.center;
                updateversion.view.frame = CGRectMake((self.view.frame.size.width - updateversion.view.frame.size.width)/2, 0, updateversion.view.frame.size.width, updateversion.view.frame.size.height);
                
                BkView *bkview = [[BkView alloc]init];
                bkview.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                updateversion.view.center = bkview.center;
                [bkview addSubview:updateversion.view];
                self.bkView = bkview;
                [self addChildViewController:updateversion];
                [self.view addSubview:self.bkView];


//            [self.navigationController pushViewController:updateversion animated:YES];
            }
            
            
           
        }else if ([dic[@"retCode"] isEqual:@(-1)]){
            
            [MBProgressHUD showError:@"请求最新版本信息失败"];
            
        }else if ([dic[@"retCode"] isEqual:@(-2)]){
            UIViewController *rootViewController = [UIStoryboard storyboardWithName:@"Main" bundle:nil].instantiateInitialViewController;
            [UIApplication sharedApplication].keyWindow.rootViewController = rootViewController;
            [MBProgressHUD showError:@"请求最新版本信息超时，请重新请求"];
            
        }
    } falure:^(NSError *err) {
        //        NSLog(@"error:%@",err);
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:[NSString stringWithFormat:@"尝试最新版本信息发送失败,err:%@",err]];
    }];
    
}


-(void)updatealert{
    alert=[[UIAlertView alloc]initWithTitle:@"版本更新" message:@"当前版本为最新版本啦！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    //设置属性
    alert.alertViewStyle=UIAlertViewStyleDefault;
    alert.delegate=self;
    [alert show];
    
}

-(void)finish{
    alert=[[UIAlertView alloc]initWithTitle:@"用户注销" message:@"确定并退出注销当前用户吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1001;
    //设置属性
    alert.alertViewStyle=UIAlertViewStyleDefault;
    alert.delegate=self;
    [alert show];
    
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
        switch (buttonIndex) {
            case 0:
            
            break;
            
        case 1:
                //如果是注销用户
                if (alert.tag==1001) {
                    
                    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                    [defaults setValue:@"" forKey:@"password"];
                    [defaults setValue:@"" forKey:@"username"];
                    
                    [[TimerService shareInstance] stopTimer];
                    
                    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

                    UIStoryboard *story=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    ViewController *intro=[story instantiateViewControllerWithIdentifier:@"view"];
                    intro.isFromSetting = YES;
                    [self presentViewController:intro animated:YES completion:^{
                        
                    }];


                }
            
            break;
    
    }
}





@end
