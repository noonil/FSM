

//
//  HistorywarningViewController.m
//  Ericsson
//
//  Created by 陶山强 on 15/10/14.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "HistorywarningViewController.h"
#import "HistoryTableViewController.h"
@interface HistorywarningViewController ()<UITextFieldDelegate>
- (IBAction)search:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@end

@implementation HistorywarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询历史告警";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)search:(id)sender {
    HistoryTableViewController *htVC=[[HistoryTableViewController alloc]initWithNibName:@"HistoryTableViewController" bundle:nil];
    htVC.name2=_nameTextField.text;
    [self.navigationController pushViewController:htVC animated:YES];
}
@end
