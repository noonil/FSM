//
//  FSMNavigationController.m
//  Ericsson
//
//  Created by 范传斌 on 15/10/9.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "FSMNavigationController.h"

@interface FSMNavigationController ()

@end

@implementation FSMNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //这时push进来的不是跟控制器，隐藏底部导航栏
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        
        //设置返回按钮
//        viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:nil action:nil];
        
        UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"notice_number.png"]  style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        [leftItem setTintColor:[UIColor whiteColor]];
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }
    
    [super pushViewController:viewController animated:animated];
}

-(void)back{
    [self popViewControllerAnimated:YES];
}

@end
