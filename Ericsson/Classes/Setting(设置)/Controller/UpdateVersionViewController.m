//
//  UpdateVersionViewController.m
//  Ericsson
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 范传斌. All rights reserved.
//

#import "UpdateVersionViewController.h"


@interface UpdateVersionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UITextView *versionTA;

@end

@implementation UpdateVersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.versionTA.text=[self.updatedic objectForKey:@"updateInfo"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelClick:(id)sender {
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeBkView" object:nil];
}
- (IBAction)confirmClick:(id)sender {
    [self.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeBkView" object:nil];
//    NSString *urlstr = [self.updatedic objectForKey:@"downLoadUrl"];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downurl]];
    
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
