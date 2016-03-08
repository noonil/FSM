//
//  MainViewController.m
//  Ericsson
//
//  Created by 范传斌 on 15/9/28.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "MainViewController.h"
#import "SettingViewController.h"
#import "HomeViewController.h"
#import "FSMNavigationController.h"
#import "FMDatabase.h"
#import "CompressAndEncrypt.h"
#import "LKDBHelper.h"
#import "RepositoryViewController.h"
#import "EricssonTabBar.h"

@interface MainViewController ()<EricssonTabBarDelegate>

@end

@implementation MainViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //实现状态栏和导航栏背景分别设置
    self.edgesForExtendedLayout=UIRectEdgeNone;
    UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 20)];
    statusBarView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:statusBarView];
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    //设置子控制器
    HomeViewController *home = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    home.view.backgroundColor = [UIColor whiteColor];
    [self addChildVc:home Title:@"首页" image:@"main" selectedImage:@"main_choosed"];
    
    RepositoryViewController *information = [[RepositoryViewController alloc] init];
    information.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [self addChildVc:information Title:@"知识库" image:@"information" selectedImage:@"information_choosed"];
    
//    SecurityResponseViewController *security = [[SecurityResponseViewController alloc] init];
//    security.view.backgroundColor = KBaseGray;
//    [self addChildVc:security Title:@"安全响应" image:@"my" selectedImage:@"my_choosed"];
    
    SettingViewController *setting = [[SettingViewController alloc] init];
    setting.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    [self addChildVc:setting Title:@"设置" image:@"set" selectedImage:@"set_choosed"];
    
    //异步处理数据库更新
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[SynchronizeDataManager shareManager] DBCheck];
    });
    
    //更改系统自带的tabbar
    EricssonTabBar *tabBar = [[EricssonTabBar alloc] init];
    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    
}

#pragma -mark- 实现TabBarDelegate的代理方法
-(void)SecurityResponseButtonClick:(UIButton *)btn{
    if (!btn.selected) {
        [self.view makeToast:@"当前没有需要响应的消息"];
    }
    else{
        [self securityLoadData:btn];
    }
}
//安全响应
-(void)securityLoadData:(UIButton *)btn{
    /**
     requestData   :{
        “securityInfos”:[{
            “recordId”:”XXX”,    主键id
            “sysSendTime”:”XXX”  系统发送时间
            “sysSendContent:”XXX”  系统发送时间
            “sendCount”:”XXXX”   发送次数
            “sendStatus”:”XXXX”,  发送状态 1表示成功
            }]
        }
     */
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"securityInfos"]) {
        [params setObject:[[NSUserDefaults standardUserDefaults] valueForKey:@"securityInfos"] forKey:@"securityInfos"];
    }
    
    NSString *sopeStr = [[SoapUtility shareInstance] BuildSoapWithModelName:@"FSMBase" methodName:@"FSMSecurityConfirm" sessonId:KSessionId requestData:params];
    
    [[SoapService shareInstance] PostAsync:sopeStr Success:^(NSDictionary *dic) {
        NSLog(@"dddd = %@",dic);
        if ([dic[@"retCode"] isEqual:@0]) {
            [self.view makeToast:@"安全响应成功"];
            btn.selected = NO;
        }
        
    } falure:^(NSError *response) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//重构代码，重复代码放到方法中，不同内容作为参数
- (void)addChildVc:(UIViewController *)childVc Title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置子控制器的文字和图片
    childVc.title = title;
    
    //    childVc.view.backgroundColor = [UIColor yellowColor];
    childVc.tabBarItem.title = title;
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    NSMutableDictionary *selectedTextAttrs = [NSMutableDictionary dictionary];
    selectedTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:33/255.0 green:118/255.0 blue:188/255.0 alpha:1.0];
    
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
    
    FSMNavigationController *nav = [[FSMNavigationController alloc] initWithRootViewController:childVc];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    nav.navigationBar.titleTextAttributes = attrs;
    
//    [nav.navigationBar setBarTintColor:[UIColor colorWithRed:33/255.0 green:118/255.0 blue:188/255.0 alpha:1.0]];
//    nav.navigationBar.barTintColor = KBackgroundBlue;
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"homebackground"] forBarMetrics:UIBarMetricsDefault];

    
    [self addChildViewController:nav];
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
