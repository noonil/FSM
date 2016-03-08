//
//  HelpDocViewController.m
//  Ericsson
//
//  Created by admin on 15/12/10.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HelpDocViewController.h"

@interface HelpDocViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *helpDoc;
- (IBAction)back:(id)sender;

@end

@implementation HelpDocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *helpDoc=[[UIWebView alloc]init];
     NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)back:(id)sender {
}
@end
