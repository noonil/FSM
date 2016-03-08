//
//  BaseViewController.m
//  Ericsson
//
//  Created by xuming on 15/12/11.
//  Copyright (c) 2015年 范传斌. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
@interface BaseViewController ()



@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


    [self others];


    
    


}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.currentVC = self;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    AppDelegate *delegate =(AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.currentVC = nil;
}
-(void)others{
    currentPage = 1;
    
    NSUserDefaults *defaulsts = [NSUserDefaults standardUserDefaults];
    sessonId = [defaulsts objectForKey:@"sessionId"];
    userId = [defaulsts objectForKey:@"userId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 键盘隐藏








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
